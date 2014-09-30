Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaI3DjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:39:01 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:35881 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3DjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:39:00 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <61534966edc94e47bafa223601d6705a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <542A25D0.1030900@rock-chips.com>
Date: Tue, 30 Sep 2014 11:38:56 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jianqun <jay.xu@rock-chips.com>, mturquette@linaro.org,
        dianders@chromium.org, heiko@sntech.de, dbasehore@chromium.org,
        mark.yao@rock-chips.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: i2s_frac adds flag to set parent's
 rate
References: <1412046724-28069-1-git-send-email-jay.xu@rock-chips.com>
In-Reply-To: <1412046724-28069-1-git-send-email-jay.xu@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

     pls add linux-rockchip@lists.infradead.org next time.

On 09/30/2014 11:12 AM, Jianqun wrote:
> The relation of i2s nodes as follows:
>            i2s_src               0           0            594000000  0
>               i2s_frac           0           0            11289600   0
>                  i2s_pre         0           0            11289600   0
>                     sclk_i2s0    0           0            11289600   0
>                     i2s0_clkout  0           0            11289600   0
>                        hclk_i2s0 1           1            99000000   0
I always got the result as following when I set sclk_i2s0 to 11289600,
any one knows the reason?

       gpll                     6           6            594000000 0
           sclk_emmc             1           1            99000000 0
           i2s_src               0           0            11207548 0
              i2s_pre            0           0            11207548 0
                 sclk_i2s0       0           0            11207548 0
                 i2s0_clkout     0           0            11207548 0
              i2s_frac           0           0            646456897 0
> sclk_i2s0 is the master clock, when to set rate of sclk_i2s0, should
> allow to set its parent's rate, by add flag CLK_SET_RATE_PARENT for
> "i2s_frac", "i2s_pre", "i2s0_clkout" and "sclk_i2s0".
>
> Tested on rk3288 board using max98090, with command "aplay <music.wav>"
>
> Change-Id: I12faad082566532b65a7de8c0a6845e1c17870e6
> Signed-off-by: Jianqun <jay.xu@rock-chips.com>
> ---
>   drivers/clk/rockchip/clk-rk3288.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index c770de0..baf19b4 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -301,15 +301,15 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>   	COMPOSITE(0, "i2s_src", mux_pll_src_cpll_gpll_p, 0,
>   			RK3288_CLKSEL_CON(4), 15, 1, MFLAGS, 0, 7, DFLAGS,
>   			RK3288_CLKGATE_CON(4), 1, GFLAGS),
> -	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", 0,
> +	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", CLK_SET_RATE_PARENT,
>   			RK3288_CLKSEL_CON(8), 0,
>   			RK3288_CLKGATE_CON(4), 2, GFLAGS),
> -	MUX(0, "i2s_pre", mux_i2s_pre_p, 0,
> +	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
>   			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
> -	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
> +	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
>   			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
>   			RK3288_CLKGATE_CON(4), 0, GFLAGS),
> -	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", 0,
> +	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
>   			RK3288_CLKGATE_CON(4), 3, GFLAGS),
>   
>   	MUX(0, "spdif_src", mux_pll_src_cpll_gpll_p, 0,


