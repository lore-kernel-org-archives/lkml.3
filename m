Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaFITrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:47:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34322 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:47:44 -0400
Date: Mon, 9 Jun 2014 20:47:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140609194713.GF5099@sirena.org.uk>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402306670-17041-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yqX3wpb4QnjwKg06"
Content-Disposition: inline
In-Reply-To: <1402306670-17041-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yqX3wpb4QnjwKg06
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 11:37:46AM +0200, Javier Martinez Canillas wrote:

> +Optional node:
> +- voltage-regulators : The regulators of max77802 have to be instantiated
> +  under subnode named "voltage-regulators" using the following format.

Every other PMIC calls this node regulators...

> +	regulator_name {
> +		regulator-compatible = LDOn/BUCKn

regulator-compatible is deprecated, use the node name instead.

> +config MFD_MAX77802
> +	bool "Maxim Integrated MAX77802 PMIC Support"

Why is this bool and not tristate?

> +int max77802_irq_resume(struct max77802_dev *max77802)
> +{
> +	/*
> +	 * The IRQ that woke us up may still need to be ACK'ed on resume.
> +	 * If it isn't ever ACK'ed, future IRQs may not be delivered.
> +	 */
> +	if (max77802->irq)
> +		max77802_irq_thread(0, max77802);
> +
> +	return 0;
> +}

As covered in another subthread all this code looks like it should be
regmap-irq.

> +	if (regmap_read(max77802->regmap,
> +			 MAX77802_REG_DEVICE_ID, &data) < 0) {
> +		dev_err(max77802->dev,
> +			"device not found on this channel (this is not an error)\n");
> +		return -ENODEV;

If this is not an error why is it printed as dev_err()?  It does look
like an error to me, though.

> +	} else {
> +		dev_info(max77802->dev, "device found\n");
> +	}

These sort of prints are just noise, remove this unless there is some
revision information you can display.  It's also better practice to
check that the device ID is actually what was expected in case there was
an error in the DT.

> +static const struct i2c_device_id max77802_i2c_id[] = {
> +	{ "max77802", TYPE_MAX77802 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max77802_i2c_id);

We have type information here but not in the OF ID table (not that we
ever look at it).

--yqX3wpb4QnjwKg06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlg8+AAoJELSic+t+oim9tGsP/RrgPb6Ks5oqJYi8qd7kKfJi
HqC48BXqJACEvfLkvCun302iOEYFus4bX/q2tQ753ffz1qsoi2n8iDBNYLzYi87T
hllh0FWJHbMWmdoR22OjaWQLfYiF5MfgaRzsS+9eOkxNMeVXAJrAH91wormsA41W
fm7chn07pHGqbWYIUw4lULAOzBmtmkr7jIsroNuzROjwkb4Lyg8/8+epxAk9V2qm
TgB53v0yrqxWD41dZqwYT+u+rBhxGIqmv93OEZ3LzgFq4bcR33Amn7jNSkhSFf++
9/RrEmBWBmC5cuFXwpkZuqEzoYk4JoOhqFWZnWQv+uIRSMq8RiyxXAcagAtBJnok
FMJofsfT0Saitj7x42pdSylvUYU7DHcalslrwGD53Jay+3w7B5OkBS8pOJCLft7R
hzjizuKzKG+ULtStlKYtZ1fvX0KPeF3SDrE1IVXYMaT4MIuC98s+EVl3tiTXIrrc
F9vrk2op+mEmgC0Ea4HqWyhu9fGcfw4gpgaFWeI6TW5H+WDbhbU9bHwgR5mjNTJx
2SvA7v4UW617HSsJpQHNq6i+LRrSn1MAMydbPLhd38bh2SImmVQq8lcuc5utW/mX
jbUQqqEbotCdjdUggoKWj+rInlYXLmNljO+btrIrwO29JqqRZ+vYprGVd+FbN01b
Pde+ix2Kgvv4YuZNkXxf
=x6e0
-----END PGP SIGNATURE-----

--yqX3wpb4QnjwKg06--
