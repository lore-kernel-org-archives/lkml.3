Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058Ab3DJHKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:10:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36854 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3DJHKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:10:16 -0400
Date: Wed, 10 Apr 2013 17:10:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20130410171001.d485e70b48cd1a64dd2a6343@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_17_10_01_+1000_ryH+BBVW8yWge9UR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_17_10_01_+1000_ryH+BBVW8yWge9UR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
drivers/pinctrl/pinctrl-samsung.c and drivers/pinctrl/pinctrl-samsung.h
between commit 61dd72613177 ("pinctrl: Add pinctrl-s3c64xx driver") from
the pinctrl tree and commit f67faf487fc1 ("pinctrl: exynos: add
exynos5250 SoC specific data") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-samsung.c
index 4f54faf,fe7ace2..0000000
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@@ -970,11 -948,8 +970,13 @@@ static const struct of_device_id samsun
  		.data =3D (void *)exynos4210_pin_ctrl },
  	{ .compatible =3D "samsung,exynos4x12-pinctrl",
  		.data =3D (void *)exynos4x12_pin_ctrl },
 +#endif
 +#ifdef CONFIG_PINCTRL_S3C64XX
 +	{ .compatible =3D "samsung,s3c64xx-pinctrl",
 +		.data =3D s3c64xx_pin_ctrl },
 +#endif
+ 	{ .compatible =3D "samsung,exynos5250-pinctrl",
+ 		.data =3D (void *)exynos5250_pin_ctrl },
  	{},
  };
  MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
diff --cc drivers/pinctrl/pinctrl-samsung.h
index 45f27b4,ee964aa..0000000
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@@ -244,6 -237,6 +244,7 @@@ struct samsung_pmx_func=20
  /* list of all exported SoC specific data */
  extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
  extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
 +extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
+ extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 =20
  #endif /* __PINCTRL_SAMSUNG_H */


--Signature=_Wed__10_Apr_2013_17_10_01_+1000_ryH+BBVW8yWge9UR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZRBJAAoJEECxmPOUX5FEjNcP/jZigKUceDAoPoW497gKg0W6
giGmom+KR4al/ocQXTiF364RbdNgQe8tyzmKMnP8huNnceLXkp0D4YVCZ8yLQ5Gb
QONnKxkyTjXkRvXv3LXADmmnEEVuU2hEqD7ESxHZgFm6VYXrqzAuAaKMTSXCqHyZ
ca56kX03cSv8BibCawNRTJj1SW4D9OZIgm3gKXr1+3MMg+Wl9LUpwpSCxYcXABay
3VOsD0+5NcGVElyK69+YnRFr+F6S3zMUsK2PPWvdkV4h8sLizjz043p9sdvf8/h+
z7gEXTh8z6bo7w4vKaBu9t0uBOGaTsWkxSprZKcTBC6q4CwJmwBNpXUpMUhA1tFj
SoO8PSfxE3iGd/cc+J+a05TDFI0yhIdhi4rIh8tf84y5UMIedn3OHuaoPmybE/md
TmDydirt4ntqP4eXKrFTFjnhl+W+aJR2OzOkrua5+bkWYnmR2qddU797VVmPjnXt
jjrRyjaKe4r6wBHITHgUEiOXp8+i9gxikccTeCib5vcMTs0XYcglX5nSSF7P7/I0
6vE+vvlj4dJFe30rBuD6NVbZyvsWScYIcdH0FYJVzHFbmPzUY36KjRcRXxnMQDos
P6Y3A+WfsiMA5tMXbnNBt8FhW6kwcNQg6aRd6+8Hf9z2Qm/C6mmeoRPsn/eFnjiI
oynnWs2gsbizBQBCcSN/
=+7rA
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_17_10_01_+1000_ryH+BBVW8yWge9UR--
