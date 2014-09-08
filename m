Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaIHTdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:33:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47705 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaIHTdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:33:22 -0400
Date: Mon, 8 Sep 2014 14:33:20 -0500
From: Nishanth Menon <nm@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 3/3] arm/dts: dra7xx: Enable CPSW and MDIO for
 dra7xx EVM
Message-ID: <20140908193320.GB12150@kahuna>
References: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
 <1410203998-8700-4-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410203998-8700-4-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:49-20140909, Mugunthan V N wrote:
> Adding CPSW phy-id, CPSW and MDIO pinmux configuration for active and
> sleep states and enable them in board evm dts file.
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
>  arch/arm/boot/dts/dra7-evm.dts | 107 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index fd96ced..57e69c4 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -151,6 +151,87 @@
>  			0xd0	(PIN_OUTPUT | MUX_MODE0)	/* gpmc_be0n_cle */
>  		>;
>  	};
> +
> +	cpsw_default: cpsw_default {
> +		pinctrl-single,pins = <
> +			/* Slave 1 */
> +			0x250 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_tclk */
> +			0x254 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_tctl */
> +			0x258 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td3 */
> +			0x25c (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td2 */
> +			0x260 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td1 */
> +			0x264 (PIN_OUTPUT | MUX_MODE0)	/* rgmii1_td0 */
> +			0x268 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rclk */
> +			0x26c (PIN_INPUT | MUX_MODE0)	/* rgmii1_rctl */
> +			0x270 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd3 */
> +			0x274 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd2 */
> +			0x278 (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd1 */
> +			0x27c (PIN_INPUT | MUX_MODE0)	/* rgmii1_rd0 */
> +
> +			/* Slave 2 */
> +			0x198 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_tclk */
> +			0x19c (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_tctl */
> +			0x1a0 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td3 */
> +			0x1a4 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td2 */
> +			0x1a8 (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td1 */
> +			0x1ac (PIN_OUTPUT | MUX_MODE3)	/* rgmii2_td0 */
> +			0x1b0 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rclk */
> +			0x1b4 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rctl */
> +			0x1b8 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd3 */
> +			0x1bc (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd2 */
> +			0x1c0 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd1 */
> +			0x1c4 (PIN_INPUT | MUX_MODE3)	/* rgmii2_rd0 */
> +		>;
> +
> +	};
> +
> +	cpsw_sleep: cpsw_sleep {
> +		pinctrl-single,pins = <
> +			/* Slave 1 */
> +			0x250 (PIN_OFF_NONE)
> +			0x254 (PIN_OFF_NONE)
> +			0x258 (PIN_OFF_NONE)
> +			0x25c (PIN_OFF_NONE)
> +			0x260 (PIN_OFF_NONE)
> +			0x264 (PIN_OFF_NONE)
> +			0x268 (PIN_OFF_NONE)
> +			0x26c (PIN_OFF_NONE)
> +			0x270 (PIN_OFF_NONE)
> +			0x274 (PIN_OFF_NONE)
> +			0x278 (PIN_OFF_NONE)
> +			0x27c (PIN_OFF_NONE)
> +
> +			/* Slave 1 */
> +			0x198 (PIN_OFF_NONE)
> +			0x19c (PIN_OFF_NONE)
> +			0x1a0 (PIN_OFF_NONE)
> +			0x1a4 (PIN_OFF_NONE)
> +			0x1a8 (PIN_OFF_NONE)
> +			0x1ac (PIN_OFF_NONE)
> +			0x1b0 (PIN_OFF_NONE)
> +			0x1b4 (PIN_OFF_NONE)
> +			0x1b8 (PIN_OFF_NONE)
> +			0x1bc (PIN_OFF_NONE)
> +			0x1c0 (PIN_OFF_NONE)
> +			0x1c4 (PIN_OFF_NONE)
> +		>;
> +	};

NAK to sleep states -> you should be using mode 15 if you really want to
save power.

-- 
Regards,
Nishanth Menon
