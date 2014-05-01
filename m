Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaEAL5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:57:38 -0400
Received: from mout.gmx.net ([212.227.15.18]:52986 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbaEAL5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:57:37 -0400
Date: Thu, 1 May 2014 13:57:27 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140501135727.467d6bf2@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/iN0f5=1Ehj/Mw38nbbr6BH2"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:3F+HfKpvGtuqoLxES4dV6aL7zaWBumcNbKseyugeTAScDo7cOIB
 B0v067fY1Ytjo34TaG1BY7sIIeOo1b+mmIPlqMKhJ7Kcd/ebd2xKA9UstoAz4jTbocRFPw7
 veKRk8fs5H2TbflfhCg3WwgeRs/U6sbtkQAasj7oTKfbmPqhvAmXeZaAv2GNLMjto6Wqce4
 s67+DMCtgk+HIqImZzidQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iN0f5=1Ehj/Mw38nbbr6BH2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential leak in the error path of function update_bcn_wps_ie().
Make sure that allocated memory for 'pbackup_remainder_ie' is freed
upon return. Detected by Coverity - CID 1077718.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8=
723au/core/rtw_ap.c
index 9b31412..f2c78a7 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1276,7 +1276,7 @@ static void update_bcn_wps_ie(struct rtw_adapter *pad=
apter)
=20
 	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
 	if (pwps_ie_src =3D=3D NULL)
-		return;
+		goto exit;
=20
 	wps_ielen =3D (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen)<=3D MAX_IE_SZ)
@@ -1291,8 +1291,8 @@ static void update_bcn_wps_ie(struct rtw_adapter *pad=
apter)
 		pnetwork->IELength =3D wps_offset + (wps_ielen+2) + remainder_ielen;
 	}
=20
-	if (pbackup_remainder_ie)
-		kfree(pbackup_remainder_ie);
+exit:
+	kfree(pbackup_remainder_ie);
 }
=20
 static void update_bcn_p2p_ie(struct rtw_adapter *padapter)
--=20
1.9.1

--Sig_/iN0f5=1Ehj/Mw38nbbr6BH2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYjanAAoJEKssnEpaPQKErmkP/jO5Xf02HrsyIAwWoySIpVo0
FpCgvXfxkG6D2/Mf5w8aJFqcsYZPE6M+4sotN76B1KUl2MEPlRww99INj3gtLaGl
lgUDXD/Ut+oFWVTxDP+mPPhln17FMSGarKPlatdmqgJB8U4ALiW8wpH98Ny46hgs
IuKMjAMtB8qoJlqqfFhbn1xQMh0tHCvcjDF5rFQnD7nL8FBs7ByyLFgSXEz8udhB
xdCRs7Ao09BC7UwYAbzD696Ff1DaaD+QkiivJbfYp7ShPEvs4V22pDIQYeNdN+8e
yFuzO8h6M8JeBVRSUaTj+gqFWq3Ud3koqc5aNQtX8D0KeExdhXutcDFcyLTypOUF
NCS3YMI75YpOmopfNFEL6RWuTLi/X/QMFUsfPcgRpXKoe7Do0Z/R7RiPNl6legCm
r62Y4ZrRJrgxGilC08tQ1pu20VRMh8e4k+KRr9v6poAHNT+g8XK4ev15+6CfoQL9
afWU5q7VgRuwH1CY/wVux1gDIib7sGw8XdMgR0eZT4KWhBZ+O4UwLGNX/X+RtTzL
hEwGOaG9eeMqaqmGutz92C5dUVj88gptFKu6lA8iRi5UXkr1m/fvJgGuES9S4DXa
BRLGynVG6nbW/V37FpVFvf8zGRwcSGFrYnEfF4zLUeYeNp1jq/1vZ8Wlih2orpUd
vynFVUp9SdnrxvvI6TRu
=c2FW
-----END PGP SIGNATURE-----

--Sig_/iN0f5=1Ehj/Mw38nbbr6BH2--
