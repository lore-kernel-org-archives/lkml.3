Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbbAPJao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:30:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32766 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbAPJam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:30:42 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-33-54b8da3aadbc
Content-transfer-encoding: 8BIT
Message-id: <1421400684.11224.14.camel@AMDC1943>
Subject: Re: [PATCH V1] regulator: da9211: Add gpio control for enable/disable
 of buck
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Date: Fri, 16 Jan 2015 10:31:24 +0100
In-reply-to: <201501160901.t0G91F19021262@krsrvapps-01.diasemi.com>
References: <201501160901.t0G91F19021262@krsrvapps-01.diasemi.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7pWt3aEGBzu1rCY+vAJm8XtH6dZ
	LT6tcrX4dqWDyeLyrjlsFntbLzI7sHms+KTvsXPWXXaPTas62Tw+b5ILYInisklJzcksSy3S
	t0vgynjcsoSxoFmx4tuWqWwNjFOluhg5OSQETCSu7FzIBGGLSVy4t56ti5GLQ0hgKaPEjK5r
	LCAJXgFBiR+T7wHZHBzMAvISRy5lg4SZBdQlJs1bxAxR/5lR4vH5XlaIegOJ18/esIHYwgIR
	Epd72sDmsAkYS2xevgQsLgJUs/z6RkaIQRcZJea2+YDYLAKqEj97Z4IdxCngLHHh63GwXiEB
	J4mHT94zgdwgIaAs0djvNoFRYBaS62YhXDcLyXULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl
	5+duYoQE8tcdjEuPWR1iFOBgVOLhddi0I0SINbGsuDL3EKMEB7OSCO/GbUAh3pTEyqrUovz4
	otKc1OJDjEwcnFINjHKx8Q1dfl8V07kmTDit+3qjgxL3ajbWubkhB9ubQ04//B3cEOgj/vDJ
	/tWap5RUTE5f/7VX60/iTB8BrkW82dUvclJt5zxc97BI6fl34c7dd/ffdz/44eKJDzdX1ipZ
	VYtNbap4tnHFvQnLPwVYdX/ZqRURFat+uudozXGezMfyNy+JeN24baHEUpyRaKjFXFScCACR
	YdDrQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2015-01-16 at 17:59 +0900, James Ban wrote:
> This is a patch for adding gpio control about enable/disable of buck.
> 
> Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
> ---
> 
> This patch is relative to linux-next repository tag next-20150115.
> 
> 
>  .../devicetree/bindings/regulator/da9211.txt       |    7 ++++++-
>  drivers/regulator/da9211-regulator.c               |    6 ++++++
>  include/linux/regulator/da9211.h                   |    1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/da9211.txt b/Documentation/devicetree/bindings/regulator/da9211.txt
> index 240019a..ad777ac 100644
> --- a/Documentation/devicetree/bindings/regulator/da9211.txt
> +++ b/Documentation/devicetree/bindings/regulator/da9211.txt
> @@ -11,6 +11,7 @@ Required properties:
>    BUCKA and BUCKB.
>  
>  Optional properties:
> +- buck-enable-platform-gpio: platform gpio for control of BUCKA/BUCKB.
>  - Any optional property defined in regulator.txt
>  
>  Example 1) DA9211
> @@ -27,6 +28,7 @@ Example 1) DA9211
>  				regulator-max-microvolt = <1570000>;
>  				regulator-min-microamp 	= <2000000>;
>  				regulator-max-microamp 	= <5000000>;
> +				buck-enable-platform-gpio = <&gpio 27 0>;
>  			};
>  			BUCKB {
>  				regulator-name = "VBUCKB";
> @@ -34,11 +36,12 @@ Example 1) DA9211
>  				regulator-max-microvolt = <1570000>;
>  				regulator-min-microamp 	= <2000000>;
>  				regulator-max-microamp 	= <5000000>;
> +				buck-enable-platform-gpio = <&gpio 17 0>;

The suffix was changed to "-gpios".
(Documentation/devicetree/bindings/gpio/gpio.txt)

>  			};
>  		};
>  	};
>  
> -Example 2) DA92113
> +Example 2) DA9213
>  	pmic: da9213@68 {
>  		compatible = "dlg,da9213";
>  		reg = <0x68>;
> @@ -51,6 +54,7 @@ Example 2) DA92113
>  				regulator-max-microvolt = <1570000>;
>  				regulator-min-microamp 	= <3000000>;
>  				regulator-max-microamp 	= <6000000>;
> +				buck-enable-platform-gpio = <&gpio 27 0>;
>  			};
>  			BUCKB {
>  				regulator-name = "VBUCKB";
> @@ -58,6 +62,7 @@ Example 2) DA92113
>  				regulator-max-microvolt = <1570000>;
>  				regulator-min-microamp 	= <3000000>;
>  				regulator-max-microamp 	= <6000000>;
> +				buck-enable-platform-gpio = <&gpio 17 0>;
>  			};
>  		};
>  	};
> diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
> index c78d210..d299b0f 100644
> --- a/drivers/regulator/da9211-regulator.c
> +++ b/drivers/regulator/da9211-regulator.c
> @@ -24,6 +24,7 @@
>  #include <linux/regmap.h>
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
> +#include <linux/of_gpio.h>
>  #include <linux/regulator/of_regulator.h>
>  #include <linux/regulator/da9211.h>
>  #include "da9211-regulator.h"
> @@ -277,6 +278,10 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
>  
>  		pdata->init_data[n] = da9211_matches[i].init_data;
>  
> +		pdata->gpio_ren[n] =
> +			of_get_named_gpio(da9211_matches[i].of_node,
> +				"buck-enable-platform-gpio", 0);
> +
>  		n++;
>  	}
>  
> @@ -365,6 +370,7 @@ static int da9211_regulator_init(struct da9211 *chip)
>  		config.driver_data = chip;
>  		config.regmap = chip->regmap;
>  		config.of_node = chip->dev->of_node;
> +		config.ena_gpio = chip->pdata->gpio_ren[i];

Probably you want to set also config.ena_gpio_initialized because '0'
could be a valid GPIO. However that could be inconsistent with
platform_data for your driver so it's up to you.

Don't you have to enable the GPIO usage in the device (switch from I2C
control to GPIO)?

Best regards,
Krzysztof

>  
>  		chip->rdev[i] = devm_regulator_register(chip->dev,
>  			&da9211_regulators[i], &config);
> diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
> index 5479394..530b5ea 100644
> --- a/include/linux/regulator/da9211.h
> +++ b/include/linux/regulator/da9211.h
> @@ -32,6 +32,7 @@ struct da9211_pdata {
>  	 * 2 : 2 phase 2 buck
>  	 */
>  	int num_buck;
> +	int gpio_ren[DA9211_MAX_REGULATORS];
>  	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
>  };
>  #endif

