Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaDZUWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 16:22:33 -0400
Received: from mout.gmx.net ([212.227.17.22]:62952 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaDZUWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 16:22:04 -0400
Date: Sat, 26 Apr 2014 22:19:18 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, chad@dahc.us, tulinizer@gmail.com,
        lorenz@badgers.com, michael.banken@mathe.stud.uni-erlangen.de,
        rashika.kheria@gmail.com, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: silicom: Remove needless calls of
 get_status_port_fn()
Message-ID: <20140426221918.6082403a@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dADntNi8kmz_.P6P6XP1eHs"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:DhpmTohX0ZgTlf4HmEKx5pN2+fRA0U8v/a/FuoonO+PMC7Af90Q
 gUMPS1iK+U9GxbroWekiQNWIdFP256rUI0+ogcUjBp/J1TkD4yl4DdJbN3Ervsqa4o01Cxy
 3M+qg6p+hg80F+9F+KILU3fvwd0HlakUPt9/4FPcrpEOBzXLuoar3E7RIKf7JlObWhV86VQ
 xZVdglTcRNVZyufUu+mhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dADntNi8kmz_.P6P6XP1eHs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Remove a needless pointer initialisation and call to get_status_port_fn()
in functions remove_bypass_tpl_auto() and set_tpl_fn(). Variable
'pbpctl_dev_b' is set correctly later in the function before first use.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/silicom/bpctl_mod.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/=
bpctl_mod.c
index 2bf8964..fd2adf4 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -4735,10 +4735,9 @@ static void bp_tpl_timer_fn(unsigned long param)
=20
 static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
-	struct bpctl_dev *pbpctl_dev_b =3D NULL;
+	struct bpctl_dev *pbpctl_dev_b;
 	if (!pbpctl_dev)
 		return;
-	pbpctl_dev_b =3D get_status_port_fn(pbpctl_dev);
=20
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		del_timer_sync(&pbpctl_dev->bp_tpl_timer);
@@ -4785,12 +4784,10 @@ static int set_bypass_tpl_auto(struct bpctl_dev *pb=
pctl_dev, unsigned int param)
 static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
=20
-	struct bpctl_dev *pbpctl_dev_b =3D NULL;
+	struct bpctl_dev *pbpctl_dev_b;
 	if (!pbpctl_dev)
 		return -1;
=20
-	pbpctl_dev_b =3D get_status_port_fn(pbpctl_dev);
-
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		if (tpl_mode) {
 			pbpctl_dev_b =3D get_status_port_fn(pbpctl_dev);
--=20
1.9.1

--Sig_/dADntNi8kmz_.P6P6XP1eHs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXBTGAAoJEKssnEpaPQKEQAcP/RptFVoK2HXcADqQEVlw8r/d
t5fCw1xiRuCXJ7tyt++WRUMYehZnnswLo4bEoCsVavCFHyUUZOBEWvkxj+fWAJll
Apf5bE6d+ySgihDh3DyUwze0iETI+gHnnJFpvEckaTxRVKhqwHIVKK0eC83FJ3PX
CilLq0PrtMwNDgZ+nZANxIPs0Xvvl2vMqE98zrygRkM1bFnGtl6ZgStd66rCz63F
FRGtQGGUOdGQDLVFqhl4TERT9HQ6Ex3uMe5R1Q2B1Y6A5G7/qhnfeNp09v3qgFoG
QTo9qSIW5lb+FL8B0f7jVj2Ej89zcii4D0Xla3IG0uGWHmPkvovkmyhARn/AzAvQ
MUI4GOdfb7RWaANskr4OW79wnQVabr6dA7STpFbWjtiXoWSxsau3Oj3AAMMKTgFK
AK+FcOIHn72V9C1Hn3OuqtYme8LZFTsm6xdVStSW8UwwONn3p3XHao7CbFOCnyJD
C298DFSe6R9tO125lYh3Yh0t/utplUJN1ZT97Xmsy8AuEE0cZeHHcc0gtXWMOQGN
iq0PMKVMkVI7OaRNFtaG/LaXAlXWOq/TMSwV+SNadpFu5zNUSQWenURsFkjp5AtI
btg1GN1UkI5dC7/r/hD0a4RREYoZaLKh5j3y0QotAJzO5zrLf/fhfsDtDHH9SLUT
no9t5Ln+//K5PyXDiqkL
=+LBi
-----END PGP SIGNATURE-----

--Sig_/dADntNi8kmz_.P6P6XP1eHs--
