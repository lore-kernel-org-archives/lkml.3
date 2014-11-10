Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaKJXh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:37:26 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49001 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433AbaKJXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:37:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JTuFA1V2LQEMAYpZj5B8k
Date: Mon, 10 Nov 2014 15:36:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
Message-ID: <20141110233630.GD31454@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-5-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415051968-4878-5-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [141103 14:01]:
> gta04 board need for tvout enabled 2 bits in devconf1 register (tvbypass and acbias).
> Add single pinmux entry and enable it.
> 
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
> index e4d05f0..a456d37 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> @@ -118,6 +118,17 @@
>  			};
>  		};
>  	};
> +
> +	/* pinmux for devconf1 */
> +	control_devconf1: pinmux@480022d8 {
> +		compatible = "pinctrl-single";
> +		reg = <0x480022d8 4>;	/* single register */
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-single,bit-per-mux;
> +		pinctrl-single,register-width = <32>;
> +		pinctrl-single,function-mask = <0xfc0bd5>;
> +	};
>  };
>  

The pinctrl-single entry should be in omap3.dtsi as the mux register is there
for all the omap3 devices, can you please update the patch for that?

Regards,

Tony

>  &omap3_pmx_core {
> @@ -497,3 +508,14 @@
>  		};
>  	};
>  };
> +
> +&control_devconf1 {
> +	pinctrl-name = "default";
> +	pinctrl-0 = < &tv_acbias_pins>;
> +
> +	tv_acbias_pins: pinmux_tv_acbias_pins {
> +		pinctrl-single,bits = <
> +			0 0x40800 0x40800
> +		>;
> +	};
> +};
> -- 
> 1.9.1
> 
