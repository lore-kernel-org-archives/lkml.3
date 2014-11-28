Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaK1PXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:23:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42187 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaK1PXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:23:45 -0500
Date: Fri, 28 Nov 2014 15:22:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141128152247.GR7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-4-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9GzRb0CqzA06KMG9"
Content-Disposition: inline
In-Reply-To: <1417146874-5232-4-git-send-email-flora.fu@mediatek.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/8] regulator: MT6397: Add support for MT6397
 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9GzRb0CqzA06KMG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2014 at 11:54:29AM +0800, Flora Fu wrote:

> @@ -96,5 +97,4 @@ obj-$(CONFIG_REGULATOR_WM8350) +=3D wm8350-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8400) +=3D wm8400-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8994) +=3D wm8994-regulator.o
> =20
> -
>  ccflags-$(CONFIG_REGULATOR_DEBUG) +=3D -DDEBUG

Random whitespace change here...

> +	/* For HW design, buck voltage control register has two parts.
> +	 * part 1: vsel_reg for register mode
> +	 * part 2: voselon_reg or hw control mode
> +	 * Both parts should be updated and sync when user set voltage.
> +	 */

Why does nothing else in the driver know about this "hw control mode" -
what does it actually mean, shouldn't it affect some of the other
operations?

> +	ret =3D regmap_update_bits(rdev->regmap, info->desc.vsel_reg,
> +		info->desc.vsel_mask, sel);
> +	if (ret !=3D 0) {
> +		dev_err(&rdev->dev, "Failed to update vsel: %d\n", ret);
> +		return ret;
> +	}
> +	ret =3D regmap_update_bits(rdev->regmap, info->voselon_reg,

Missing blank line between these blocks.

> +static int mt6397_buck_get_voltage_sel(struct regulator_dev *rdev)
> +{

> +static int mt6397_regulator_is_enabled(struct regulator_dev *rdev)
> +{

To repeat my comments on the last version: please use the generic regmap
operations rather than copying them.

> +	np =3D of_node_get(pdev->dev.parent->of_node);
> +	if (!np)
> +		return -EINVAL;
> +
> +	regulators =3D of_get_child_by_name(np, "regulators");

To further repeat my previous review comments:

| Define regulators_node and of_match in the regulator desc and you can
| remove both this table and all your DT matching code in the driver, the
| core will handle it for you.

Please don't ignore review comments.

--9GzRb0CqzA06KMG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJNGAAoJECTWi3JdVIfQuWoH/jYZ78/0hq8D2jvV/qB6YYc2
SR2UIn5Hy4g1+O/gkyC108xKxfQz0EW5C595VOGWni6GP4qGvBJNsEXIc/bg32Z2
CVbUeEccj34Xu5U38HR6HR2xUuIJFmKOeHjGWe2hImfC/QfitWphbnHtcIVVzkFX
LUj1L9V/9q9lGKGzinWjiN2WB/7SMW1IJPJfbeoIdNRMV6lvnFZKCd/V/sUw/De3
HOqZ0PsdM7COkpm873alMPG3q2aM4usq17SZKso8Xr3Hh9xcgEQTEalRHINnLes/
Txvyc2rAZJNAYmnndsjhtznMREtD9Ej0+NSOvAj/RQzv0q6kMH4q3PUlT/wZK/w=
=MlFV
-----END PGP SIGNATURE-----

--9GzRb0CqzA06KMG9--
