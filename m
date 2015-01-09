Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbbAIBaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:30:52 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59357 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbAIBau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:30:50 -0500
Date: Fri, 9 Jan 2015 10:30:36 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, jg1.han@samsung.com, cooloney@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        trivial@kernel.org
Cc: akpm@linux-foundation.org, jic23@kernel.org,
        thomas.petazzoni@free-electrons.com, ktsai@capellamicro.com,
        hs@denx.de, stwiss.opensource@diasemi.com, matti.vaittinen@nsn.com,
        broonie@kernel.org, jason@lakedaemon.net, heiko@sntech.de,
        shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch,
        antonynpavlov@gmail.com, hytszk@gmail.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, jack.yoo@skyworksinc.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v10 3/6] devicetree: mfd: Add new SKY81452 mfd binding
Message-ID: <20150109013036.GA2907@jack-ThinkPad-T520>
References: <1420597167-3188-1-git-send-email-jack.yoo@skyworksinc.com>
 <1420597167-3188-4-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420597167-3188-4-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT Ack please.

On Wed, Jan 07, 2015 at 11:19:24AM +0900, gyungoh@gmail.com wrote:
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changes v10:
> Nothing
> 
> Changes v9:
> Nothing
> 
> Changes v8:
> Made up the example for backlight DT
> 
> Changes v7:
> Nothing
> 
> Changes v6:
> Nothing
> 
> Changes v5:
> Changed DT for regulator : 'lout' node should be defined under 'regulator'
> Removed compatible string from sky81452-regulator driver
> 
> Changes v4:
> Nothing
> 
> Changes v3:
> Nothing
> 
> Changes v2:
> Added reg attribute for I2C slave address
> 
>  Documentation/devicetree/bindings/mfd/sky81452.txt | 36 ++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
> new file mode 100644
> index 0000000..ab71473
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
> @@ -0,0 +1,36 @@
> +SKY81452 bindings
> +
> +Required properties:
> +- compatible	: Must be "skyworks,sky81452"
> +- reg		: I2C slave address
> +
> +Required child nodes:
> +- backlight	: container node for backlight following the binding
> +		in video/backlight/sky81452-backlight.txt
> +- regulator	: container node for regulators following the binding
> +		in regulator/sky81452-regulator.txt
> +
> +Example:
> +
> +	sky81452@2c {
> +		compatible = "skyworks,sky81452";
> +		reg = <0x2c>;
> +
> +		backlight {
> +			compatible = "skyworks,sky81452-backlight";
> +			name = "pwm-backlight";
> +			skyworks,en-channels = <0x3f>;
> +			skyworks,ignore-pwm;
> +			skyworks,phase-shift;
> +			skyworks,ovp-level = <20>;
> +			skyworks,current-limit = <2300>;
> +		};
> +
> +		regulator {
> +			lout {
> +				regulator-name = "sky81452-lout";
> +				regulator-min-microvolt = <4500000>;
> +				regulator-max-microvolt = <8000000>;
> +			};
> +		};
> +	};
> -- 
> 1.9.1
> 
