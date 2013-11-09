Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3KIPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:16:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42801 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3KIPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:16:55 -0500
Date: Sat, 9 Nov 2013 15:16:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Message-ID: <20131109151626.GT2493@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oaK9NA/DDdTag9m3"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.152.125.166
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix compile warning with value uninitialized
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oaK9NA/DDdTag9m3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 09, 2013 at 09:49:11AM +0000, Caizhiyong wrote:

> @@ -2170,7 +2170,8 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
>  			  int num_regs)
>  {
>  	struct reg_default *p;
> -	int i, ret;
> +	int i;
> +	int ret = 0;
>  	bool bypass;

This sort of fix isn't ideal, it just silences the warning but if the
compiler has spotted a genuine oversight in the function it won't
address it.  It's better to include some analysis of why this is a good
fix.

--oaK9NA/DDdTag9m3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSflHHAAoJELSic+t+oim9dvgP/14verD/m6nEcvCO92N2HZSM
+dTk5vtgGaIFiDy+EeH1mJwEyurfehbTw3BBIsIwv7Q1hoRTBBO7FuMRkLFZc2rx
UEPQFoA6XSEA21KqvUjkAvLH15Q8ys8E9JdKO2GBWIDjOFSDLK5fPhmevMrL5mbm
ueIZH2tC6095Ad/fr8sIjAOgwj0Ub/agm0hDXP70n42aBG82VbnUzgeYSvpqtYLV
jRIXwKQREmlUKUcIFyiX/r08OUhwvUNjBLiv2hblqrVVed6149CclNQ2t1vwUEdR
xZ96gXCE77XT2YgZTBqIb5WM9XZIf4t21hnSk85iZQA28aW89KWthGxx1FmkmT3R
xPvKpyXc9nB6P0rI5viMMriLg8arxwtjOjD1o/4sUU4wTDT3DXydehKlzbHfX8aa
Bcok2zo8z4mBAa/eS7GOXEodEpvP8LzMEZv/q14th0S7D4qQ44p85JSSVi7/aMYZ
FX/Y5qfpzfmcFfGU+Mq+MUHg7BJBispDLzY8rPYCLT6rvAAZF7EkRcaiZDLYFVHq
WD2JNPQws7f2CqqEHt9edq3/29HGpv8ix4Tbht2sQPleXJ05+LInU6dRkXW5ZzoL
loZPvyBkfAB63hxqoU7Fqj5PGS5fqrbyMrgr8QwCifKk77mI7qEmoCbN5gqZJ2Bp
sbua2IrMHd8yY+oRUdad
=71o5
-----END PGP SIGNATURE-----

--oaK9NA/DDdTag9m3--
