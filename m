Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbaJaVKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:10:39 -0400
Received: from mout.gmx.net ([212.227.17.22]:61665 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaJaVKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:10:36 -0400
Message-ID: <5453FA8E.3080204@gmx.de>
Date: Fri, 31 Oct 2014 22:09:34 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: Vignesh R <vigneshr@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] arm: boot: dts: am335x-evm: Make charge delay
 a DT parameter for tsc
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <1414408111-2631-4-git-send-email-vigneshr@ti.com>
In-Reply-To: <1414408111-2631-4-git-send-email-vigneshr@ti.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Y4iSrN3E0ry35zOPwmre6X/QdxKni6CrtjJkdOLSjZu5s4CkSv0
 u6XtVIYGBNRAmI66gv9XSqsErm96wrc3i2380r2zUfKYD57IDWzdSSpdYej/4Zo3UHJ3dNj
 veI+SD7waKIo3H2lgrHdyX2tRllZueMMA1YUr2vUtC4BRtwrXefok6X9mDGaN6b0q4xJ82F
 UGxWe3fgLHyPoiaZ2s3rg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vignesh R schrieb am 27.10.2014 12:08:
> The charge delay value is by default 0xB000. But it can be set to lower
> values on some boards as long as false pen-ups are avoided. Lowering the
> value increases the sampling rate (though current sampling rate is
> sufficient for tsc operation). Hence charge delay has been made a DT
> parameter.
> 
I would recommend to use a few colons to separate some thoughts. Also, limit to 80 chars per line would be beneficial. See inline.
> Signed-off-by: Vignesh R <vigneshr@ti.com>
> ---
>  .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt    | 13 +++++++++++++
>  arch/arm/boot/dts/am335x-evm.dts                            |  1 +
>  2 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> index 878549ba814d..ac62769e70e4 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> +++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> @@ -28,6 +28,18 @@ Required properties:
>  	ti,adc-channels: List of analog inputs available for ADC.
>  			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
>  
> +Optional properties:
> +- child "tsc"
> +	ti,charge-delay: Length of touch screen charge delay step in terms of
> +			 ADC clock cycles. Charge delay value should be large in order
> +			 to avoid false pen-up events. This value affects the overall
> +			 sampling speed hence need to be kept as low as possible while
<...> speed, hence needs to be <...>
> +			 avoiding false pen-up event. Start from a lower value say 0x400
<...> pen-up events. Start from a lower value, like 0x400, and increase <...>
> +			 and increase value until false pen-up events are avoided. The
> +			 pen-up detection happens immediately after the charge step
<...> charge step, so this <...>
> +			 so this does in fact function as a hardware knob for adjusting
> +			 the amount of "settling time".
> +
>  Example:
>  	tscadc: tscadc@44e0d000 {
>  		compatible = "ti,am3359-tscadc";
> @@ -36,6 +48,7 @@ Example:
>  			ti,x-plate-resistance = <200>;
>  			ti,coordiante-readouts = <5>;
>  			ti,wire-config = <0x00 0x11 0x22 0x33>;
> +			ti,charge-delay = <0xB000>;
>  		};
>  
>  		adc {
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index e2156a583de7..80be0462298b 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -641,6 +641,7 @@
>  		ti,x-plate-resistance = <200>;
>  		ti,coordinate-readouts = <5>;
>  		ti,wire-config = <0x00 0x11 0x22 0x33>;
> +		ti,charge-delay = <0xB000>;
>  	};
>  
>  	adc {
> 

