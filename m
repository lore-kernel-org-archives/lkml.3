Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaHQOHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:07:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40986 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHQOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:07:14 -0400
Date: Sun, 17 Aug 2014 09:06:28 -0500
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Message-ID: <20140817140628.GG14537@sirena.org.uk>
References: <1408240839-29512-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Content-Disposition: inline
In-Reply-To: <1408240839-29512-1-git-send-email-zyw@rock-chips.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] RK808: Add rk808 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 10:00:39AM +0800, Chris Zhong wrote:
> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
> The output voltages are configurable and are meant to supply power
> to the main processor and other components

Looks very good - a few small nits below but otherwise fine.  Please use
subject lines matching the style for the subsystem (regulator: in this
case).

> +	reg_np = of_find_node_by_name(np, "regulators");
> +	if (!reg_np)
> +		return -ENXIO;

This needs to be find_child_by_name() otherwise it'll search the entire
device tree and might match other regulators in the system.

> +	count = of_regulator_match(rk808->dev, reg_np, rk808_reg_matches,
> +				   rk808_NUM_REGULATORS);

Should really use RK808_NUM_REGULATORS as the name of the constant -
defines are always upper case.

> +	pdata = rk808->pdata;
> +	if (!pdata) {
> +		dev_err(rk808->dev, "%s no pdata\n", __func__);
> +		return -ENODEV;
> +	}

Missing platform data should be fine for a regulator driver, it should
be able to start up and let the user read back how the device is
configured.

> +		if (reg_data->constraints.name)
> +			rail_name = reg_data->constraints.name;
> +		else
> +			rail_name = rk808_reg[i].name;

Don't do this, just use the rk808_reg name - the regulator core will
take care of applying the name from the constraints.

> +		reg_data->supply_regulator = rail_name;

This should be fixed in the driver, it should be whatever the name the
device uses for the supply in the datasheet.

> +		rk808_rdev = regulator_register(&rk808_reg[i], &config);
> +		if (IS_ERR(rk808_rdev)) {

devm_regulator_register() and then you don't need to clean up on
removal.

> +MODULE_DESCRIPTION("regulator driver for the rk808 series PMICs");
> +MODULE_AUTHOR("Chris Zhong<zyw@rock-chips.com>");
> +MODULE_AUTHOR("Zhang Qing<zhanqging@rock-chips.com>");

Should have a space before the < here.

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8LbgAAoJELSic+t+oim918gP/1JBvEEJD9q0D15KYrUFzdzo
vbmgga+hR9ogm4/HhpcTy/jK2ODUwIZgXOkGi9UVImXOYHg4NWjjpzYf9z8T9Fi2
Wf2XWgYlaxmVMyN/umjfnapJmUpCDoO25tgCwt8EoRIyz4xhNH6PVoCAwGvEQl4C
McqwSjK31yJOrZzBtSK3hqyig0Q5/WcIADcEyjOmR95V63dbRDzR2z3zLgXbij5S
lfmMhtyMAe7hHH86RC29/63mOixyBaqKR3Gs6h97MvooVF3WEwIU37gILxxmA18A
sAypjAvtf74+mWHy38jeUd7NnsVTARng+BrtRnl8p58lDN/plRIXAHWWsNjdDMO0
sQ8H7KuCdytOz1IfrSSM3Yq6q0nPh78cOCxrkBf5vEPuHsggVUhbA4WeHIeKpZxd
y4yHZ+LQfsgqXCNS7SAiwKg/YsWYHVh34Yi888wsXK4hTj1Bsru8dzTV9unxLtrB
vr9DTOHWSA5lH94jldMcNrR8FP7hlPTJfKKfRBsS4bBx+s3VaONLcn10BUVDIlhU
VHJCLk8h5pjTL+gPKE3THTOrhoepxx4V9keRwz7Sg00Jo/ayREGxGmQRBOOBA/Tp
kbInznKilIe/M6xOtwDaFTBnQX9KJ7v8rIDUwiW7FX6+w1UwMs7tbYhPvreUyq3K
fPABWeYgMTThMoGBNDMW
=qrDv
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
