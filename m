Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaILJyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:54:18 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47306 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbaILJyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:54:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, dianders@chromium.org, dkl@rock-chips.com,
        eddie.cai@rock-chips.com, xjq@rock-chips.com, kfx@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yxj@rock-chips.com,
        cym@rock-chips.com, zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: fix softreset register count
Date: Fri, 12 Sep 2014 11:56:29 +0200
Message-ID: <2639561.ZlWoeRoRFp@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
References: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Freitag, 12. September 2014, 17:24:46 schrieb Mark yao:
> The rk3288 actually has 12 softresets, so fix the register count.

interesting ... I can see the additional registers in the updated TRM, while 
the old one didn't have them.

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> 
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index 0d8c6c5..2e1d790 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -711,7 +711,7 @@ static void __init rk3288_clk_init(struct device_node
> *np) rockchip_clk_register_branches(rk3288_clk_branches,
>  				  ARRAY_SIZE(rk3288_clk_branches));
> 
> -	rockchip_register_softrst(np, 9, reg_base + RK3288_SOFTRST_CON(0),
> +	rockchip_register_softrst(np, 12, reg_base + RK3288_SOFTRST_CON(0),
>  				  ROCKCHIP_SOFTRST_HIWORD_MASK);
>  }
>  CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);

