Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbaDJSiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:38:16 -0400
Received: from mout.gmx.net ([212.227.17.21]:61585 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965159AbaDJSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:38:15 -0400
Date: Thu, 10 Apr 2014 20:37:53 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: linville@tuxdriver.com, fariyaf@gmail.com
Cc: dan.carpenter@oracle.com, joe@perches.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] rsi: Fix a potential memory leak in 
 rsi_send_auto_rate_request()
Message-ID: <20140410203753.4406f4f1@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ws/ECg0KVk6C=61r5OaMN.1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:RdGSbjM6kES2Rp8NRYdTMPZ3UqN5gS1Em/GRY/gYkBHnd6l8Dcq
 ngJRqfrcaCadangDQiuFSIhp+CEtpZPi6x9930VqhEryDoc1Xxkqqq2sQeNDaS5o1B9ABjU
 bWOWLddd3xDPqugGGAzdv6rlGiTcJ3cprzlH9VUpjpjni5ZyoTSE2Tk6OQTjLuxC+rP46yH
 cMpkPBsizb6czm/FNokag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ws/ECg0KVk6C=61r5OaMN.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential memory leak in the error path of function
rsi_send_auto_rate_request(). In case memory allocation for array
'selected_rates' fails, the error path exits and leaves the previously
allocated skb in place. Detected by Coverity: CID 1195575.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Applies against git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.g=
it
Compile tested.
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless=
/rsi/rsi_91x_mgmt.c
index 2361a68..dd7946d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -966,6 +966,7 @@ static int rsi_send_auto_rate_request(struct rsi_common=
 *common)
 	if (!selected_rates) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of mem\n",
 			__func__);
+		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
=20
--=20
1.8.3.2

--Sig_/ws/ECg0KVk6C=61r5OaMN.1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRuUBAAoJEKssnEpaPQKEKsMQALe4rVKfSsU9o6dra0tTPaxh
MRofzv2deadUwPFN1zmI7xM6hWlYEvz1Dmp5RHuobrir+V1k+MfBer7UJRVObcVT
Fj+h1+V6MamBtMQmwtg6pqG5CdWJDD4APl0k+woQyU9Luaqs4VfvV8axrwaZJ4Ls
AXH2I9Mm4s8/RkvnBcgaEPBcl6imn1kNK8jLT9OGEcYtm4XYUbf8c2LxHJmiKfwu
bG4biSUBzal5kJHpmyQL93kym0LpWANFMEHiEYz85erq2tM79qgiQ92J1B1WcGSG
PNu8xWWnU3M7/UGeNzvHzQMdHf2flBn1311vkgIw8Dm3A+KrkVSLNnj2hy215hPI
zodbg6MAAMMegVdDxQe5c9uczrDs525XmlvGaZvjxC60nibLvSZUMcGjfVrD8ffI
Mt4Es/vQlo2W6j77+cD2TUZ2m1ACczKwkMDlLDeeoISmffpWfjEDDp0VBT6Pbu9I
HfhmrXFRG082jO5sqYBaoUwUSIEdrFysfJjWaVfLOx9p1WVUx2RnvxsFUK9+cXZY
duPEfC/sF4I/zu+JKpG+c022G4cXjrm252a2YKZiXXKQTrUMB2Kxb3mSvdXRtRe1
gEuTSgCsmUZ/Qj3vNLim0twDsVwZmlPnv0pxl+qvXZpi5bIHX9UDZYtosLduXBT0
Bg5sb+4mTcUjPDkMlHvA
=TBc2
-----END PGP SIGNATURE-----

--Sig_/ws/ECg0KVk6C=61r5OaMN.1--
