Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab3GSRa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:30:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56511 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3GSRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:30:56 -0400
Date: Fri, 19 Jul 2013 18:30:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        lgirdwood@gmail.com, shawn.guo@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130719173047.GQ9858@sirena.org.uk>
References: <1374228891-8341-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KHqYxKoy+XnO4RVf"
Content-Disposition: inline
In-Reply-To: <1374228891-8341-1-git-send-email-b38343@freescale.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KHqYxKoy+XnO4RVf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2013 at 06:14:51PM +0800, Robin Gong wrote:

> Add pfuze100 regulator driver.

Looks good, there's some minor issues below but they should be small.

> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -158,6 +158,13 @@ config REGULATOR_MC13892
>  	  Say y here to support the regulators found on the Freescale MC13892
>  	  PMIC.
> =20
> +config REGULATOR_PFUZE100
> +	tristate "Support regulators on Freescale PFUZE100 PMIC"
> +	depends on I2C
> +	help
> +	  Say y here to support the regulators found on the Freescale PFUZE100
> +	  PMIC.
> +

Please keep this and the Makefile sorted - if there's issues merging
then please use my topic/kconfig as a base.

> +		if (val & 0x40)
> +			ramp_delay =3D 50000 / (4 * ramp_delay);
> +		else
> +			ramp_delay =3D 25000 / (2 * ramp_delay);
> +		if (id <=3D PFUZE100_SW1C)
> +			ramp_delay =3D 25000 / (2 * ramp_delay);

This is a bit confusing as there's a cumalaitve modification applied to
ramp_delay in the case that id is less than SW1C but it's not obvious
that this is intentional given the calculations.  Please change this to
make it clearer what the intended logic is (assuming it's not buggy) -
something like if ... else if ... else for example.

> +	ret =3D regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
> +	if (ret)
> +		return ret;
> +	dev_info(pfuze_chip->dev,
> +		 "Full lay: %x ,Metal lay: %x\n",
> +		 (value & 0xf0) >> 4, value & 0x0f);

The space should be after not before the comma in the displayed string.

> +	dev_info(pfuze_chip->dev, "FAB: %x , FIN: %x\n",
> +		 (value & 0xc) >> 2, value & 0x3);

Only a space after the , for normal formatting.  ie both should look
like "%x, bar".

--KHqYxKoy+XnO4RVf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6XfEAAoJELSic+t+oim9Z1EQAJbPInvtryaU/DY6YXwBwVbP
GalzxmXOQbP/HkvG951ynukLABHYa0v1qja52S2bLyc/CCKjVMPebBkxRFLsD1Ql
nnMUVYKoi5iCOD0Ak8W6UqpSbFHyMHDtgMQpmJEc97um7B6noI3MgE/7gLjPgfXa
CJLJon8Kgqbk3tgso2Isj2uXdbSfLRDSqD8K64aNxGElKXAmHsxzkhPJXv03As6D
FB6bRXzcG/NamvV5OpVbJekGB5CALbOw3AZmg4Wo2tcJBZeZMr5UDXmYoJpBtAtY
BRH71Qy5FFPzR8EwHsjlwI2oNkvJzZTynPpLRiByTNq4ABaTejwjXnQHlEoVOr/7
PpvvSom/dm0PVyRtfM+3kVG14RMht9cqZcE+ui9VAj60DI1gbvgloFYlpDVSg3g1
MH/BLKTjzrd/wHlvtGykTA9rzRAsPLIiZwKdeyby8Xw94hRxkeW/xlgf/TTALofO
OZLIbEfxMAU8GzOFMyCZOZFJtk6aikRh3jMzSjoskJWdoJadxC8bDp27Z3DK4YHv
vHvznpe8wJTsScP/skQObHLNvmG9WsjChEV4ddWmxQz1jYPSVvJEnWMDbuvuVeXo
AN9ZwvRDxca7kDgZt1o1RWz7N9Dzsrq8Ex9+Y5FZZAMLyBHGX2FozEpNZsE+vPx5
bYBdoy6829rUzcxiKAOw
=MAH0
-----END PGP SIGNATURE-----

--KHqYxKoy+XnO4RVf--
