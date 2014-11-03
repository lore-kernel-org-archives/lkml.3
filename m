Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaKCRGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:06:46 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48526 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaKCRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:06:44 -0500
Date: Mon, 3 Nov 2014 17:06:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, jg1.han@samsung.com, cooloney@gmail.com,
        broonie@kernel.org, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 3/8] devicetree: mfd: Add new SKY81452 mfd
 binding
Message-ID: <20141103170635.GE12011@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-4-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414739322-12487-4-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, gyungoh@gmail.com wrote:

> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
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
>  Documentation/devicetree/bindings/mfd/sky81452.txt | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt

For my own information:

  Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
> new file mode 100644
> index 0000000..4b82a73
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
> @@ -0,0 +1,33 @@
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
> +			enable = <0x3F>;
> +			ignore-pwm;
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

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
