Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3IAQKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:10:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab3IAQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:10:12 -0400
Message-ID: <1378051797.25743.25.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] irq: Always define devm_{request_threaded,free}_irq()
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        linux-s390@vger.kernel.org
Date: Sun, 01 Sep 2013 17:09:57 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CHl7HdIBUnE+qn94OhZ7"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CHl7HdIBUnE+qn94OhZ7
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

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow Lindber=
g

--=-CHl7HdIBUnE+qn94OhZ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiNm1ee/yOyVhhEJAQo1/A//QLPYT/GGmfieKVBlArPIBgzc/ilw/gc/
rjaSqvD/0VER9jo7vVxmDTgfa0n5gL2XXM13IaIBmIwXTYPwQzwsrYkL4xv2i/Xr
1ZCeHaCYzviFtl3OEU/0EfR6qtJl8fJATtpo8AfXjGfh/r93AXh2+vWoyVSUVzrE
AKbY3xgW97gzvj+zDER3pL1ljq6uPr1yFFEOexZsMZ7ccGlw1aj+KwfUAVrokyJG
PhA/Xo1SxEQBI4rA0JJWGT0xT+O4cgpgwwTXvk0S1yiYiV0TZ+6ghv4iOh9uQWZh
GtsvR13s2TZdInVDvfHLRml3rL8fxx0XiyvvVhQVCftCe3dyOy2UcGeZKeDynrt2
RtkAIopcWH2RLwStE2XSLmn/3JoqyWZ/g1ZDjHXLeWnXD3HyNuHpVrSaRsGekMNc
MjExYIdORl5Lf8bNk/Ce7b2zQSpMvX0MpRBwXXpLPKXwER6Rk8cTOL6+e1WqkVdX
EfdmaVdTYc11c/G07te5c8csKN/m7Wiv0xY8t4nUerjzrnFW9Cv4R2Vim+8fxaG/
SGvWWVO20AclpK0AycvT5t27dBcOLfWygb7mLPZpBWuizTA+ENIOWnlPyglM84wH
jUzsInewV5u8877ZdGclbztkn78ilLOWjSMCjd64w3cJdyaTekYsBrhzulhtmSmR
R56fAxYV4Rw=
=L2sA
-----END PGP SIGNATURE-----

--=-CHl7HdIBUnE+qn94OhZ7--
