Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaENUUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:20:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44860 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaENUUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:20:42 -0400
Date: Wed, 14 May 2014 21:20:29 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140514202029.GL12304@sirena.org.uk>
References: <201405140306.s4E36COM023118@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nzRTX+kOj4DLtsZK"
Content-Disposition: inline
In-Reply-To: <201405140306.s4E36COM023118@swsrvapps-01.diasemi.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND PATCH V1] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nzRTX+kOj4DLtsZK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 04:02:34AM +0100, James Ban wrote:
> This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> Converter regulator. It communicates via an I2C bus to the device.

This looks a lot like the DA9210 driver, is there really no opportunity
for code sharing here?

> +	/*
> +	 * There are two voltage register set A & B for voltage ramping but
> +	 * either one of then can be active therefore we first determine
> +	 * the active register set.
> +	 */

I see this but...

> +	/* Select register set B for suspend voltage ramping. */
> +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_B);
> +		if (ret < 0)
> +			return ret;
> +	}

..this fairly clearly says that suspend mode is set B and normal mode is
set A.

> +static int da9211_suspend_enable(struct regulator_dev *rdev)
> +{
> +	struct da9211_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9211_regulator_info *info = regulator->info;
> +	struct da9211 *chip = regulator->da9211;
> +
> +	/* Select register set B for voltage ramping. */
> +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO)
> +		return regmap_update_bits(chip->regmap, info->conf.reg,
> +					info->conf.sel_mask,
> +					DA9211_VBUCKA_SEL_B);
> +	else
> +		return 0;
> +}

This looks like it will immediately shift to the suspend voltage but
what this should do is set the voltage which will be set in suspend
mode - something else (usually a hardware signal during suspend) should
actually enter it.

> +int da9211_enable_irq(struct da9211 *chip, int irq)
> +{
> +	enable_irq(irq);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(da9211_enable_irq);

> +int da9211_disable_irq(struct da9211 *chip, int irq)
> +int da9211_mask_irq(struct da9211 *chip, int irq)
> +int da9211_unmask_irq(struct da9211 *chip, int irq)

This looks bad...  similarly most of the rest of the interrupt code.
What is it supposed to be doing?

--nzRTX+kOj4DLtsZK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc9AKAAoJELSic+t+oim9ahYP/jm04YfOUxdDa6zfeg5zGsKY
SiILv8B39u6grnoSMNBJAN0EDCRhusxjx3H9YuHWDScEp+CaBHRH6Vhck+51dU37
4lTHxhqIlD4IC68AJPAN60JAlJoIZdUKdxGtawO9Pq6InxolvdgmuUjtr7PoPUsV
srEUyWPYFNNTWHDS2O2gLWqMdbApXMa2SMn8+tsCxEanxNPMZpUA/syGaOnwe84B
C1YZ8DarHBbQFnw1tigKNUiyJtCmr47Gq/Gft4wKpByl7UDHvqggfJlKBydWK6UB
k1aYfzETTnQlSv+maXYi4+AWpxpixsXV6Xx2b427lnP5xQ0acT32lV69/4I8mGxg
mMQLpoSQ4/LDvLTglXjKbVgbi07eec4TOT+cAA/hGMW6GMNkSbu+FwhA+2TyV0sb
/LIoRdXYS8aC53P+1yM7qM7FnYQFkOmjWMbDL1t0HKjojZCDpItn9eK5QVQtlJO3
pZpiFEmLGjoa8UOxw5Pz0bIQmWDJr4dRqmm4Dm1AiDXNuMZkBr5wTg7AmA7KJuYs
F2QNyhDk2n7RD5sZH2EqHIkzgdcDTllqsLDLirfo8Je4/g20S+l2aCpUaoXokxVq
0VtUBvA6Y15NRlGME7jBi/c/VnIAi7R+4lBc2tdD8WDQScB0cEvKthdnp9UejbK/
rc++gmKtr0GXOJdYcwUK
=HkI/
-----END PGP SIGNATURE-----

--nzRTX+kOj4DLtsZK--
