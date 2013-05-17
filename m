Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3EQNeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:34:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35284 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3EQNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:34:49 -0400
Date: Fri, 17 May 2013 08:34:18 -0500
From: Nishanth Menon <nm@ti.com>
To: Dan Murphy <dmurphy@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5] ARM:dts:omap4-panda: Update the LED support for the
 panda DTS
Message-ID: <20130517133418.GA5068@kahuna>
References: <1368796883-5501-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1368796883-5501-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:21-20130517, Dan Murphy wrote:
[...]
May be others with better DT experience can help here..
but here is a trick to reduce dts file changes:
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
> index f1d8c21..08d2e38 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -34,3 +34,37 @@
>  		0x5e 0x100	/* hdmi_sda.hdmi_sda INPUT | MODE 0 */
>  		>;
>  };
> +
> +&omap4_pmx_core {
> +	led_gpio_pins: gpio_led_pmx {
> +		pinctrl-single,pins = <
> +			0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
> +		>;
> +	};
> +};
> +
> +&led_wkgpio_pins {
> +	pinctrl-single,pins = <
> +		0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
> +	>;
> +};
> +
> +&leds {
> +	compatible = "gpio-leds";
> +	pinctrl-names = "default";
Normally, override  will either add (if new param) OR replace (if same param)
	So the above two are superfluous.
> +	pinctrl-0 = <
> +		&led_gpio_pins
> +		&led_wkgpio_pins
> +	>;
These are needed
> +
> +	heartbeat {
> +		label = "pandaboard::status1";
can drop this
> +		gpios = <&gpio4 14 0>;
needed
> +		linux,default-trigger = "heartbeat";
can be dropped
> +	};
> +	mmc {
> +		label = "pandaboard::status2";
could be dropped
> +		gpios = <&gpio1 8 0>;
needed
> +		linux,default-trigger = "mmc0";
could be dropped.

-- 
Regards,
Nishanth Menon
