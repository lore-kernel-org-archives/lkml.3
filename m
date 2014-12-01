Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaLALPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:15:49 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:45413 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaLALPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:15:46 -0500
Date: Mon, 1 Dec 2014 11:15:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20141201111535.GA15845@x1>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Jacek Anaszewski wrote:

> This patch adds device tree binding documentation for
> the flash cell of the Maxim max77693 multifunctional device.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: <devicetree@vger.kernel.org>
> ---
>  Documentation/devicetree/bindings/mfd/max77693.txt |   74 ++++++++++++++++++++
>  1 file changed, 74 insertions(+)

This definitely requires a DT Ack.

> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> index 01e9f30..50a8dad 100644
> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> @@ -41,6 +41,62 @@ Optional properties:
>  	 To get more informations, please refer to documentaion.
>  	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>  
> +- led-flash : the LED submodule device node
> +
> +There are two led outputs available - fled1 and fled2. Each of them can
> +control a separate led or they can be connected together to double
> +the maximum current for a single connected led. One led is represented
> +by one child node.
> +
> +Required properties:
> +- compatible : must be "maxim,max77693-flash"

I'm not sure this compatible string is suitable.  It looks like
NOR/NAND Flash to me.  Perhaps 'fled', or just 'led' would be better.

> +Optional properties:
> +- maxim,fleds : array of current outputs in order: fled1, fled2

Nit: Sentences start with an uppercase character.

This is true for all other occurrences.

> +	Note: both current outputs can be connected to a single led
> +	Possible values:
> +		0 - the output is left disconnected,
> +		1 - a diode is connected to the output.
> +- maxim,trigger-type : Array of trigger types in order: flash, torch
> +	Possible trigger types:
> +		0 - Rising edge of the signal triggers the flash/torch,
> +		1 - Signal level controls duration of the flash/torch.
> +- maxim,trigger : Array of flags indicating which trigger can activate given led
> +	in order: fled1, fled2
> +	Possible flag values (can be combined):
> +		1 - FLASH pin of the chip,
> +		2 - TORCH pin of the chip,
> +		4 - software via I2C command.
> +- maxim,boost-mode :
> +	In boost mode the device can produce up to 1.2A of total current
> +	on both outputs. The maximum current on each output is reduced
> +	to 625mA then. If there are two child led nodes defined then boost
> +	is enabled by default.
> +	Possible values:
> +		0 - no boost,
> +		1 - adaptive mode,
> +		2 - fixed mode.
> +- maxim,boost-vout : Output voltage of the boost module in millivolts.
> +- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
> +	if chip estimates that system voltage could drop below this level due
> +	to flash power consumption.
> +
> +A child node must be defined per sub-led.
> +
> +Required properties of the LED child node:
> +- label : see Documentation/devicetree/bindings/leds/common.txt
> +- maxim,fled_id : identifier of the fled output the led is connected to:
> +		1 - FLED1,
> +		2 - FLED2.

Better to define all of these random numbers in include/dt-bindings.

> +Optional properties of the LED child node:
> +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> +		Range: 15625 - 250000
> +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> +		Range: 15625 - 1000000
> +- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
> +		Range: 62500 - 1000000
> +
>  Example:
>  	max77693@66 {
>  		compatible = "maxim,max77693";
> @@ -73,4 +129,22 @@ Example:
>  			pwms = <&pwm 0 40000 0>;
>  			pwm-names = "haptic";
>  		};
> +
> +		led_flash: led-flash {

Should both be underscore.  I believe the second portion here should
be more generic "led" for instance.

> +			compatible = "maxim,max77693-flash";
> +			maxim,fleds = <1 0>;
> +			maxim,trigger = <7 0>;
> +			maxim,trigger-type = <0 1>;
> +			maxim,boost-mode = <0>;
> +			maxim,boost-vout = <5000>;
> +			maxim,vsys-min = <2400>;

These will all have to be signed off by a DT maintainer.

> +			camera-flash {
> +				maxim,fled_id = <1>
> +				label = "max77693-flash";
> +				max-microamp = <250000>;
> +				flash-max-microamp = <1000000>;
> +				flash-timeout-microsec = <1000000>;
> +			}

Missing ';'

You should probably test your example code.

> +		};
>  	};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
