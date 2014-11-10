Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKJG33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:29:29 -0500
Received: from ozlabs.org ([103.22.144.67]:53800 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaKJG32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:29:28 -0500
Date: Mon, 10 Nov 2014 17:29:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Chris Zhong <zyw@rock-chips.com>
Subject: linux-next: manual merge of the pinctrl tree with the driver-core
 tree
Message-ID: <20141110172921.1e2c12d9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LJszOZElMo9TTMOQeyORs_m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LJszOZElMo9TTMOQeyORs_m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/pinctrl-rockchip.c between commit 9198f509c888
("pinctrl: rockchip: add suspend/resume functions") from the
driver-core tree and commit 5c759d73b022 ("pinctrl: drop owner
assignment from platform_drivers") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-rockchip.c
index 71d5835d864b,40970c305dd0..000000000000
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@@ -1982,6 -2053,8 +2053,7 @@@ static struct platform_driver rockchip_
  	.probe		=3D rockchip_pinctrl_probe,
  	.driver =3D {
  		.name	=3D "rockchip-pinctrl",
 -		.owner	=3D THIS_MODULE,
+ 		.pm =3D &rockchip_pinctrl_dev_pm_ops,
  		.of_match_table =3D rockchip_pinctrl_dt_match,
  	},
  };

--Sig_/LJszOZElMo9TTMOQeyORs_m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYFtGAAoJEMDTa8Ir7ZwVap0P/19w6EZkBRwfwdk7sEX97669
SGwdtAiKTfORHUd65tsBeAymcEpBezmtO+2Fz7d+0q1x3R0ZY93rbUGgodKaFZwl
PCmyCiT4SYhRrR5KEz5JOqrsUQoMHBupIzEoAQW8cw863UzuHIMrbk2AFcTL4eA/
e7dRo4ArtJ22euqeOcIkcOd3PPVymeJGOn7t6+LivDTuzf71+runEhm/v6ILgN23
sKGYXVlWw923fMXTle+IxxDZC0lQvQP2sxpTw6E/DP3NHHgwOtY8rXZos7/RiZgt
f8qeywQUaRp0LRBT7zIH/23OBKGBGk5/O8fH0fJVm/2UlAtVKZdIDlI7RWh//zua
rKPsNWyCK6PU6zinQV0vvlasgo9M5Q7+k+dE3VbC1k6cVJBkhYrbhmlB8Xm4yjLz
ykIEnAraCmQ2gihp9lD5eqng8Noio+GdjOz3kXF/gwI9bCQU1uRcn6DicXMGaOzj
vmPLSf72KXFXVjZL5mA50DzQXvvVobSa/A4Guy+EsxNmIJjZJAj3jQCeJFIoZG2j
CaZiMEU8iNo4lFaAQWutryBxAC9lKqdAwfecZAOyOixhkveSQ+hzPYlhVbHxdYGg
pqGno2kYgY59M63ykzCh7ZUXLKAE7E7l+zLx4KeGHy5Y1yxSUwUB9WGEJUOhe1fk
fnGT1ZCKBMEhP/qME48Z
=miKk
-----END PGP SIGNATURE-----

--Sig_/LJszOZElMo9TTMOQeyORs_m--
