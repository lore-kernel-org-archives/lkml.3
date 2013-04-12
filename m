Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3DLN0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:26:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50056 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab3DLN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:26:54 -0400
Date: Fri, 12 Apr 2013 14:26:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Message-ID: <20130412132651.GB12534@opensource.wolfsonmicro.com>
References: <201304121310.r3CDAJHh011814@latitude>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <201304121310.r3CDAJHh011814@latitude>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:

This looks good, I assume there's some dependencies on the MFD or other
earlier patches so I won't apply it, let me know if there aren't any and
I will:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please use subject lines reflecting the subsystem.

> +static int da9058_buck_ramp_voltage(struct regulator_dev *rdev,
> +					unsigned int old_selector,
> +					unsigned int new_selector)
> +{
> +	struct da9058_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9058 *da9058 = regulator->da9058;
> +	int ret;
> +
> +	if (regulator->ramp_register == 0)
> +		return -EINVAL;
> +
> +	if (regulator->ramp_enable_mask == 0)
> +		return -EINVAL;
> +
> +	ret = da9058_set_bits(da9058, regulator->ramp_register,
> +					regulator->ramp_enable_mask);
> +
> +	if (ret)
> +		return ret;
> +
> +	return 2200; /* micro Seconds needed to ramp to new voltage*/
> +}

Hrm, this really should be implementable with a generic regmap
operation...

> +	rdev = regulator_register(&reg->desc, &config);
> +
> +	if (IS_ERR(rdev)) {
> +		dev_err(&pdev->dev, "failed to register %s\n",
> +			rpdata->regulator_name);
> +		ret = PTR_ERR(rdev);
> +		goto failed_to_register;
> +	}

In general it's a bit better style to print out the return value to help
with diagnosis but it's no big deal.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRaAuQAAoJELSic+t+oim9KasQAI0Ga2Zq7aFHL/f79QLCyAAr
SNnMCXlqf5oAXhuKBWT6XgYL93Q+Y/EzwW61Z1ySZJhCF4b6D9tdy/8a0ZqZceG7
LK0sCGAFV+JkjvpOj4dWuxb2pPCKizKDXSfP4iigydDU73hK/Tib2j9oNzOBHeKA
lBqx6zzgZbrNzCisORj7ov7Y37KhOAW/9RFzDw2cinSzt27Sf+54f/vhVvr2Dud2
OhKzlhiFFMSuKyIuTfMXoIdITSGeH1axjhFIlOFxP1dn2lFFcX2Q1FdScdmgWScw
cXK+X96k59dJy+KpBWQZ71amqHmVeafB+CTjpOResGhF/nvPA/e/6EjjAodTUVkR
WV7yRZo1dzVFpwJ0G4v+MFCIwqxSHTFzkV53MCJTu4fW3ZSujr0MB0m2RRUFLwrT
poOyejF1BkOsCluUeJ0hiqVzPmz6x6v2XwxUEt+ekKWPDSCoBQreBsFB1AJnZtgm
FAp5rK9aIDkj/xJYX6HK1KBqPPseLVkDj0Gg2s/4KtOfSPn4KN23X2dpz+VuXayT
SX7zSvhxmDDzQjvkql7AaSHtKYYX42sOODTDhb+b8yYc0g4cmssxHD20h/MpTkzU
Xc6YmQbbknWMUtjtowT6z2fouP/ck7qveE47gvnHvJ2/9awfwp0wlA0C2CGOFgf9
93+t8wAfyMEvOzGqXrZi
=+1AA
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
