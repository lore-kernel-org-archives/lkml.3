Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab3LIRqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:46:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62834 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193Ab3LIRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:46:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+D9tl1I7VsujXtKGUv8DQ
Date: Mon, 9 Dec 2013 09:46:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: dt: Document TSC2005 DT binding
Message-ID: <20131209174638.GC12527@atomide.com>
References: <1386284979-9680-1-git-send-email-sre@debian.org>
 <1386284979-9680-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386284979-9680-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131205 15:11]:
> Add devicetree binding documentation for TSC2005 touchscreen.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../bindings/input/touchscreen/tsc2005.txt         | 49 ++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt b/Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt
> new file mode 100644
> index 0000000..4e7df0b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/touchscreen/tsc2005.txt
> @@ -0,0 +1,49 @@
> +* TSC2005 Touchscreen
> +
> +Required properties:
> + - compatible		      : "ti,tsc2005"
> + - reg			      : SPI device address
> + - spi-max-frequency	      : Maximal SPI speed
> + - interrupts		      : IRQ specifier
> + - reset-gpio		      : GPIO specifier
> +
> +Optional properties:
> + - ti,fuzz-x		      : integer, X noise value of the touchscreen
> +				(defaults to 4)
> + - ti,fuzz-y		      : integer, Y noise value of the touchscreen
> +				(defaults to 8)
> + - ti,fuzz-pressure	      : integer, pressure noise value of the touchscreen
> +				(defaults to 2)
> + - ti,max-x		      : integer, maximum reported x value
> +				(defaults to 4096)
> + - ti,max-y		      : integer, maximum reported y value
> +				(defaults to 4096)
> + - ti,max-pressure	      : integer, maximum reported pressure
> +				(defaults to 4096)
> + - ti,x-plate-resistance      : integer, resistance of the touchscreen's X plates
> +				in ohm (defaults to 280)
> + - ti,esd-recovery-timeout-ms : integer, if the touchscreen does not respond after
> +				the configured time (in milli seconds), the driver
> +				will reset it. This is disabled by default.

Instead of adding these optional ti,* properties you can set them in the
driver directly in the of_match table based on the compatible flag. Then
you can pass compatible flag like ti,tsc2005-nokia-n900, or the name of
the LCD panel. Most likely these depend on the LCD panel selected.

Regards,

Tony


> +Example:
> +
> +&mcspi1 {
> +	tsc2005@0 {
> +		compatible = "ti,tsc2005";
> +		spi-max-frequency = <6000000>;
> +		reg = <0>;
> +		reset-gpio = <&gpio4 8 GPIO_ACTIVE_HIGH>; /* 104 */
> +		interrupt-parent = <&gpio4>;
> +		interrupts = <4 IRQ_TYPE_NONE>; /* gpio line 100 */
> +
> +		ti,fuzz-x = <4>;
> +		ti,fuzz-y = <7>;
> +		ti,fuzz-pressure = <2>;
> +		ti,max-x = <4096>;
> +		ti,max-y = <4096>;
> +		ti,max-pressure = <2048>;
> +		ti,x-plate-resistance = <280>;
> +		ti,esd-recovery-timeout-ms = <8000>;
> +	};
> +}
> -- 
> 1.8.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
