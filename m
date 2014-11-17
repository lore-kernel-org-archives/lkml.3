Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKQMXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:23:44 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40414 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaKQMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:23:42 -0500
Date: Mon, 17 Nov 2014 12:23:33 +0000
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
Subject: Re: [RESUBMIT PATCH v7 4/9] devicetree: backlight: Add new SKY81452
 backlight binding
Message-ID: <20141117122333.GQ24004@x1>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416213190-20935-5-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416213190-20935-5-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, gyungoh@gmail.com wrote:

> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
> Changes v7:
> Nothing
> 
> Changes v6:
> Nothing
> 
> Changes v5:
> Nothing
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
>  .../video/backlight/sky81452-backlight.txt         | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> new file mode 100644
> index 0000000..2c2d947
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> @@ -0,0 +1,24 @@
> +SKY81452-backlight bindings
> +
> +Required properties:
> +- compatible		: Must be "skyworks,sky81452-backlight"
> +
> +Optional properties:
> +- name			: Name of backlight device. Default is 'lcd-backlight'.
> +- gpio-enable		: GPIO to use to EN pin.
> +- enable		: Enable mask for current sink channel 1 to 6.
> +- ignore-pwm		: Ignore both PWM input
> +- dpwm-mode		: Enable DPWM dimming mode, otherwise Analog dimming mode
> +- phase-shift		: Enable phase shift mode
> +- ovp-level		: Over-voltage protection level. Should be between 14 or 28V.
> +- short-detection-threshold	: It should be one of 4, 5, 6 and 7V.
> +- boost-current-limit	: It should be one of 800, 1100 and 1500mA.

These are going to need some serious reviewing from the DT guys.  Each
property should either have a vendor prefix or be made generic and
placed in the generic DT documentation for the subsystem.  The name
'enable' is far to generic we don't tend to put masks in DT.  There
is already a generic property for GPIO enable pins.

> +Example:
> +
> +	backlight {
> +		compatible = "skyworks,sky81452-backlight";
> +		name = "pwm-backlight";
> +		enable = <0x3F>;

Lower case.

> +		ignore-pwm;

You should probably demonstrate more of your properties here.

> +	};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
