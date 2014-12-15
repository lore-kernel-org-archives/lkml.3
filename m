Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaLODJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:09:11 -0500
Received: from ozlabs.org ([103.22.144.67]:52460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaLODJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:09:08 -0500
Date: Mon, 15 Dec 2014 14:09:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Guenter Roeck <linux@roeck-us.net>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20141215140901.65a72ddb@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Y8PlWj0qNckkBtPbsYl+eN7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Y8PlWj0qNckkBtPbsYl+eN7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/rtc/rtc-snvs.c between commit 88221c32f985 ("rtc: snvs: fix
build with CONFIG_PM_SLEEP disabled") from Linus' tree and commit
0929ae376ef3 ("rtc: drop owner assignment from platform_drivers") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-snvs.c
index 942b267c6271,f04c378b781a..000000000000
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@@ -367,8 -327,7 +367,7 @@@ MODULE_DEVICE_TABLE(of, snvs_dt_ids)
  static struct platform_driver snvs_rtc_driver =3D {
  	.driver =3D {
  		.name	=3D "snvs_rtc",
- 		.owner	=3D THIS_MODULE,
 -		.pm	=3D &snvs_rtc_pm_ops,
 +		.pm	=3D SNVS_RTC_PM_OPS,
  		.of_match_table =3D snvs_dt_ids,
  	},
  	.probe		=3D snvs_rtc_probe,

--Sig_/Y8PlWj0qNckkBtPbsYl+eN7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjlDRAAoJEMDTa8Ir7ZwVfxUP/2TghZPiOgYdeUBcteKR/Zv5
/Q+3f4BH3PthpJxRIF4s+K4jXFM2tUPZr5wtXe4duC2Hodk9cT34+u6KzwtRQlqB
rTiTijf0wo8vBCZoI5j+6wbciQJZqQctvYsM4rXf/+1BFsjCawstCdeR95jE2OZN
BUjePJJYzuqxBj6eQblweW9QRHmyOkJSj4jyk5dO5hxVHwKPylTWcf5PfPMmJE/u
w4nFWKFZ1Va44kobXOnBfWxt6u7eemSw97uTZC3YpFljxYMdYwL82enE7/RREycr
G3MjmKrxZMJWvJyXayYcqoW3GZjiyVA2GY7LSbddrFVdQ5C12N/xPsuMdyMJfyug
WnPB+jdRMDwTyWzsFL42BaDrNVOIrtcNIjyA0/sTqrQLdT7OyVt9uZZhy1VOOGoq
Np5Ck/foAA/oiiyap8PNtW+5gopGjA9QEr+CQrVi1qeuVwTXyAzPn5sy8rUMo1YF
ZDSwnYpPjU9AlDxsnxpTTqfZ9+JSz80DtQ21/lKMJL00RLWeeeTU20OuT3/cY1AU
gGQy7UqAir2r8dxBisDngdWpNDs2Lj4YkRgUFWsbq7dwvMwojkrUdRtEtEXCh5Om
az8i4krj+SaRTIFNp6H39sHwj5WyAl9Tg+vriVBBqw36+oRPXT6agtmCWOBCjAPk
+J1gf6tRUFkrV40BDBHN
=1PEH
-----END PGP SIGNATURE-----

--Sig_/Y8PlWj0qNckkBtPbsYl+eN7--
