Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3I2Xxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:53:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37353 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab3I2Xxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:53:39 -0400
Message-ID: <1380498811.14493.7.camel@deadeye.wl.decadent.org.uk>
Subject: [stable 3.11] [PATCH] irq: Always define
 devm_{request_threaded,free}_irq()
From: Ben Hutchings <ben@decadent.org.uk>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        linux-s390@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Sep 2013 00:53:31 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PGcLgTSHFvrt2fg/wRWZ"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PGcLgTSHFvrt2fg/wRWZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is only needed for 3.11, as s390 has now been changed to use the
generic IRQ code upstream.

These functions are currently defined only if CONFIG_GENERIC_HARDIRQS
is enabled.  But they are still needed on s390 which has its own IRQ
management.

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

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g


--=-PGcLgTSHFvrt2fg/wRWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUki9e+e/yOyVhhEJAQqIXA/9HJLEiJ7OW5gvleV3IddhMMNrVylOTNP7
NJXrrv1IfHm7kisQOYIYnJjbY6x8oo35dXOdKc/FdwfpFAVZFAhshGMEyViIIP70
0GlrzhzDgnb914W3ZIpJz6JHZzJIt3YWp264OILsmMxrcDSA6gNilr9XsPI2KoBy
cbMDgI1fa+od2TwFG8e71njr7vAhcdBGLIwKgJsBQsoCzzPyIzHIhq07/rclzvGD
wQGDwUcDkLTwVUOfpIVV7OX13Uwz00i+bN8IjQqtn7nLAtiW2A20bB0vUMKg3IY7
rXStDf7C1nVh6fY87hjjwgZ3Tb0SbAe/5w6SVVlA9YclkfI2SlDfxSmv1OkKDdRJ
jwtKDNsHzpyYq91qBkvDmptztkJAgp1IwXXH9xmfX4S7VTRusJiOCZpXtskf+ryJ
zzeYlCzcGmqJ2UCmRz+4LBTZ/jDPfSQfPXloIG1fJb4IETn5VTwpsbGFPnGuO/FM
FZUev14tVw2CBIRrel971DuKwWe4oF2UWRKJsCBNzsC1u0mSYfJLuByhLBKIBoBM
hCsmeZX5aHsDDyjHS/ExYffawzCat5Ej3h/+Z+6OFnsWff3bsBcUfqih2yTf6yh3
GmRqBaF3k9d2VSDooHNJo2pN2fERkqddPWSJiXYSiL9eGeHyHpW0ebYF+isbbW39
QUxUkqlJ80Q=
=fPHO
-----END PGP SIGNATURE-----

--=-PGcLgTSHFvrt2fg/wRWZ--
