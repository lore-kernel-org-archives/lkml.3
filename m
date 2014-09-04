Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaIDJLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:11:04 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63357 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbaIDJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:11:00 -0400
Date: Thu, 4 Sep 2014 10:10:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 3/3] mfd: max77693: add haptic of_compatible in mfd_cell
Message-ID: <20140904091054.GC29612@lee--X1>
References: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
 <1409570071-26719-4-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409570071-26719-4-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Jaewon Kim wrote:

> This patch add haptic of_compatible in order to use the Haptic device driver
> using devicetree. and added the related documentation and example.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77693.txt |   19 +++++++++++++++++++
>  drivers/mfd/max77693.c                             |    2 +-

These should be in different patches - please split them.

>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> index 11921cc..6e30ad8 100644
> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> @@ -27,6 +27,18 @@ Optional properties:
>  
>  	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>  
> +- haptic :
> + Required properties:
> +	- compatible : Must be "maxim,max77693-hpatic"
> +	- pwms : phandle to the physical PWM device,
> +		A feel can be changed by changing a peroid cycle.

What is "a feel"?

Why is this this comment relevant to documenting the 'pwms' property?

> + Optional properties:
> +	 - haptic-supply : power supply for haptic motor
> +	 - pwm-names : Name to be used by the PWM subsystem for the PWM device

Are you sure this is optional?  If it is and given that there is only
one pwm, perhaps you need to remove it altogether?  *-names properties
are usually only required if there are more than one.

> + The haptic require of max77693 have to be instantiated under subnod
> +  named "haptic" using the following haptic format in example.
> +
>  Example:
>  	max77693@66 {
>  		compatible = "maxim,max77693";
> @@ -52,4 +64,11 @@ Example:
>  					regulator-boot-on;
>  			};
>  		};
> +
> +		haptic {
> +			compatible = "maxim,max77693-haptic";
> +			haptic-supply = <&haptic_supply>;
> +			pwms = <&pwm 0 38022 0>;
> +			pwm-names = "haptic";
> +		};
>  	};
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index fbfed56..ceb7ebf 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -46,7 +46,7 @@ static const struct mfd_cell max77693_devs[] = {
>  	{ .name = "max77693-charger", },
>  	{ .name = "max77693-flash", },
>  	{ .name = "max77693-muic", },
> -	{ .name = "max77693-haptic", },
> +	{ .name = "max77693-haptic", .of_compatible = "maxim,max77693-haptic" },

Can you break this last entry out, so:

{
  .name = "max77693-haptic",
  .of_compatible = "maxim,max77693-haptic"
},

>  };
>  
>  static const struct regmap_config max77693_regmap_config = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
