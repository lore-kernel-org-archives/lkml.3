Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3BRLUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:20:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3BRLUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:20:46 -0500
Message-ID: <51220E78.5000409@ti.com>
Date: Mon, 18 Feb 2013 12:20:24 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anil Kumar <anilk4.v@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <thomas@tomweber.eu>
Subject: Re: [PATCH V2] ARM: dts: omap3-devkit8000: Enable audio support
References: <1361000036-18121-1-git-send-email-anilk4.v@gmail.com>
In-Reply-To: <1361000036-18121-1-git-send-email-anilk4.v@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 08:33 AM, Anil Kumar wrote:
> Add the needed sections to enable audio support on
> Devkit8000 when booted with DT blob.
> 
> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>

Looks good:
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
> This patch is based on top of kernel 3.8-rc5 and
> the following patches.
> 
> Peter Ujfalusi:-
> ASoC: twl4030: Correct the support for Voice port
> ASoC: twl4030: Convert MICBIAS to SUPPLY widget
> ASoC: omap-twl4030: Add support for routing, voice port and jack detect
> 
> Anil Kumar:-
> ARM: dts: add minimal DT support for DevKit8000
> https://patchwork.kernel.org/patch/2122461/
> 
> -Tested for playback and capture on Devkit8000.
> 
>  Test process:-
> 
>  #amixer set 'PredriveR Mixer AudioR2' on
>  #amixer set 'PredriveL Mixer AudioL2' on
>  #amixer set PreDriv 100 unmute
>  #amixer set 'DAC2 Digital Fine' 100
>  #amixer cset numid=27 1
>  #arecord | aplay
> 
> For V2:
>  - Remove pin mux as done at device boot time by default.
> 
> :100644 100644 6338993... c70116f... M	arch/arm/boot/dts/omap3-devkit8000.dts
>  arch/arm/boot/dts/omap3-devkit8000.dts |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
> index 6338993..c70116f 100644
> --- a/arch/arm/boot/dts/omap3-devkit8000.dts
> +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
> @@ -42,6 +42,19 @@
>                  };
>  
>  	};
> +
> +	sound {
> +		compatible = "ti,omap-twl4030";
> +		ti,model = "devkit8000";
> +
> +		ti,mcbsp = <&mcbsp2>;
> +		ti,codec = <&twl_audio>;
> +		ti,audio-routing =
> +			"Ext Spk", "PREDRIVEL",
> +			"Ext Spk", "PREDRIVER",
> +			"MAINMIC", "Main Mic",
> +			"Main Mic", "Mic Bias 1";
> +	};
>  };
>  
>  &i2c1 {
> @@ -51,6 +64,12 @@
>  		reg = <0x48>;
>  		interrupts = <7>;	/* SYS_NIRQ cascaded to intc */
>  		interrupt-parent = <&intc>;
> +
> +		twl_audio: audio {
> +			compatible = "ti,twl4030-audio";
> +			codec {
> +			};
> +		};
>  	};
>  };
>  
> @@ -86,10 +105,6 @@
>  	status = "disabled";
>  };
>  
> -&mcbsp2 {
> -	status = "disabled";
> -};
> -
>  &mcbsp3 {
>  	status = "disabled";
>  };
> 


-- 
Péter
