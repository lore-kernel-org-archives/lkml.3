Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbASAiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:38:52 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.170]:40338 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbbASAiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:38:51 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 19:38:50 EST
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-11.tower-39.messagelabs.com!1421627529!28352555!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1] regulator: da9211: Add gpio control for
 enable/disable of buck
Thread-Topic: [PATCH V1] regulator: da9211: Add gpio control for
 enable/disable of buck
Thread-Index: AQHQMWsCp3VLI3ekSkOfxjAgNMtU3JzCe40AgAQMpDA=
Date: Mon, 19 Jan 2015 00:32:08 +0000
Message-ID: <0ACAE736BB7A70499F1D8D5E6AC1854C01BDD81D9D@NB-EX-MBX01.diasemi.com>
References: <201501160901.t0G91F19021262@krsrvapps-01.diasemi.com>
 <1421400684.11224.14.camel@AMDC1943>
In-Reply-To: <1421400684.11224.14.camel@AMDC1943>
Accept-Language: ko-KR, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.95.26.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J0cv4r032476


January 16, 2015 18:31, Krzysztof Kozlowski wrote:

> On piÄ…, 2015-01-16 at 17:59 +0900, James Ban wrote:
> > This is a patch for adding gpio control about enable/disable of buck.
> >
> > Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
> > ---
> >
> > This patch is relative to linux-next repository tag next-20150115.
> >
> >
> >  .../devicetree/bindings/regulator/da9211.txt       |    7 ++++++-
> >  drivers/regulator/da9211-regulator.c               |    6 ++++++
> >  include/linux/regulator/da9211.h                   |    1 +
> >  3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/regulator/da9211.txt
> b/Documentation/devicetree/bindings/regulator/da9211.txt
> > index 240019a..ad777ac 100644
> > --- a/Documentation/devicetree/bindings/regulator/da9211.txt
> > +++ b/Documentation/devicetree/bindings/regulator/da9211.txt
> > @@ -11,6 +11,7 @@ Required properties:
> >    BUCKA and BUCKB.
> >
> >  Optional properties:
> > +- buck-enable-platform-gpio: platform gpio for control of BUCKA/BUCKB.
> >  - Any optional property defined in regulator.txt
> >
> >  Example 1) DA9211
> > @@ -27,6 +28,7 @@ Example 1) DA9211
> >  				regulator-max-microvolt = <1570000>;
> >  				regulator-min-microamp 	= <2000000>;
> >  				regulator-max-microamp 	= <5000000>;
> > +				buck-enable-platform-gpio = <&gpio 27 0>;
> >  			};
> >  			BUCKB {
> >  				regulator-name = "VBUCKB";
> > @@ -34,11 +36,12 @@ Example 1) DA9211
> >  				regulator-max-microvolt = <1570000>;
> >  				regulator-min-microamp 	= <2000000>;
> >  				regulator-max-microamp 	= <5000000>;
> > +				buck-enable-platform-gpio = <&gpio 17 0>;
> 
> The suffix was changed to "-gpios".
> (Documentation/devicetree/bindings/gpio/gpio.txt)
> 

I will change it.

> >  			};
> >  		};
> >  	};
> >
> > -Example 2) DA92113
> > +Example 2) DA9213
> >  	pmic: da9213@68 {
> >  		compatible = "dlg,da9213";
> >  		reg = <0x68>;
> > @@ -51,6 +54,7 @@ Example 2) DA92113
> >  				regulator-max-microvolt = <1570000>;
> >  				regulator-min-microamp 	= <3000000>;
> >  				regulator-max-microamp 	= <6000000>;
> > +				buck-enable-platform-gpio = <&gpio 27 0>;
> >  			};
> >  			BUCKB {
> >  				regulator-name = "VBUCKB";
> > @@ -58,6 +62,7 @@ Example 2) DA92113
> >  				regulator-max-microvolt = <1570000>;
> >  				regulator-min-microamp 	= <3000000>;
> >  				regulator-max-microamp 	= <6000000>;
> > +				buck-enable-platform-gpio = <&gpio 17 0>;
> >  			};
> >  		};
> >  	};
> > diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-
> regulator.c
> > index c78d210..d299b0f 100644
> > --- a/drivers/regulator/da9211-regulator.c
> > +++ b/drivers/regulator/da9211-regulator.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/regmap.h>
> >  #include <linux/irq.h>
> >  #include <linux/interrupt.h>
> > +#include <linux/of_gpio.h>
> >  #include <linux/regulator/of_regulator.h>
> >  #include <linux/regulator/da9211.h>
> >  #include "da9211-regulator.h"
> > @@ -277,6 +278,10 @@ static struct da9211_pdata
> *da9211_parse_regulators_dt(
> >
> >  		pdata->init_data[n] = da9211_matches[i].init_data;
> >
> > +		pdata->gpio_ren[n] =
> > +			of_get_named_gpio(da9211_matches[i].of_node,
> > +				"buck-enable-platform-gpio", 0);
> > +
> >  		n++;
> >  	}
> >
> > @@ -365,6 +370,7 @@ static int da9211_regulator_init(struct da9211 *chip)
> >  		config.driver_data = chip;
> >  		config.regmap = chip->regmap;
> >  		config.of_node = chip->dev->of_node;
> > +		config.ena_gpio = chip->pdata->gpio_ren[i];
> 
> Probably you want to set also config.ena_gpio_initialized because '0'
> could be a valid GPIO. However that could be inconsistent with
> platform_data for your driver so it's up to you.
> 

I will set config.ena_gpio_initialized.

> Don't you have to enable the GPIO usage in the device (switch from I2C
> control to GPIO)?
> 

We assume default setting for GPIO usage is programed in the device.

> Best regards,
> Krzysztof
> 
> >
> >  		chip->rdev[i] = devm_regulator_register(chip->dev,
> >  			&da9211_regulators[i], &config);
> > diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
> > index 5479394..530b5ea 100644
> > --- a/include/linux/regulator/da9211.h
> > +++ b/include/linux/regulator/da9211.h
> > @@ -32,6 +32,7 @@ struct da9211_pdata {
> >  	 * 2 : 2 phase 2 buck
> >  	 */
> >  	int num_buck;
> > +	int gpio_ren[DA9211_MAX_REGULATORS];
> >  	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
> >  };
> >  #endif

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
