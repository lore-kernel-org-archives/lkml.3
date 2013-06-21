Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161576Ab3FUPYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:24:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33239 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:24:19 -0400
Date: Fri, 21 Jun 2013 16:24:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, yizhang@marvell.com,
        xiechao.mail@gmail.com
Message-ID: <20130621152416.GC27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PYvLm/IFaQmMAfx6"
Content-Disposition: inline
In-Reply-To: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PYvLm/IFaQmMAfx6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 03:31:07AM -0400, Chao Xie wrote:

Looks pretty good, main thing here is that some of the functionality
here appears to be reproducing standard code.

> +static int pm800_set_voltage(struct regulator_dev *rdev,
> +			     int min_uv, int max_uv, unsigned *selector)
> +{

Use set_voltage_sel() and map_voltge_ascend()

> +static int pm800_get_voltage(struct regulator_dev *rdev)
> +{
> +

Just provide get_voltage_sel(), the core will do the mapping to voltages
using list_voltage().

> +	} else if (pdata->num_regulators) {
> +		/* Check whether num_regulator is valid. */
> +		unsigned int count = 0;
> +		for (i = 0; pdata->regulators[i]; i++)
> +			count++;
> +		if (count != pdata->num_regulators)
> +			return -EINVAL;

This looks...  odd.

> +static int __init pm800_regulator_init(void)
> +{
> +	return platform_driver_register(&pm800_regulator_driver);
> +}
> +subsys_initcall(pm800_regulator_init);
> +
> +static void __exit pm800_regulator_exit(void)
> +{
> +	platform_driver_unregister(&pm800_regulator_driver);
> +}
> +module_exit(pm800_regulator_exit);

With deferred probing you should just be able to use
module_platform_driver().

> +config REGULATOR_88PM800
> +	bool "Marvell 88PM800 Power regulators"
> +	depends on MFD_88PM800=y
> +	help
> +	  This driver supports Marvell 88PM800 voltage regulator chips.
> +	  It delivers digitally programmable output,
> +	  the voltage is programmed via I2C interface.
> +	  It's suitable to support PXA988 chips to control VCC_MAIN and
> +	  various voltages.
> +

Keep this file sorted please.

> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
>  obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
> +obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o

Same here.

--PYvLm/IFaQmMAfx6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxHAcAAoJELSic+t+oim9nSgP/03avwcCwpoXxgSjvg2MTgXK
2OzBb69oXOfGiHmmtzCztWAYqc27jCZW6qt7ZsXgppPrUSI4M5iE030GQ21ZQdbW
/u+4onM1sJDir99gI14JdBZPXPrRja5NuwJPJ0Sr+1fGig2L5TeeGZ9a1/2DapGU
zT8kzOR+XeInGfdY/xP/PwDIKorWfFNxn/EZuK/k2XsOuJIcFzl6RBfE5JZbOc93
DAT8Y9osuN8PIFDYP1xGj6yuCkVg680O2pcH/phm2M85veKE212yGLcUM/E52lO4
D1E5HS9VQlBe5RIYydQfiugmyAZLi411I+5awFsJYqQStwvWJqYUTIaxbH9m+any
G1a1l7GEIx4K2Om5aFtMU0wLn7J0keWROn9vzH5q6R71kwB9ljcVphIDNkH6JopD
/QrfN4LNkW+Hzf+BcLZUBSHg4Hycrd+LUPbyUULZRPm0HgNqkoHLyLR7lrUUnMHJ
HeUapCeEGET9Elrc6cOtZ0VvIgJW9YTXHYy981wukSQdCgc0kTeDUe/MiYvJpTVE
jW+FOripLwHWKYv0DXrESU5Ez7z3o9zW5cOsFohbmA4INn677fs4CcHCt59aa009
gH8EauWxOS5g5tf5hGW5nU2tJ59mteYiisGnBOUYF+Xo/UiG8qj0HRZyNDpISrD8
eAdtsvNZjgcsUseOHWb3
=5M24
-----END PGP SIGNATURE-----

--PYvLm/IFaQmMAfx6--
