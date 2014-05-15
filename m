Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaEOLex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:34:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43213 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaEOLew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:34:52 -0400
Message-ID: <5374A65A.5050408@ti.com>
Date: Thu, 15 May 2014 17:04:50 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: am437x-gp-evm: Add ethernet support for
 GP EVM
References: <1399455053-10324-1-git-send-email-mugunthanvnm@ti.com> <20140513172038.GH16837@atomide.com>
In-Reply-To: <20140513172038.GH16837@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 10:50 PM, Tony Lindgren wrote:
> * Mugunthan V N <mugunthanvnm@ti.com> [140507 02:31]:
>> Add CPSW ethernet support for AM437x GP EVM which has one slave pinned out
>>
>> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
>> ---
>>  arch/arm/boot/dts/am437x-gp-evm.dts | 72 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 72 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
>> index 2e0c636..30ace1b 100644
>> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
>> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
>> @@ -98,6 +98,58 @@
>>  			0x264 (PIN_INPUT_PULLUP | MUX_MODE7)  /* spi2_d0.gpio3_22 */
>>  		>;
>>  	};
>> +
>> +	cpsw_default: cpsw_default {
>> +		pinctrl-single,pins = <
>> +			/* Slave 1 */
>> +			0x114 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txen.rgmii1_txen */
>> +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxdv.rgmii1_rxctl */
>> +			0x11c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd3 */
>> +			0x120 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd2 */
>> +			0x124 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd1.rgmii1_txd1 */
>> +			0x128 (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txd0.rgmii1_txd0 */
>> +			0x12c (PIN_OUTPUT_PULLDOWN | MUX_MODE2)	/* mii1_txclk.rmii1_tclk */
>> +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxclk.rmii1_rclk */
>> +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd3 */
>> +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd2 */
>> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd1.rgmii1_rxd1 */
>> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE2)	/* mii1_rxd0.rgmii1_rxd0 */
>> +		>;
>> +	};
>> +
>> +	cpsw_sleep: cpsw_sleep {
>> +		pinctrl-single,pins = <
>> +			/* Slave 1 reset value */
>> +			0x114 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x118 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x11c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x120 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x124 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x128 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x12c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x130 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x134 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x138 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x13c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x140 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +		>;
>> +	};
> Just a nitpick comment to make things more readable. Can you please add
> the comments for these pins too so people can cross check them against
> the documentation easier?
>
>> +	davinci_mdio_default: davinci_mdio_default {
>> +		pinctrl-single,pins = <
>> +			/* MDIO */
>> +			0x148 (PIN_INPUT_PULLUP | SLEWCTRL_FAST | MUX_MODE0)	/* mdio_data.mdio_data */
>> +			0x14c (PIN_OUTPUT_PULLUP | MUX_MODE0)			/* mdio_clk.mdio_clk */
>> +		>;
>> +	};
>> +
>> +	davinci_mdio_sleep: davinci_mdio_sleep {
>> +		pinctrl-single,pins = <
>> +			/* MDIO reset value */
>> +			0x148 (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>> +		>;
>> +	};
>>  };
> And here too please.
>
>

Will add the comments and post the patch again

Regards
Mugunthan V N
