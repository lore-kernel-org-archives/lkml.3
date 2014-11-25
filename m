Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaKYJkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:40:16 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:44049 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYJkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:40:13 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: eddie.cai@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <4ab1b45e70f10766d14cb42f3eaf6c96>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54744E6F.9060901@rock-chips.com>
Date: Tue, 25 Nov 2014 17:39:59 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Chen <roger.chen@rock-chips.com>, heiko@sntech.de
CC: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        mark.yao@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH 2/4] GMAC: modify CRU config for Rockchip RK3288 SoCs
 integrated GMAC
References: <1416906512-26120-1-git-send-email-roger.chen@rock-chips.com>
In-Reply-To: <1416906512-26120-1-git-send-email-roger.chen@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Roger,

This  patch should be split into two patch, one for clock ID definition,
one for mac related clocks update.

The Subject for clk-rk3288.c should use below prefix:
clk: rockchip: modify clock for mac ...

On 11/25/2014 05:08 PM, Roger Chen wrote:
> modify CRU config for GMAC driver
Could you detail the reason for this patch in commit message?
> Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> ---
>   drivers/clk/rockchip/clk-rk3288.c      |   14 +++++++-------
>   include/dt-bindings/clock/rk3288-cru.h |    4 ++++
>   2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 2327829..60237dc 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -187,7 +187,7 @@ PNAME(mux_uart2_p)	= { "uart2_src", "uart2_frac", "xin24m" };
>   PNAME(mux_uart3_p)	= { "uart3_src", "uart3_frac", "xin24m" };
>   PNAME(mux_uart4_p)	= { "uart4_src", "uart4_frac", "xin24m" };
>   PNAME(mux_cif_out_p)	= { "cif_src", "xin24m" };
> -PNAME(mux_macref_p)	= { "mac_src", "ext_gmac" };
> +PNAME(mux_mac_p)	= { "mac_pll_src", "ext_gmac" };
>   PNAME(mux_hsadcout_p)	= { "hsadc_src", "ext_hsadc" };
>   PNAME(mux_edp_24m_p)	= { "ext_edp_24m", "xin24m" };
>   PNAME(mux_tspout_p)	= { "cpll", "gpll", "npll", "xin27m" };
> @@ -560,18 +560,18 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>   	MUX(SCLK_UART4, "sclk_uart4", mux_uart4_p, 0,
>   			RK3288_CLKSEL_CON(3), 8, 2, MFLAGS),
>   
> -	COMPOSITE(0, "mac_src", mux_pll_src_npll_cpll_gpll_p, 0,
> +	COMPOSITE(SCLK_MAC_PLL, "mac_pll_src", mux_pll_src_npll_cpll_gpll_p, 0,
>   			RK3288_CLKSEL_CON(21), 0, 2, MFLAGS, 8, 5, DFLAGS,
>   			RK3288_CLKGATE_CON(2), 5, GFLAGS),
> -	MUX(0, "macref", mux_macref_p, 0,
> +	MUX(SCLK_MAC, "mac_clk", mux_mac_p, 0,
>   			RK3288_CLKSEL_CON(21), 4, 1, MFLAGS),
> -	GATE(0, "sclk_macref_out", "macref", 0,
> +	GATE(SCLK_MACREF_OUT, "sclk_macref_out", "mac_clk", 0,
>   			RK3288_CLKGATE_CON(5), 3, GFLAGS),
> -	GATE(SCLK_MACREF, "sclk_macref", "macref", 0,
> +	GATE(SCLK_MACREF, "sclk_macref", "mac_clk", 0,
>   			RK3288_CLKGATE_CON(5), 2, GFLAGS),
> -	GATE(SCLK_MAC_RX, "sclk_mac_rx", "macref", 0,
> +	GATE(SCLK_MAC_RX, "sclk_mac_rx", "mac_clk", 0,
>   			RK3288_CLKGATE_CON(5), 0, GFLAGS),
> -	GATE(SCLK_MAC_TX, "sclk_mac_tx", "macref", 0,
> +	GATE(SCLK_MAC_TX, "sclk_mac_tx", "mac_clk", 0,
>   			RK3288_CLKGATE_CON(5), 1, GFLAGS),
>   
>   	COMPOSITE(0, "hsadc_src", mux_pll_src_cpll_gpll_p, 0,
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
> index 100a08c..f9496f5 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -72,6 +72,10 @@
>   #define SCLK_HEVC_CABAC		111
>   #define SCLK_HEVC_CORE		112
>   
> +#define SCLK_MAC_PLL		150
> +#define SCLK_MAC		151
> +#define SCLK_MACREF_OUT		152
> +
>   #define DCLK_VOP0		190
>   #define DCLK_VOP1		191
>   

