Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaHVAhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:37:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54017 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaHVAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:37:09 -0400
Date: Thu, 21 Aug 2014 19:36:50 -0500
From: Mark Brown <broonie@kernel.org>
To: atull@opensource.altera.com
Cc: linux@roeck-us.net, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20140822003650.GQ24407@sirena.org.uk>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
 <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnQ62SBZf/0gbjGf"
Content-Disposition: inline
In-Reply-To: <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] pmbus: ltc2978: add regulator gating
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QnQ62SBZf/0gbjGf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 05:21:26PM -0500, atull@opensource.altera.com wrote:

> +config SENSORS_LTC2978_REGULATOR
> +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> +	default n

No need to say default n here, it's the default default.

> +	depends on SENSORS_LTC2978
> +	select REGULATOR

I'd expect a depends here.

> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>

If you need machine.h that's suspicious...  why do you need it?

> +static int ltc2978_write_pmbus_operation(struct regulator_dev *rdev, u8 value)
> +{
> +	struct device *dev = rdev_get_dev(rdev);
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	int ret;
> +
> +	ret = pmbus_set_page(client, 0xff);
> +	if (ret < 0)
> +		return ret;
> +
> +	return i2c_smbus_write_byte_data(client, PMBUS_OPERATION, value);
> +}

This all looks very much like pmbus could use regmap and then the regmap
helpers.  I'd not insist on it though.  What I would however suggest is
that these functions should all be helpers which read the specific
page, addresses and bits to write from the driver structure - I bet the
code is going to be identical for most pmbus using regulators and so it
makes sense to share it like we do with the generic regmap functions.

That means that any good practice can be deployed more easily and any
API updates only need to update the helpers.

> +static struct regulator_init_data ltc2978_regulator_init = {
> +	.constraints = {
> +		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
> +	},
> +};

You should not be forcing this on, you don't know what's safe on any
given board.  Allow the board to specify constraints then it has
control.

--QnQ62SBZf/0gbjGf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9pCaAAoJELSic+t+oim95/AQAJBdLKWmfBhC0DZLKA59KaHD
XaEnqz6WgACkJWij6cduXFNW41JhnT/NeuQHypWGbeQ7+HYWVNO/9jYRsO4SFh4n
Jcyd7qiIU+Pfcw4Ee++dGrT+FeuYTYeY8W6vd5fErwI7Fd0liPESk7wybImPDJoS
AQDrZwyfgB48fns8GwukAignXTn0PMowSTDHDVDT0pStUuqZGZzK+RV6N2b069/q
E88+5TW15xnTzI0xPvZ+6B61bzZxFVJbvnUynctmP6gNqlEY4CUHgmySyCjI9/Oo
eM8u669kOEkeeNJLTZ8JxKZYwp4yijE+HqJ2F4QZMzXE/9+i+BilEBGDaGhd9Ocq
2mNL476GYEqfCp7l+84jI1sBR5LRcAg+j19yrxPKt+4oSSyPGTypvFn10rG9zZ79
stAfdILmSq/gvSmcm48V5Itw+of4HpdHHWtf/6gVrxW+dn9d4lywespgeKv1gbgW
TaYM5RyWpnD9DnBsG397a8MEl58v47VEV9t6QME8w7h4tsDtdPGI3VLFPQsZHzLk
dGJegrDGRtOAt5FSh84WWHU4/noWjRSgjof4vt3GPmZkqOHxo3lMKGKttIqeaAc7
dKWkDWLM8V8lkS9Q7DkcqGgUeWhGnreiX9XJ/HxG74Kg+LIFmS/idXuAEC904Z6+
rv5TCjsKCOBg/DA17mMe
=eRDL
-----END PGP SIGNATURE-----

--QnQ62SBZf/0gbjGf--
