Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaEAL6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:58:18 -0400
Received: from mout.gmx.net ([212.227.15.19]:59585 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaEAL6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:58:17 -0400
Date: Thu, 1 May 2014 13:58:10 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        standby24x7@gmail.com, ebru.akagunduz@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140501135810.521ab55b@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WB4ABZ7c5DGxBhsSsDVDAxd"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:GkIjn2ahiDavdD7IEc6EeKe81fFCyv9E6EnH4nnVtRE4RQWplz3
 4pe6Sxsw/EecTQsMJ+9nbS4Jo8NSLAlRQk55d6/8idTrEJFkwS6DpyAY/9QY770ljrySPNo
 AirpbWoZPCZrFolnJ6IwlqfVDDPABc8V2RlS4wnpQ+oJ0T/pSfPJ5KNj5aJLUhRNtnzrRml
 maCD0c8I7xSkjbZvEKs8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WB4ABZ7c5DGxBhsSsDVDAxd
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
 drivers/staging/rtl8188eu/core/rtw_ap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8=
188eu/core/rtw_ap.c
index ff74d0d..6268f44 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1325,7 +1325,7 @@ static void update_bcn_wps_ie(struct adapter *padapte=
r)
=20
 	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
 	if (pwps_ie_src =3D=3D NULL)
-		return;
+		goto exit;
=20
 	wps_ielen =3D (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen) <=3D MAX_IE_SZ) {
@@ -1339,6 +1339,7 @@ static void update_bcn_wps_ie(struct adapter *padapte=
r)
 		pnetwork->IELength =3D wps_offset + (wps_ielen+2) + remainder_ielen;
 	}
=20
+exit:
 	kfree(pbackup_remainder_ie);
 }
=20
--=20
1.9.1

--Sig_/WB4ABZ7c5DGxBhsSsDVDAxd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYjbSAAoJEKssnEpaPQKEqhAQANDb6kGkwMorD68ksEPp7lU+
AXMvBnQuodgu7rcCkuGxc23kX3qW0AmkvWkgHUpBKcrA8mh3NTzm3hWEqqjCX+mS
d339d2lbaNvpvMofTWhDnC3FVFqMqlmkh8f3Qm0jr1KbDnqpbwW0i9IKJRvQXc3Q
6fGJaNN9voLnI9OWeAZe9Z35LW8sC76chcqt9SjHPYfel0j7s7UGHnhm5nKfoFlx
hTez6ExFVUZzH3lsvsqfPMXu83dW4c+qPBxBjfMegV9Lg7X1iXph3DqH7oba+uzJ
cctupsBqftiHdFj6XKsdHmdFPWOHmZ/Z1CFpLey8Aa12qoi+JW3IFY0P8SgiM4u1
HcxCJkBbxyuXgIdTOmD7KOUu7hI6GmgPcrOUvgRqMAnzuZuXslPx5tCzmAh8NO6q
Pkq/685YONMmGAxDTAG/KFxA1WNLYTxlHB2m7u0OvPHsyX83tcP47l9Da0idUERj
FnnK62Ikns2Liu1G7ZLp3Dvxu0Jt2jKDwAj6Q4PRG6ejAqsD3TxhI1XsF0BW9eFp
X1imlOqNxLag/HhlqhV8nBJNa02enxFJ9mZwdF8MOWzq72fluKa18b+TkBZKG1Qm
DXcscURDSjyyIE9pqhmrJpaWyeJGh0lpZUKV+XzMFFuzZs5bUwZcoZjzm8XME1ZK
ABjOdX4feEOck06RAHCu
=Ok7g
-----END PGP SIGNATURE-----

--Sig_/WB4ABZ7c5DGxBhsSsDVDAxd--
