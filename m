Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3GQPc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:32:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35471 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932285Ab3GQPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:32:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/p0laj5z6HjXzGsqiWNcYM
Date: Wed, 17 Jul 2013 08:32:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3/3] ARM: dts: omap4-sdp: add dynamic pin states for
 uart3/4
Message-ID: <20130717153248.GI7656@atomide.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
 <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
> Add dynamic "active"/"idle" pin states for uart3/4 which will be applied
> when uart3/4 state is switched from active to idle and back by Runtime
> PM or during system suspend.

This is good for testing code, but should not be merged because
omap4 has the iopad wake-ups available for uarts. So those can
be always enabled.
 
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -181,18 +181,40 @@
>  		pinctrl-single,pins = <
>  			0x100 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart3_cts_rctx.uart3_cts_rctx */
>  			0x102 (PIN_OUTPUT | MUX_MODE0)		/* uart3_rts_sd.uart3_rts_sd */
> -			0x104 (PIN_INPUT | MUX_MODE0)		/* uart3_rx_irrx.uart3_rx_irrx */
>  			0x106 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx_irtx.uart3_tx_irtx */
>  		>;
>  	};

This just need to become:
		pinctrl-single,pins = <
			...
			0x104 (WAKEUP_EN | PIN_INPUT_MUX_MODE0)	/* uart3_rx_irrx.uart3_rx_irrx */
			...
		>;
		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
	};

And so on. For am33xx you need to remux things to GPIO for the wake-up
events, so you should maybe test on that instead.

Regards,

Tony
