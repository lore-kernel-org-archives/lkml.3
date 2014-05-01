Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaEAWPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:15:37 -0400
Received: from mout.gmx.net ([212.227.15.15]:61605 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaEAWPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:15:34 -0400
Date: Fri, 2 May 2014 00:11:18 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org, Jes.Sorensen@redhat.com
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net, mguzik@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140502001118.5ab306d8@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/23LluZyWv8rifq2Xv=PtTeo"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:3OE1JJiXWunE2SaMsXmk5iEeZcoiIt+AN6DGI5CG4mRT0UfLSn7
 IQgsMGnmOdQQvBE2nIk8GyJteJ+RuXr+N2+bzhv3UWoBzL1T/nEQMCHB5G+LKCYaw0wcz3X
 PmuuxrRSHdynuZ89rZp8gKnpO+rIDqgU/W2XG5Q4zdKYrjBJ1yAW08Lpop9+MdArM1GWg4I
 mnoQKK8XNlnzJPa+NcAcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/23LluZyWv8rifq2Xv=PtTeo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential leak in the error path of function update_bcn_wps_ie().
Move the affected input verification to the beginning of the function so
that it may return directly without leaking already allocated memory.
Detected by Coverity - CID 1077718.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Added change suggested by Mateusz Guzik:

    Move the check before allocating the memory instead of freeing the
    resource afterwards in the error path.

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8=
723au/core/rtw_ap.c
index 9b31412..da028c535 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1256,6 +1256,10 @@ static void update_bcn_wps_ie(struct rtw_adapter *pa=
dapter)
=20
 	DBG_8723A("%s\n", __func__);
=20
+	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
+	if (pwps_ie_src =3D=3D NULL)
+		return;
+
 	pwps_ie =3D rtw_get_wps_ie23a(ie+_FIXED_IE_LENGTH_, ielen-_FIXED_IE_LENGT=
H_, NULL, &wps_ielen);
=20
 	if (pwps_ie =3D=3D NULL || wps_ielen =3D=3D 0)
@@ -1274,10 +1278,6 @@ static void update_bcn_wps_ie(struct rtw_adapter *pa=
dapter)
 			       remainder_ielen);
 	}
=20
-	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
-	if (pwps_ie_src =3D=3D NULL)
-		return;
-
 	wps_ielen =3D (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen)<=3D MAX_IE_SZ)
 	{
--=20
1.9.1

--Sig_/23LluZyWv8rifq2Xv=PtTeo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYsaGAAoJEKssnEpaPQKEfGgP/1zrtfPnupgObyMqrwX8D69W
fErMA3wX7LJKN/pgQKK3nHObyJoellZ0mdj/2+Y3L5UDRYUXuBzvaInLSMETMkmL
RqOBl4RElIKEixkEVldijGIg/GBiMDPLd8nevXJK9jkVeDqkP1iGFmLUiV/sdbDn
TqJ64xuRbKuvHr1ThsJa7Ql+Cj7XnAr+DD6dsgwXdB8yY5Gr34+0PUAMMtDxAFHu
HiuDEM6Ygb5UdVBIFd2lleXvOaOqPBnccla7TPaMZclPDzh+F/B7+XUksIw1Vcm3
j2zl5pcVqEbRMY+gWWQ2WaKy1dsre+8Lhed9PgpYuZsyx3oQTzFa4YLYznmC9QP8
05VzZ9QoCeTdzyBre89gauKPA9ra5SpAZWdgC1Z8MFGKa0gq6cexK3NVerCulBob
jvC8sA4EoAJWKV99ceS45aQVuUttIivU1xQgLkM7Q8IigW9TJ2V7mmeTecD4Nqf0
Fkj7MV3KGeRcpSIH8G5TqzywtOZgTeaAOCIKZM6dZV6TI6NkCpw83USNIeuubnat
OpyOxdC79cBj7ebtuLfptWx9m1YC/zFBQcOWttQ+83GzHaXtBheGKcHFBRBBTNXR
lSD+zs/b83Gexv/TP0KOeL7JObakMk/zZBPly12UdP5wvnaXbPTvsZ4Fu7aXIQV6
OSS1x0XVb3pI9BBGXdhq
=6Ul4
-----END PGP SIGNATURE-----

--Sig_/23LluZyWv8rifq2Xv=PtTeo--
