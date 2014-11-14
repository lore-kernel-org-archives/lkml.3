Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161685AbaKNSEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:04:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38806 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161175AbaKNSEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:04:20 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+oEFoVDoxZgMK7MCo4H7sT
Date: Fri, 14 Nov 2014 10:03:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        richardcochran@gmail.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/6] ARM: dts: AM335x: Make charge delay a DT
 parameter for TSC
Message-ID: <20141114180328.GU31250@atomide.com>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-5-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415941651-28962-5-git-send-email-vigneshr@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vignesh R <vigneshr@ti.com> [141113 21:42]:
> The charge delay value is by default 0x400. But it can be set to lower
> values on some boards, as long as false pen-ups are avoided. Lowering the
> value increases the sampling rate (though current sampling rate is
> sufficient for TSC operation). In some boards, the value has to be
> increased to avoid false pen-up events. Hence, charge delay has been
> made a DT parameter.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>

As long as the input and DT people are OK with this, ack for
merging the .dts changes along with the input patches:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
> 
> v4:
>  - Set charge delay to 0x400 as default. Most devices function normally
>    at this value
> 
>  .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt  | 15 +++++++++++++++
>  arch/arm/boot/dts/am335x-evm.dts                          |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> index 878549ba814d..6df5028a4ad3 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> +++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> @@ -28,6 +28,20 @@ Required properties:
>  	ti,adc-channels: List of analog inputs available for ADC.
>  			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
>  
> +Optional properties:
> +- child "tsc"
> +	ti,charge-delay: Length of touch screen charge delay step in terms of
> +			 ADC clock cycles. Charge delay value should be large
> +			 in order to avoid false pen-up events. This value
> +			 affects the overall sampling speed, hence need to be
> +			 kept as low as possible, while avoiding false pen-up
> +			 event. Start from a lower value, say 0x400, and
> +			 increase value until false pen-up events are avoided.
> +			 The pen-up detection happens immediately after the
> +			 charge step, so this does in fact function as a
> +			 hardware knob for adjusting the amount of "settling
> +			 time".
> +
>  Example:
>  	tscadc: tscadc@44e0d000 {
>  		compatible = "ti,am3359-tscadc";
> @@ -36,6 +50,7 @@ Example:
>  			ti,x-plate-resistance = <200>;
>  			ti,coordiante-readouts = <5>;
>  			ti,wire-config = <0x00 0x11 0x22 0x33>;
> +			ti,charge-delay = <0x400>;
>  		};
>  
>  		adc {
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index e2156a583de7..ce12f6ef1e28 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -641,6 +641,7 @@
>  		ti,x-plate-resistance = <200>;
>  		ti,coordinate-readouts = <5>;
>  		ti,wire-config = <0x00 0x11 0x22 0x33>;
> +		ti,charge-delay = <0x400>;
>  	};
>  
>  	adc {
> -- 
> 1.9.1
> 
