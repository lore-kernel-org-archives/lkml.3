Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3GTAIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:08:38 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31524 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab3GTAIg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:08:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Gong Yibin-B38343 <B38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] regulator: pfuze100: add pfuze100 regulator driver
Thread-Topic: [PATCH v3] regulator: pfuze100: add pfuze100 regulator driver
Thread-Index: AQHOhKXz82jyYb1WlEGVe5HRUKmAQZlssHQQ
Date: Sat, 20 Jul 2013 00:08:32 +0000
Message-ID: <95EEB29E288F544BAED903CDEA0C4C060110C4CA@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1374228891-8341-1-git-send-email-b38343@freescale.com>
 <20130719173047.GQ9858@sirena.org.uk>
In-Reply-To: <20130719173047.GQ9858@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [112.65.7.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark, I will send V4. 

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Saturday, July 20, 2013 1:31 AM
To: Gong Yibin-B38343
Cc: grant.likely@linaro.org; rob.herring@calxeda.com; rob@landley.net; lgirdwood@gmail.com; shawn.guo@linaro.org; devicetree-discuss@lists.ozlabs.org; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] regulator: pfuze100: add pfuze100 regulator driver

On Fri, Jul 19, 2013 at 06:14:51PM +0800, Robin Gong wrote:

> Add pfuze100 regulator driver.

Looks good, there's some minor issues below but they should be small.

> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -158,6 +158,13 @@ config REGULATOR_MC13892
>  	  Say y here to support the regulators found on the Freescale MC13892
>  	  PMIC.
>  
> +config REGULATOR_PFUZE100
> +	tristate "Support regulators on Freescale PFUZE100 PMIC"
> +	depends on I2C
> +	help
> +	  Say y here to support the regulators found on the Freescale PFUZE100
> +	  PMIC.
> +

Please keep this and the Makefile sorted - if there's issues merging then please use my topic/kconfig as a base.

> +		if (val & 0x40)
> +			ramp_delay = 50000 / (4 * ramp_delay);
> +		else
> +			ramp_delay = 25000 / (2 * ramp_delay);
> +		if (id <= PFUZE100_SW1C)
> +			ramp_delay = 25000 / (2 * ramp_delay);

This is a bit confusing as there's a cumalaitve modification applied to ramp_delay in the case that id is less than SW1C but it's not obvious that this is intentional given the calculations.  Please change this to make it clearer what the intended logic is (assuming it's not buggy) - something like if ... else if ... else for example.

> +	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
> +	if (ret)
> +		return ret;
> +	dev_info(pfuze_chip->dev,
> +		 "Full lay: %x ,Metal lay: %x\n",
> +		 (value & 0xf0) >> 4, value & 0x0f);

The space should be after not before the comma in the displayed string.

> +	dev_info(pfuze_chip->dev, "FAB: %x , FIN: %x\n",
> +		 (value & 0xc) >> 2, value & 0x3);

Only a space after the , for normal formatting.  ie both should look like "%x, bar".

