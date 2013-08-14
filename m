Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab3HNRhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:37:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60634 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3HNRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:37:33 -0400
Date: Wed, 14 Aug 2013 18:37:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130814173710.GC2401@sirena.org.uk>
References: <1376492282-15932-1-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <1376492282-15932-1-git-send-email-florian.lobmaier@ams.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] added support for ams AS3722 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 04:58:02PM +0200, Florian Lobmaier wrote:

> +++ b/drivers/regulator/Kconfig
> @@ -533,5 +533,12 @@ config REGULATOR_AS3711
>  	  This driver provides support for the voltage regulators on the
>  	  AS3711 PMIC
> =20
> +config REGULATOR_AS3722
> +        tristate "ams AS3722 PMIC regulators"
> +        depends on MFD_AS3722
> +        help
> +          This driver provides support for the voltage regulators of the
> +          ams AS3722 PMIC.
> +
>  endif

Keep this and the Makefile sorted please.

> + * as3722 ldo0 extended input range (0.825-1.25V)  */
> +static int as3722_ldo0_is_enabled(struct regulator_dev *dev)
> +{
> +	u32 val;
> +	struct as3722 *as3722 =3D rdev_get_drvdata(dev);
> +
> +	as3722_reg_read(as3722, AS3722_LDOCONTROL0_REG, &val);
> +	return (val & AS3722_LDO0_CTRL_MASK) !=3D 0;
> +}

These all look like you could use the standard regmap helpers.

> +static int as3722_ldo0_list_voltage(struct regulator_dev *dev,
> +				    unsigned selector)
> +{
> +	if (selector >=3D AS3722_LDO0_VSEL_MAX)
> +		return -EINVAL;
> +
> +	return 800000 + (selector + 1) * 25000;
> +}

This is just a linear mapping, use the standard helpers - the same thing
applies to most of the driver, it seems like there's standard helpers
for most of the enable and voltage management.

> +static int __init as3722_regulator_init(void)
> +{
> +	return platform_driver_register(&as3722_regulator_driver);
> +}
> +
> +subsys_initcall(as3722_regulator_init);

Modern platforms should just be able to register as a normal driver and
use deferred probing to sort out the init order.

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC8BDAAoJELSic+t+oim9r7AP/1nEXuqUQRgBTQnXIcr6YQcY
T/O88RJZOvMB3/3KCUPwc/eDeiZ3Jckp/yEfZ04vw5m2AbMEcX839GMH0XVgKU9Y
ZC9VGbgqYJqJRskHU8/gb+bFGaGmRhF4kjKa/fYn/F1w/n2SkRe8xE6csGNtGh6O
NEGo7e88KqlciB+6ziAgYgM+X8qyvtQVbWMw6CLh7zu/jKLIMQEiySvV3MG6gge9
6KCjQdIEp/p5dcfUOZ/PkmQPpYHEck7PeUQWaLV9Yh7Ek4KoCCDtmwllvr3At/wA
x0ovaO/pZpYmgzJX2Wx/nec4ndXSgx54MloYfvrU+Ab3Ex2BRdtpIvo3XNmOfU39
1SWM+oeFb+QpiXM9bc884xHlwazqokJJ+gOnzfipt0DmGyXcHWnnLHpXrkfm2cno
cMGeR+mJTigk1yUbWxLiRM3b5Wft0LXxcGxb2GuzrAX5qLhodbCw/4RDdRziOsMu
q+/WUn0y9RUJfnb4DWamy3MCvUWuJ5aUEfGfBkHWpw6wKxP5m9wIzaSwvoAK9wrB
wIXMxVY8X3xiRoCJIWV3iA65AmCnS124rF5o4nzlugi1Fz6hPj4/79ODI32j5sgN
8+HJFeKppJv9ExM4TKkMkPyNlvqetaMhHiI1BJFH0s9Rv9hzzpqeazRWBi8c0eWK
4gJ9hUTYBVR7gT+gRZXO
=Tqlr
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
