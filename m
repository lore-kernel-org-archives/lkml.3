Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaD1VFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:05:36 -0400
Received: from mout.gmx.net ([212.227.15.15]:64936 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbaD1VEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:23 -0400
Date: Mon, 28 Apr 2014 22:57:10 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging: rtl8188eu: fix potential leak in
 rtw_wx_set_enc_ext()
Message-ID: <20140428225710.6ec535ea@spike>
In-Reply-To: <20140428225431.2ea55d58@spike>
References: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/14esK9IjGybD1=ZDaGCrLtr"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:jn+LeG+LREJPkjwGnCAqlVNusfXrvkgbdaimEKl5F+SZbCD5UL7
 B0Q2f0rMLIPa/3aPTC5j92B0Z2uib4kYy6TZ7eiU/cM6bbzi7Mbb6WbhKPgPTOiNaN5Scwa
 kPyeCuKtDAL9LVCn1fzGYVVY2guZSgESeu5tzEB2MeYLHuN9a7oTUwMbWpuSRoeMKqxmdH+
 GERx4uGaiaFlr9sZ9EkEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/14esK9IjGybD1=ZDaGCrLtr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function rtw_wx_set_enc_ext() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077712.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/stagi=
ng/rtl8188eu/os_dep/ioctl_linux.c
index 45b47e2..1bd476d 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2097,7 +2097,8 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 		alg_name =3D "CCMP";
 		break;
 	default:
-		return -1;
+		ret =3D -1;
+		goto exit;
 	}
=20
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
@@ -2124,6 +2125,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
=20
 	ret =3D  wpa_set_encryption(dev, param, param_len);
=20
+exit:
 	kfree(param);
 	return ret;
 }
--=20
1.9.1


--Sig_/14esK9IjGybD1=ZDaGCrLtr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsCmAAoJEKssnEpaPQKEhtoP+wVgqY36PhLkLgCUw7+3h3IP
9m+ZIER6390oEWGk0rJU7HdFre0iNBh/nlO/iNeigl2fxmKXibF6n+ldfZ4y7yR0
tXFPuxb9CKRDWX2o6Za3xofaw/l6o26esx7mPKISQriVvYvtCczGGTEZAh9fJVxy
r1XxVpm1w8L7SMhBoC8ZFpHsHp2+0q7a/D5MxJdD4KFIbHQkfe4SWqA34AtOx2PM
vjviHXN6MzerPXK2/Z0C4cKvwltpuVJSq4htvrAhhT4GxzhI8V6T0hk755WHmM8d
8MsO3RsE5BtBveCCEKG1jazyrJyFaumRt3ZjEuZ6jPvJZEd1hlih7zdP8xbNQ1Yt
myZLuFBgYeQietnn1u9nwNvXXL6KgNZOH3rK+8mCWenDKm1LXfQky20yR6+VZHzU
OM3hvfHv4Z3yRpq3btgfZhYLAQTS4z4ZhtVG7isIDEfwHLTmUy6XuNZlEV/lztog
lAZhcQx/IrvS2XZ5jEOmWSSqG7RastmyLVLg6nRsRaGDL9cTN/RxTh+G2qkQJad3
FOqBds0U0hxFxbmbkC7wDoPBRay97wKe+wi/+08+XhQyQ4bjtWOHirIDckm/4YVp
7p8LZz43cHLru/9XEQwV6p//eU9O5PKyJSa7Z8JaPy0jiUHrS0Glr0TpuMdDOcav
z5UpGqwBKdP0qoKY+ow7
=XTJC
-----END PGP SIGNATURE-----

--Sig_/14esK9IjGybD1=ZDaGCrLtr--
