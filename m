Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbbATOR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:17:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47823 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbATORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:17:23 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-49-54be63710cb3
Message-id: <54BE6368.1080609@samsung.com>
Date: Tue, 20 Jan 2015 15:17:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v4 4/9] clk: samsung: exynos4: Add divider clock id for
 memory bus frequency
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
 <1421286657-4720-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421286657-4720-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7qFyftCDHZ94LF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLJ4
	OuEim8XtxhVsFo9XvGW3aN17hN1i1a4/jA6CHmvmrWH02DnrLrvH4j0vmTw2repk87hzbQ+b
	x+Yl9R59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVcftfM0vBW+mKc0v3sDYwThLvYuTgkBAw
	keh/7dbFyAlkiklcuLeerYuRi0NIYCmjRM+dBjaQhJDAJ0aJqcezQGxeAS2JU0ea2UFsFgFV
	ian3JoPVsAkYSvQe7WMEsUUFIiRO3t3DDlEvKPFj8j0WkF0iAlYSJ9akgcxnFljOLDGhdTcL
	SI2wQJLEngWNTCA1QgL1Eve+eIGYnAKuElvP+oKYzAJ6EvcvaoEUMwvIS2xe85Z5AqPALCTz
	ZyFUzUJStYCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGR93cG49JjVIUYBDkYlHt4T
	zntDhFgTy4orcw8xSnAwK4nwnjXfFyLEm5JYWZValB9fVJqTWnyIkYmDU6qB8fDD5j1hTlfW
	X7RrUtmyKtn0+iz9P0Gza3Qi65c7/0y9uOrPltQrF7e/mVCsoGIZcKql8JWR8rOYmSF/f/et
	+ff165Lv+Rsfutxs9Fy0SWHriaNKu3SZWuee1vJ2iko0T7L3esEbpRfveTT7bsI2VtVtZQ+3
	JZVFXmPVLb/0XGZzVqH/1zwvTyWW4oxEQy3mouJEAIP0vUiKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/15 02:50, Chanwoo Choi wrote:
> This patch adds the divider clock id for Exynos4 memory bus frequency.
> The clock id is used fo DVFS (Dynamic Voltage/Frequency Scaling)
> feature of exynos memory bus frequency.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I've queued this patch for the clk tree, please let me know if a topic
branch is needed.

--
Thanks,
Sylwester

>  drivers/clk/samsung/clk-exynos4.c   | 10 +++++-----
>  include/dt-bindings/clock/exynos4.h |  7 ++++++-
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos4.c
b/drivers/clk/samsung/clk-exynos4.c
> index 88e8c6b..51462e8 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -703,12 +703,12 @@ static struct samsung_mux_clock exynos4x12_mux_clks[]
__initdata = {
>
>  /* list of divider clocks supported in all exynos4 soc's */
>  static struct samsung_div_clock exynos4_div_clks[] __initdata = {
> -	DIV(0, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
> +	DIV(CLK_DIV_GDL, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
>  	DIV(0, "div_gpl", "div_gdl", DIV_LEFTBUS, 4, 3),
>  	DIV(0, "div_clkout_leftbus", "mout_clkout_leftbus",
>  			CLKOUT_CMU_LEFTBUS, 8, 6),
>
> -	DIV(0, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
> +	DIV(CLK_DIV_GDR, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
>  	DIV(0, "div_gpr", "div_gdr", DIV_RIGHTBUS, 4, 3),
>  	DIV(0, "div_clkout_rightbus", "mout_clkout_rightbus",
>  			CLKOUT_CMU_RIGHTBUS, 8, 6),
> @@ -781,10 +781,10 @@ static struct samsung_div_clock exynos4_div_clks[]
__initdata = {
>  			CLK_SET_RATE_PARENT, 0),
>  	DIV(0, "div_clkout_top", "mout_clkout_top", CLKOUT_CMU_TOP, 8, 6),
>
> -	DIV(0, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
> +	DIV(CLK_DIV_ACP, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
>  	DIV(0, "div_acp_pclk", "div_acp", DIV_DMC0, 4, 3),
>  	DIV(0, "div_dphy", "mout_dphy", DIV_DMC0, 8, 3),
> -	DIV(0, "div_dmc", "mout_dmc_bus", DIV_DMC0, 12, 3),
> +	DIV(CLK_DIV_DMC, "div_dmc", "mout_dmc_bus", DIV_DMC0, 12, 3),
>  	DIV(0, "div_dmcd", "div_dmc", DIV_DMC0, 16, 3),
>  	DIV(0, "div_dmcp", "div_dmcd", DIV_DMC0, 20, 3),
>  	DIV(0, "div_pwi", "mout_pwi", DIV_DMC1, 8, 4),
> @@ -829,7 +829,7 @@ static struct samsung_div_clock exynos4x12_div_clks[]
__initdata = {
>  	DIV_F(CLK_DIV_MCUISP1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
>  						8, 3, CLK_GET_RATE_NOCACHE, 0),
>  	DIV(CLK_SCLK_FIMG2D, "sclk_fimg2d", "mout_g2d", DIV_DMC1, 0, 4),
> -	DIV(0, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
> +	DIV(CLK_DIV_C2C, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
>  	DIV(0, "div_c2c_aclk", "div_c2c", DIV_DMC1, 12, 3),
>  };
>
> diff --git a/include/dt-bindings/clock/exynos4.h
b/include/dt-bindings/clock/exynos4.h
> index 34fe28c..c4b1676 100644
> --- a/include/dt-bindings/clock/exynos4.h
> +++ b/include/dt-bindings/clock/exynos4.h
> @@ -262,8 +262,13 @@
>  #define CLK_DIV_MCUISP1		453 /* Exynos4x12 only */
>  #define CLK_DIV_ACLK200		454 /* Exynos4x12 only */
>  #define CLK_DIV_ACLK400_MCUISP	455 /* Exynos4x12 only */
> +#define CLK_DIV_ACP		456
> +#define CLK_DIV_DMC		457
> +#define CLK_DIV_C2C		458 /* Exynos4x12 only */
> +#define CLK_DIV_GDL		459
> +#define CLK_DIV_GDR		460
>
>  /* must be greater than maximal clock id */
> -#define CLK_NR_CLKS		456
> +#define CLK_NR_CLKS		461
>
>  #endif /* _DT_BINDINGS_CLOCK_EXYNOS_4_H */
> -- 1.8.5.5
