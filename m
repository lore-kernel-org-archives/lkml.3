Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaBDR3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:29:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaBDR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:29:21 -0500
Date: Tue, 4 Feb 2014 17:28:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140204172836.GH22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-5-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+TFC1kkuuXJmyCU6"
Content-Disposition: inline
In-Reply-To: <1391516352-32359-5-git-send-email-mporter@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/6] regulator: add bcm59056 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+TFC1kkuuXJmyCU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 07:19:10AM -0500, Matt Porter wrote:

> +static unsigned int bcm59056_get_mode(struct regulator_dev *dev)
> +{
> +	return REGULATOR_MODE_NORMAL;
> +}
> +
> +static int bcm59056_set_mode(struct regulator_dev *dev, unsigned int mode)
> +{
> +	if (mode == REGULATOR_MODE_NORMAL)
> +		return 0;
> +	else
> +		return -EINVAL;
> +}

These do nothing, don't implement them.

> +	if (bcm59056->dev->of_node)
> +		pmu_data = bcm59056_parse_dt_reg_data(pdev,
> +						      &bcm59056_reg_matches);

It'd seem a bit neater to put the OF check into the parse function but
meh.

> +	if (!pmu_data) {
> +		dev_err(&pdev->dev, "Platform data not found\n");
> +		return -EINVAL;
> +	}

Like I said when reviewing the binding this should not cause the driver
to fail to load.

> +		/*
> +		 * Regulator API handles empty constraints but not NULL
> +		 * constraints
> +		 */
> +		if (!reg_data)
> +			continue;

It should do...  if not then make it so since that'd mean most drivers
are buggy.

--+TFC1kkuuXJmyCU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8SNBAAoJELSic+t+oim9QioQAIw1I4kSTRw1PhNzOg0ZSoo9
TibrHRWXuthOrvf52eTwyZ/i3251wpIcH/+fTJC7EQz884p8DlaihrCq4NO8ZGXm
KgTMNsGAvTT6cex9i+2somZ1paNT4FWg94HFTrJwnmW7Ce53Zl5bUJQ6dC57Q6AQ
1RxW6ZEotnqE6q/b7xbGzwXfJeQi2QizaQO/HF0lF9qiVu5j6yoKiZVrTSUYhS/W
NYnrTUvFTeZDhcy1a3xms3SBPrfwlH/JRYC8e/lT/VWVjnecu+fAvYmWdQ/9h77z
eFKvjmeopnRndpdHKcJG5MAuv2eNM0FRCAH3l/5SMYjmwPkwfv38NMHIWXbdeZAY
m6adOL8c1RFZdnklmoWXsBsEo41nqgSWtV/ZTRCiOZFKRY+slItZy3AV7geAigKI
YgfsnqqEwzRaVTlbB4cXoIxOoxYsteFCA8FYEqZa4yGzx0BED6jxvMeTSEk/x/CU
dTQyD3ub0Oh1m/EZnWeCmew935Rzk9Qoi/6CgTdE8SI80PfExE54yD+R1X15InUE
81RXNLibBzEAdQRS4nfSMm9A8YcvDO4BnoM9y4Dh0W9bmZhwUcAYEW1lSXscnnMU
j5TGX6XsdKaXYUu/qwFz7F4km9m8ICZ9+kmSEBiQUMHNzq1AFOpHrwf4lvZb+LkU
qYcf2/jE6RXp3/MIrLHf
=KDaY
-----END PGP SIGNATURE-----

--+TFC1kkuuXJmyCU6--
