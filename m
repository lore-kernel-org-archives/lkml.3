Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3GXRHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:07:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41008 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GXRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:07:44 -0400
Date: Wed, 24 Jul 2013 18:07:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130724170721.GQ9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gepL2JgcC5Q6nP6x"
Content-Disposition: inline
In-Reply-To: <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gepL2JgcC5Q6nP6x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 06:34:42PM +0200, Philipp Zabel wrote:

> +	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_ID, &model);
> +	if (ret < 0) {
> +		dev_err(da9063->dev, "Cannot read chip model id.\n");
> +		return -EIO;
> +	}
> +
> +	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_VARIANT, &revision);
> +	if (ret < 0) {
> +		dev_err(da9063->dev, "Cannot read chip revision id.\n");
> +		return -EIO;
> +	}

Is it possible to valiate these at all?

> +static int __init da9063_i2c_init(void)
> +{
> +	int ret;
> +
> +	ret = i2c_add_driver(&da9063_i2c_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register da9063 I2C driver\n");
> +
> +	return ret;
> +}
> +subsys_initcall(da9063_i2c_init);

You should really be able to use module_i2c_driver() for modern systems,
probe deferral should resolve the init order issues.

--gepL2JgcC5Q6nP6x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8AnGAAoJELSic+t+oim9iBoP/A2wEBUM5PD62tOdWfzUF3t0
c/AXbiMcMGHLiF7O6NAzLe4hUz1NQpEsx7dFIReFeWDHuw35Q7J+uY9vqJ5GGx2K
DQRZddxboq98hDsH7a4VisP3dWFEyeV4WRonsk54HSRU55tkvTeyrf7c0sosfvR4
mddurseRMww1UxfuqTHFR8d8ndUl/dlflpSq03QuYXgP0mzhazwYcI0nW47cls9N
BG14q7sO6S3kHlT31RMVmSEH+haB1TJXoRNOibxLArWhNLPrEMv6tu3cHkwQa/qg
dvU8YFR2JInQMhgvNE7Uq2jA/45NJeXQxa5MCzKvIslRCBZRcGVTgPeW4/WimYD1
WxXLMc0U66QfvvkegDzBPsynYGOsk9Ar8GqRsi0+5u0CdtcousrkmWhiylh0l9mF
y4vdfEHpZQHgnPlM44E93KuSreToOOwE8OhsGh/n2TGamL9025kMeY1BTCbKxEa/
5VIrKX3BDmn7mDjgOpI+PB01IOeIzANqD0AXBi6z0XacOU3YK0iT2M8/keh65GME
1Ptmxtvj46NaoHvXWoEvVen3j/oWaV6BnZCydTYr3w0aJMfUGuBJuikntIPfn0LB
WgoyZ325B5cNeIQapJxNcCQb+9Lg874HMYs9kp1e8IAM957FoHxRDXc/Szxw506G
QizVR7vl8A9OCQ2f3TQF
=qK8V
-----END PGP SIGNATURE-----

--gepL2JgcC5Q6nP6x--
