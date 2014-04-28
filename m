Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaD1TM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:12:56 -0400
Received: from mout.gmx.net ([212.227.15.18]:64812 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbaD1TMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:12:14 -0400
Date: Mon, 28 Apr 2014 20:47:27 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: dan.carpenter@oracle.com, gregkh@linuxfoundation.org, chad@dahc.us,
        tulinizer@gmail.com, michael.banken@mathe.stud.uni-erlangen.de,
        lorenz@badgers.com, rashika.kheria@gmail.com,
        andriy.shevchenko@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: silicom: Remove unused pointer in
 bypass_init_module()
Message-ID: <20140428204727.699dc618@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ajU.YptsbzL9cpVx6oNU=c/"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:vGiCbWaAiu3Ph3Pr6XdBHmlQWcTvDzNxxPi4FHCDnD0vjwIW0L2
 zNyKo5OKt7ohcdvgJw5J0WCTN5u1r3RkIGlu/XqcCiPmGd0pxdA5bBAdLNO3w86gmFQ8QEy
 7F7SGogyhyfmzDuC9EjvH5gOl4JSEMkc+z2Tr5ShjHckv+ubE08C/BDXZdKx58YNwXhE2/M
 GfatwaBAPiJT+cvv2JO9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ajU.YptsbzL9cpVx6oNU=c/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Pointer 'pbpctl_dev_c' in function bypass_init_module() is unused. Thus rem=
ove
it. With the last variable declaration gone, there is no more need for an o=
wn
block. Remove it and adapt the indenting accordingly.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Added changes requested by Dan Carpenter:

    Dan pointed out that with the declaration gone, the indent block shall =
be
    removed. This was intentionally left out in v1 in order to keep the
    changeset more readable. However, according to the input, also with the
    additional indenting change this still qualifies for one logical change.

Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/silicom/bpctl_mod.c | 41 +++++++++++++++------------------=
----
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/=
bpctl_mod.c
index 7f3d884..2fb9a6f 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -6371,33 +6371,26 @@ static int __init bypass_init_module(void)
=20
 	sema_init(&bpctl_sema, 1);
 	spin_lock_init(&bpvm_lock);
-	{
-
-		struct bpctl_dev *pbpctl_dev_c =3D NULL;
-		for (idx_dev =3D 0, dev =3D bpctl_dev_arr;
-		     idx_dev < device_num && dev->pdev;
-		     idx_dev++, dev++) {
-			if (dev->bp_10g9) {
-				pbpctl_dev_c =3D get_status_port_fn(dev);
-				if (is_bypass_fn(dev)) {
-					printk(KERN_INFO "%s found, ",
-					       dev->name);
-					dev->bp_fw_ver =3D bypass_fw_ver(dev);
-					printk("firmware version: 0x%x\n",
-					       dev->bp_fw_ver);
-				}
-				dev->wdt_status =3D WDT_STATUS_UNKNOWN;
-				dev->reset_time =3D 0;
-				atomic_set(&dev->wdt_busy, 0);
-				dev->bp_status_un =3D 1;
-
-				bypass_caps_init(dev);
-
-				init_bypass_wd_auto(dev);
-				init_bypass_tpl_auto(dev);
=20
+	for (idx_dev =3D 0, dev =3D bpctl_dev_arr;
+	     idx_dev < device_num && dev->pdev;
+	     idx_dev++, dev++) {
+		if (dev->bp_10g9) {
+			if (is_bypass_fn(dev)) {
+				printk(KERN_INFO "%s found, ", dev->name);
+				dev->bp_fw_ver =3D bypass_fw_ver(dev);
+				printk("firmware version: 0x%x\n",
+				       dev->bp_fw_ver);
 			}
+			dev->wdt_status =3D WDT_STATUS_UNKNOWN;
+			dev->reset_time =3D 0;
+			atomic_set(&dev->wdt_busy, 0);
+			dev->bp_status_un =3D 1;
+
+			bypass_caps_init(dev);
=20
+			init_bypass_wd_auto(dev);
+			init_bypass_tpl_auto(dev);
 		}
 	}
=20
--=20
1.9.1

--Sig_/ajU.YptsbzL9cpVx6oNU=c/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXqI/AAoJEKssnEpaPQKE0R4QAMOqKEugwKs2hYMbAcA7Um8U
pNFhCLnd3sukTI8aD5NJ14eVArESxQMysDT+OdWrE44pxofy1gHYG2N4SgWuEh+K
VTQr+D8yNR528djo8dckGQtmIDV2yexZA8U1mSDvtmKobBZQ50BVnE7UieyTUYoR
UBezhoJCnzc2qwzrjt1N3El9jHskyLcegr9Gs5uGdPyfeiE42z1olJwnac+6dk34
2QGD5jWc+WxaeTQViEyzIvaP1Vaq8gbmPBOlcXeKBTqzYiocafXniOIqMI7HXmBx
oacXX2zppXePRzH43+PKx1wj4rLrxEE1Ut6kTcanS1ugHEr2LLNEBI6a+tVJhrOh
ePUEWuM96Hu2gLej5wzK1g/eY6J+l1YUyKJEQ1GrtvNu/MU3ZrW2Qt5rACzkBb4j
3so5uIQQbHq8k76lKaGp1qB6lQN5j+NGbl4PDrDtSPcCUcU6KIGPqqcNPx1vI8bG
feU7NmLE1oIz7CynedljUKQUqEHVpUnNBaK0BIJrAJ64/w6PHXA8Z7qoa0Ij9CyW
wnJQ35PpKDoGALR4dhYKIdv31a6pEreRCmGH+yLTPBEL08ne/tgJdYBMaBqSS4yO
Q1Ge4jo15ICa1G5xFTE/B0FJbwAs/xX0vYBDPoH9vcO/zJvSvXEuvLt8VL6cY85e
FsmpyCtYiKycy/27On2d
=ufNP
-----END PGP SIGNATURE-----

--Sig_/ajU.YptsbzL9cpVx6oNU=c/--
