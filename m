Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaEMRVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:21:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26089 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaEMRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:20:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/LmNGn0kiZfWOer/jsn4LE
Date: Tue, 13 May 2014 10:20:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dts: am437x-gp-evm: Add ethernet support for GP
 EVM
Message-ID: <20140513172038.GH16837@atomide.com>
References: <1399455053-10324-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399455053-10324-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [140507 02:31]:
> Add CPSW ethernet support for AM437x GP EVM which has one slave pinned out
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts | 72 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
> index 2e0c636..30ace1b 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -98,6 +98,58 @@
>  			0x264 (PIN_INPUT_PULLUP | MUX_MODE7)  /* spi2_d0.gpio3_22 */
>  		>;
>  	};
> +
> +	cpsw_default: cpsw_default {
> +		pinctrl-single,pins = <
> +			/* Slave 1 */
> +			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txen.rgmii1_txen */
> +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxdv.rgmii1_rxctl */
> +			0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd3 */
> +			0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd2 */
> +			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd1 */
> +			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd0 */
> +			0x12c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txclk.rmii1_tclk */
> +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxclk.rmii1_rclk */
> +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd3 */
> +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd2 */
> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd1 */
> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd0 */
> +		>;
> +	};
> +
> +	cpsw_sleep: cpsw_sleep {
> +		pinctrl-single,pins = <
> +			/* Slave 1 reset value */
> +			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +		>;
> +	};

Just a nitpick comment to make things more readable. Can you please add
the comments for these pins too so people can cross check them against
the documentation easier?

> +	davinci_mdio_default: davinci_mdio_default {
> +		pinctrl-single,pins = <
> +			/* MDIO */
> +			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdio_data */
> +			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
> +		>;
> +	};
> +
> +	davinci_mdio_sleep: davinci_mdio_sleep {
> +		pinctrl-single,pins = <
> +			/* MDIO reset value */
> +			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
> +		>;
> +	};
>  };

And here too please.

Thanks,

Tony 
