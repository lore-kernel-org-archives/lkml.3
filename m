Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaJXMET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:04:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24140 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaJXMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:04:17 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-c6-544a403e58e6
Message-id: <544A402F.1010207@samsung.com>
Date: Fri, 24 Oct 2014 14:03:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
 <1414148828-23719-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414148828-23719-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7p2Dl4hBtsnKlpc//Kc1eLPhFY2
	i0n3J7BY9C64ymZxtukNu8XlXXPYLGac38dkMWPySzaLVbv+MDpweuycdZfdo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDJWP13BXHAsqWLa0kusDYwrA7sYOTgkBEwkrq1N7GLkBDLFJC7c
	W88GYgsJLGWU+LYvs4uRC8j+xChxe99iRpAEr4CWxNG5e8GKWARUJdb82sUCYrMJGEr0Hu0D
	qxEViJA4eXcPO0S9oMSPyffAakQENCRm/r3CCDKUWeA6o8SfX/OYQRLCAnESb2+1s0Jsa2SU
	mDlzBRNIglPATeLlw15WkEuZBfQk7l/UAgkzC8hLbF7zlnkCo8AsJDtmIVTNQlK1gJF5FaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZIiH/Zwbj4mNUhRgEORiUe3opkjxAh1sSy4srcQ4wS
	HMxKIrxeJl4hQrwpiZVVqUX58UWlOanFhxiZODilGhhV5irNOyuRcWH6+uUhP98uC+A7/+aF
	weWAwFnc5b/mff4noRt2c3mOoO+ez/djZ187eGBHyGK/S5+WrSw8+UfiWHjC1pZ7psWKy7d0
	vRJivuKvEzPpzAq1yalMBkxm+XznpKvFDm55+qZCN007SIvvJMuD0y/ln1+TmfhfyE1Qhv3I
	7IwYf/ViJZbijERDLeai4kQAs+6yJ08CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 13:07, Chanwoo Choi wrote:
> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
> and function clocks for individual IPs.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Thanks for the update, there are still couple issues pointed out
by checkpatch.pl unfortunately, please see below.
Please fix the errors, I added also some more comments inline below.
In future please put DT binding documentation patch first in the
series, before the actual driver patch.

WARNING: kfree(NULL) is safe this check is probably not required
#252: FILE: drivers/clk/samsung/clk-exynos4415.c:252:
+	if (clk_regs)
+		kfree(clk_regs);

ERROR: space required after that ',' (ctx:VxV)
#423: FILE: drivers/clk/samsung/clk-exynos4415.c:423:
+		0,4),
 		 ^

WARNING: line over 80 characters
#726: FILE: drivers/clk/samsung/clk-exynos4415.c:726:
+		"div_pxlasync_csis0_fimc", GATE_SCLK_CAM, 10, CLK_SET_RATE_PARENT, 0),

WARNING: line over 80 characters
#817: FILE: drivers/clk/samsung/clk-exynos4415.c:817:
+	GATE(CLK_SMMUFIMC_LITE2, "smmufimc_lite2", "div_aclk_160", GATE_IP_CAM, 22,

WARNING: line over 80 characters
#875: FILE: drivers/clk/samsung/clk-exynos4415.c:875:
+	GATE(CLK_USBDEVICE, "usbdevice", "div_aclk_200", GATE_IP_FSYS, 13, 0, 0),

ERROR: space prohibited after that open parenthesis '('
#920: FILE: drivers/clk/samsung/clk-exynos4415.c:920:
+	PLL_35XX_RATE( 960000000, 320, 4,  1),

ERROR: space prohibited after that open parenthesis '('
#921: FILE: drivers/clk/samsung/clk-exynos4415.c:921:
+	PLL_35XX_RATE( 900000000, 300, 4,  1),

ERROR: space prohibited after that open parenthesis '('
#922: FILE: drivers/clk/samsung/clk-exynos4415.c:922:
+	PLL_35XX_RATE( 850000000, 425, 6,  1),

ERROR: space prohibited after that open parenthesis '('
#923: FILE: drivers/clk/samsung/clk-exynos4415.c:923:
+	PLL_35XX_RATE( 800000000, 200, 3,  1),

ERROR: space prohibited after that open parenthesis '('
#924: FILE: drivers/clk/samsung/clk-exynos4415.c:924:
+	PLL_35XX_RATE( 700000000, 175, 3,  1),

ERROR: space prohibited after that open parenthesis '('
#925: FILE: drivers/clk/samsung/clk-exynos4415.c:925:
+	PLL_35XX_RATE( 667000000, 667, 12, 1),

ERROR: space prohibited after that open parenthesis '('
#926: FILE: drivers/clk/samsung/clk-exynos4415.c:926:
+	PLL_35XX_RATE( 600000000, 400, 4,  2),

ERROR: space prohibited after that open parenthesis '('
#927: FILE: drivers/clk/samsung/clk-exynos4415.c:927:
+	PLL_35XX_RATE( 550000000, 275, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#928: FILE: drivers/clk/samsung/clk-exynos4415.c:928:
+	PLL_35XX_RATE( 533000000, 533, 6,  2),

ERROR: space prohibited after that open parenthesis '('
#929: FILE: drivers/clk/samsung/clk-exynos4415.c:929:
+	PLL_35XX_RATE( 520000000, 260, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#930: FILE: drivers/clk/samsung/clk-exynos4415.c:930:
+	PLL_35XX_RATE( 500000000, 250, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#931: FILE: drivers/clk/samsung/clk-exynos4415.c:931:
+	PLL_35XX_RATE( 440000000, 220, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#932: FILE: drivers/clk/samsung/clk-exynos4415.c:932:
+	PLL_35XX_RATE( 400000000, 200, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#933: FILE: drivers/clk/samsung/clk-exynos4415.c:933:
+	PLL_35XX_RATE( 350000000, 175, 3,  2),

ERROR: space prohibited after that open parenthesis '('
#934: FILE: drivers/clk/samsung/clk-exynos4415.c:934:
+	PLL_35XX_RATE( 300000000, 300, 3,  3),
#935: FILE: drivers/clk/samsung/clk-exynos4415.c:935:
+	PLL_35XX_RATE( 266000000, 266, 3,  3),

ERROR: space prohibited after that open parenthesis '('
#936: FILE: drivers/clk/samsung/clk-exynos4415.c:936:
+	PLL_35XX_RATE( 200000000, 200, 3,  3),

ERROR: space prohibited after that open parenthesis '('
#937: FILE: drivers/clk/samsung/clk-exynos4415.c:937:
+	PLL_35XX_RATE( 160000000, 160, 3,  3),

ERROR: space prohibited after that open parenthesis '('
#938: FILE: drivers/clk/samsung/clk-exynos4415.c:938:
+	PLL_35XX_RATE( 100000000, 200, 3,  4),

ERROR: space prohibited after that open parenthesis '('
#948: FILE: drivers/clk/samsung/clk-exynos4415.c:948:
+	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),

ERROR: space prohibited after that open parenthesis '('
#949: FILE: drivers/clk/samsung/clk-exynos4415.c:949:
+	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),

ERROR: space prohibited after that open parenthesis '('
#950: FILE: drivers/clk/samsung/clk-exynos4415.c:950:
+	PLL_36XX_RATE( 80750011, 107, 2, 4, 43691),

ERROR: space prohibited after that open parenthesis '('
#951: FILE: drivers/clk/samsung/clk-exynos4415.c:951:
+	PLL_36XX_RATE( 73728004,  98, 2, 4, 19923),

ERROR: space prohibited after that open parenthesis '('
#952: FILE: drivers/clk/samsung/clk-exynos4415.c:952:
+	PLL_36XX_RATE( 67987602, 271, 3, 5, 62285),

ERROR: space prohibited after that open parenthesis '('
#953: FILE: drivers/clk/samsung/clk-exynos4415.c:953:
+	PLL_36XX_RATE( 65911004, 175, 2, 5, 49982),

ERROR: space prohibited after that open parenthesis '('
#954: FILE: drivers/clk/samsung/clk-exynos4415.c:954:
+	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),

ERROR: space prohibited after that open parenthesis '('
#955: FILE: drivers/clk/samsung/clk-exynos4415.c:955:
+	PLL_36XX_RATE( 49152003, 131, 2, 5,  4719),

ERROR: space prohibited after that open parenthesis '('
#956: FILE: drivers/clk/samsung/clk-exynos4415.c:956:
+	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),

ERROR: space prohibited after that open parenthesis '('
#957: FILE: drivers/clk/samsung/clk-exynos4415.c:957:
+	PLL_36XX_RATE( 45250000, 181, 3, 5,     0),

total: 30 errors, 4 warnings, 1133 lines checked

drivers/clk/samsung/clk-exynos4415.c has style problems, please review.

> ---
>  drivers/clk/samsung/Makefile           |    1 +
>  drivers/clk/samsung/clk-exynos4415.c   | 1133 ++++++++++++++++++++++++++++++++
>  include/dt-bindings/clock/exynos4415.h |  360 ++++++++++
>  3 files changed, 1494 insertions(+)
>  create mode 100644 drivers/clk/samsung/clk-exynos4415.c
>  create mode 100644 include/dt-bindings/clock/exynos4415.h

> diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
> new file mode 100644
> index 0000000..a4b6211
> --- /dev/null
> +++ b/drivers/clk/samsung/clk-exynos4415.c
> @@ -0,0 +1,1133 @@

> +static struct samsung_clk_reg_dump *clk_regs;
> +static struct samsung_clk_provider *ctx;
> +
> +static unsigned long cmu_clk_regs[] __initdata = {

> +};
> +
> +static int exynos_clk_suspend(void)

Please prefix such function (and above variable) names with exynos4415,
as is done for other SoC drivers.

> +{
> +	samsung_clk_save(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
> +
> +	return 0;
> +}
> +
> +static void exynos_clk_resume(void)

exynos4415_clk_resume ?

> +{
> +	samsung_clk_restore(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
> +}
> +
> +static struct syscore_ops exynos_clk_syscore_ops = {

exynos4415_clk_syscore_ops ?

> +	.suspend = exynos_clk_suspend,
> +	.resume = exynos_clk_resume,
> +};
> +
> +static void exynos_clk_sleep_init(void)

exynos4415_clk_sleep_init ?

> +{
> +	clk_regs = samsung_clk_alloc_reg_dump(cmu_clk_regs,
> +						ARRAY_SIZE(cmu_clk_regs));
> +	if (!clk_regs) {
> +		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
> +		goto err;

You could just return here.

> +	}
> +
> +	register_syscore_ops(&exynos_clk_syscore_ops);
> +
> +	return;
> +err:
> +	if (clk_regs)
> +		kfree(clk_regs);

kfree() can be removed (and the condition could never be true anyway).

> +}
> +#else
> +static inline void exynos_clk_sleep_init(void) { }

exynos4415_clk_sleep_init ?

> +#endif

How about prefixing the table names below with "exynos4415", rather than
"samsung" ?

> +static struct samsung_fixed_factor_clock fixed_factor_clks[] __initdata = {

> +};
> +
> +static struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
> +	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
> +};
> +
> +static struct samsung_mux_clock mux_clks[] __initdata = {

> +};
> +
> +static struct samsung_div_clock div_clks[] __initdata = {

> +};
> +
> +static struct samsung_gate_clock gate_clks[] __initdata = {

> +};
> +
> +/*
> + * APLL & MPLL & BPLL & ISP_PLL & DISP_PLL & G3D_PLL
> + */
> +static struct samsung_pll_rate_table exynos4415_pll_rates[] = {
> +	PLL_35XX_RATE(1600000000, 400, 3,  1),
> +	PLL_35XX_RATE(1500000000, 250, 2,  1),
> +	PLL_35XX_RATE(1400000000, 175, 3,  0),
> +	PLL_35XX_RATE(1300000000, 325, 3,  1),
> +	PLL_35XX_RATE(1200000000, 400, 4,  1),
> +	PLL_35XX_RATE(1100000000, 275, 3,  1),
> +	PLL_35XX_RATE(1066000000, 533, 6,  1),
> +	PLL_35XX_RATE(1000000000, 250, 3,  1),
> +	PLL_35XX_RATE( 960000000, 320, 4,  1),
> +	PLL_35XX_RATE( 900000000, 300, 4,  1),
> +	PLL_35XX_RATE( 850000000, 425, 6,  1),
> +	PLL_35XX_RATE( 800000000, 200, 3,  1),
> +	PLL_35XX_RATE( 700000000, 175, 3,  1),
> +	PLL_35XX_RATE( 667000000, 667, 12, 1),
> +	PLL_35XX_RATE( 600000000, 400, 4,  2),
> +	PLL_35XX_RATE( 550000000, 275, 3,  2),
> +	PLL_35XX_RATE( 533000000, 533, 6,  2),
> +	PLL_35XX_RATE( 520000000, 260, 3,  2),
> +	PLL_35XX_RATE( 500000000, 250, 3,  2),
> +	PLL_35XX_RATE( 440000000, 220, 3,  2),
> +	PLL_35XX_RATE( 400000000, 200, 3,  2),
> +	PLL_35XX_RATE( 350000000, 175, 3,  2),
> +	PLL_35XX_RATE( 300000000, 300, 3,  3),
> +	PLL_35XX_RATE( 266000000, 266, 3,  3),
> +	PLL_35XX_RATE( 200000000, 200, 3,  3),
> +	PLL_35XX_RATE( 160000000, 160, 3,  3),
> +	PLL_35XX_RATE( 100000000, 200, 3,  4),
> +	{ /* sentinel */ }
> +};
> +
> +/* EPLL */
> +static struct samsung_pll_rate_table exynos4415_epll_rates[] = {
> +	PLL_36XX_RATE(800000000, 200, 3, 1,     0),
> +	PLL_36XX_RATE(288000000,  96, 2, 2,     0),
> +	PLL_36XX_RATE(192000000, 128, 2, 3,     0),
> +	PLL_36XX_RATE(144000000,  96, 2, 3,     0),
> +	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),
> +	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),
> +	PLL_36XX_RATE( 80750011, 107, 2, 4, 43691),
> +	PLL_36XX_RATE( 73728004,  98, 2, 4, 19923),
> +	PLL_36XX_RATE( 67987602, 271, 3, 5, 62285),
> +	PLL_36XX_RATE( 65911004, 175, 2, 5, 49982),
> +	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),
> +	PLL_36XX_RATE( 49152003, 131, 2, 5,  4719),
> +	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),
> +	PLL_36XX_RATE( 45250000, 181, 3, 5,     0),
> +	{ /* sentinel */ }
> +};
> +
> +static struct samsung_pll_clock plls[nr_plls] __initdata = {

> +};
> +
> +static void __init exynos4415_cmu_init(struct device_node *np)
> +{

> +}
> +CLK_OF_DECLARE(exynos4415_cmu, "samsung,exynos4415-cmu", exynos4415_cmu_init);
> +
> +/*
> + * CMU DMC
> + */
> +

> +#ifdef CONFIG_PM_SLEEP

Similarly for dmc, can we have function, table and below two static
variable names prefixed with exynos4415, like in exynos3250 driver ?

> +static struct samsung_clk_reg_dump *dmc_clk_regs;
> +static struct samsung_clk_provider *dmc_ctx;
> +
> +static unsigned long dmc_save_list[] __initdata = {

> +};
> +
> +static int dmc_clk_suspend(void)
> +{
> +	samsung_clk_save(dmc_ctx->reg_base,
> +				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
> +	return 0;
> +}
> +
> +static void dmc_clk_resume(void)
> +{
> +	samsung_clk_restore(dmc_ctx->reg_base,
> +				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
> +}
> +
> +static struct syscore_ops dmc_clk_syscore_ops = {
> +	.suspend = dmc_clk_suspend,
> +	.resume = dmc_clk_resume,
> +};
> +
> +static void dmc_clk_sleep_init(void)
> +{

> +}
> +#else
> +static inline void dmc_clk_sleep_init(void) { }
> +#endif /* CONFIG_PM_SLEEP */
> +

> +static struct samsung_mux_clock dmc_mux_clks[] __initdata = {

> +};
> +
> +static struct samsung_div_clock dmc_div_clks[] __initdata = {

> +};
> +
> +static struct samsung_pll_clock dmc_plls[nr_dmc_plls] __initdata = {

> +};

--
Thanks,
Sylwester
