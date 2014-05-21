Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaEUWUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:20:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54141 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753376AbaEUWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:20:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+qrzXo6ZhvvvjIuSiLBUKZ
Date: Wed, 21 May 2014 15:19:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 4/4] DTS: ARM: OMAP3-N900: Add tsc2005 support
Message-ID: <20140521221955.GC14520@atomide.com>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
 <1400693774-21306-5-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400693774-21306-5-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [140521 10:38]:
> This adds support for the tsc2005 touchscreen
> to the Nokia N900 DTS file.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Dmitry, if no other comments, feel free to pick this one too.
This does not seem to conflict with anything I have queued:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/boot/dts/omap3-n900.dts | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 1a57b61..cb8ed2d5 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -580,9 +580,24 @@
>  	 * Also... order in the device tree actually matters here.
>  	 */
>  	tsc2005@0 {
> -		compatible = "tsc2005";
> +		compatible = "ti,tsc2005";
>  		spi-max-frequency = <6000000>;
>  		reg = <0>;
> +
> +		vio-supply = <&vio>;
> +
> +		reset-gpios = <&gpio4 8 GPIO_ACTIVE_HIGH>; /* 104 */
> +		interrupts-extended = <&gpio4 4 IRQ_TYPE_EDGE_RISING>; /* 100 */
> +
> +		touchscreen-fuzz-x = <4>;
> +		touchscreen-fuzz-y = <7>;
> +		touchscreen-fuzz-pressure = <2>;
> +		touchscreen-max-x = <4096>;
> +		touchscreen-max-y = <4096>;
> +		touchscreen-max-pressure = <2048>;
> +
> +		ti,x-plate-ohms = <280>;
> +		ti,esd-recovery-timeout-ms = <8000>;
>  	};
>  
>  	acx565akm@2 {
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
