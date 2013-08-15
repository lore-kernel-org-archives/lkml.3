Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3HOUi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:38:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51627 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265Ab3HOUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:38:55 -0400
Message-ID: <1376599117.11042.4.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] irq: Always define devm_{request_threaded,free}_irq()
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Aug 2013 22:38:37 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hBmfzqfqawIZh0U4keLB"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.83.48.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hBmfzqfqawIZh0U4keLB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

These functions are currently defined only if CONFIG_GENERIC_HARDIRQS
is enabled.  But they may still be needed on architectures with their
own IRQ management (e.g. s390).

References: https://buildd.debian.org/status/fetch.php?pkg=3Dlinux&arch=3Ds=
390&ver=3D3.11%7Erc4-1%7Eexp1&stamp=3D1376009959
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/Makefile     | 2 +-
 kernel/irq/Makefile | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 35ef118..ed2c9a9 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -79,7 +79,7 @@ obj-$(CONFIG_KPROBES) +=3D kprobes.o
 obj-$(CONFIG_KGDB) +=3D debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) +=3D hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) +=3D watchdog.o
-obj-$(CONFIG_GENERIC_HARDIRQS) +=3D irq/
+obj-y +=3D irq/
 obj-$(CONFIG_SECCOMP) +=3D seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) +=3D rcutorture.o
 obj-$(CONFIG_TREE_RCU) +=3D rcutree.o
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff1738..639b2e1 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,8 +1,10 @@
-
-obj-y :=3D irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychi=
p.o devres.o
+obj-y +=3D devres.o
+ifdef CONFIG_GENERIC_HARDIRQS
+obj-y +=3D irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychi=
p.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) +=3D generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) +=3D autoprobe.o
 obj-$(CONFIG_IRQ_DOMAIN) +=3D irqdomain.o
 obj-$(CONFIG_PROC_FS) +=3D proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) +=3D migration.o
 obj-$(CONFIG_PM_SLEEP) +=3D pm.o
+endif


--=-hBmfzqfqawIZh0U4keLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUg08Tee/yOyVhhEJAQqFMQ//WU8JztYkvAA/hOYYDEWXK+02+1J7XWsE
PdbSWD/4FqIrg3w2VvvMtCF9zMEfbYaJMx3LFi7g23A6W0Noly0ua6JTAhdbm1cB
fZ4MdwfknVB14gyj3xMRXnYh2AEwW4ZJv+jWG/1e7g10nrCk9zxTkDvmwjnKXztq
vB1wHlIP+7MITCXrkIkAAF349OmeK3m0Hrl4nYXLJ/BZaVloa/G6yWmqlL3nXqRI
ZSy+tuLYfPmfy9S6iwCyU6CXNxqQfbrbPM8hpOSQDXn3Jqw5MT3KbdSVz9C38D3i
DK9xArjg2iO1u6hgApxpYDNrqPIM0cC9Ix0HQ7Gofa4oAb1Od46XRlCtlU13wAzo
9tk1x6CFk36KICz6AbhnX+B1pF7Izy10fCMw4yHyq5KHWnjKFpHsXR0NVS1amLQX
lXUHHQJwneOZgHJgsR6RVIdL66sxjOvxQiRzLh8cwE8PoZ7aQD8Xvc13NAR+EpQu
MSg/vqS4N+GyLetztZuERSlFLTX2+cHFMLFl5Mrx8iLNTVRWp0toapodXaRYxXbi
/T9brYid4wKSGyrPdjlOXSxM6cli4F0exGHiO424p912HcPIGHd4CXfl/5awsYfr
VcvrnaiCJ8Oz8UlNLPtaRsKPWferjqGB4duE2bMERBbq3L/9FQxLVchqXZ+L1bTr
m1nVh6uf+qg=
=D0Wi
-----END PGP SIGNATURE-----

--=-hBmfzqfqawIZh0U4keLB--
