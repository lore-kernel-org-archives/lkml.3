Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaDZUW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 16:22:27 -0400
Received: from mout.gmx.net ([212.227.15.19]:58105 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaDZUWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 16:22:05 -0400
Date: Sat, 26 Apr 2014 22:15:04 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, chad@dahc.us, tulinizer@gmail.com,
        michael.banken@mathe.stud.uni-erlangen.de, lorenz@badgers.com,
        rashika.kheria@gmail.com, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: silicom: Remove unused pointer in
 bypass_init_module()
Message-ID: <20140426221504.57905f21@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.IJ+.fe_esbl33b3hBKH1J1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:l7/g7H5a/csxxC24bnruhgE2H4gsH5m3ik4UBO7oiezT2M0Diog
 yJ1MzTwc3WSZ5E4vidZjPYbi/RhWsUSYb06373H3t3KnO06Nox0FqKS6vZUVN9r8+lFYgWF
 VpfnFdnPkbCYydPuQ/u+DtLBp/nHEuECJOW2ChaaO7HIFz+KaIQw6Lm4ldLfRRe8LnN78Iu
 kNtClCUKO9pEJjHoUPWOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.IJ+.fe_esbl33b3hBKH1J1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Pointer 'pbpctl_dev_c' in function bypass_init_module() is unused.
Thus remove it.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/silicom/bpctl_mod.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/=
bpctl_mod.c
index 7f3d884..2bf8964 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -6372,13 +6372,10 @@ static int __init bypass_init_module(void)
 	sema_init(&bpctl_sema, 1);
 	spin_lock_init(&bpvm_lock);
 	{
-
-		struct bpctl_dev *pbpctl_dev_c =3D NULL;
 		for (idx_dev =3D 0, dev =3D bpctl_dev_arr;
 		     idx_dev < device_num && dev->pdev;
 		     idx_dev++, dev++) {
 			if (dev->bp_10g9) {
-				pbpctl_dev_c =3D get_status_port_fn(dev);
 				if (is_bypass_fn(dev)) {
 					printk(KERN_INFO "%s found, ",
 					       dev->name);
--=20
1.9.1

--Sig_/.IJ+.fe_esbl33b3hBKH1J1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXBPIAAoJEKssnEpaPQKEj7gP/R27CV6No6XmscIYCPf05NAp
l2JsXRGEgL2+J6ZIR6eQabwYKKXRrp4ZBTCAfmL9iUXgtj42kJdbctaBOxPACjPQ
ea5cCVY4D//ENTaya/Q9EtRLLaEAEbQ3N54stW7K3Nk+OXoA+GJnRXdv6AsQRtMh
DhVnFGgb6buBtlIBoEjyfgEaL2Wj8Jowbtjrb7MstIQKpPaCSPeuuxmwoxJadqef
3THRorEE2gHefkYdGJPl2DNrIX5h2ZcH1m3ngzDQtkqxB2ygzxBo2HkHeiU445vl
xpsHJupchdxotGTR2vCkwopKNTisiML975nOJZNuX2p9QmRcHs+B+WsnW0kjYbkZ
vuQ2jPP6x/Vx2B5O2u4Wi3GyZYECpVlFX+/PcXCMiHiTnt3cjYuesdS1aX1Pzo5e
RET3aweJvF3Ar2MNSWmDDHgp6koTGCobOW8sNxNwRhL/PF7SZF3mXpyr5tVCvjEK
dKeuAX/+WXBs+7B89kSNLyAdzGSvx3ZXp+sM/EhvEorzc0xAGoFSN+/uuWWEqJCs
pwsVB7WeanCWXGef2QVeL2I/wR9eZj4zOhARzea8AyTO5K5ZIttB1womcpboUuFO
2LeBcEM6++J3MWGTM5gejB2lI/xfe7+PRVJnzr77jpmiwaWHQFITm0eFzT9GIW3z
9WK8qlxnXhmpui7HtgG+
=Dgra
-----END PGP SIGNATURE-----

--Sig_/.IJ+.fe_esbl33b3hBKH1J1--
