Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaGNKTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:19:37 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:57460 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaGNKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <1403654783-7176-7-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
	<1403654783-7176-7-git-send-email-sboyd@codeaurora.org>
Date: Mon, 14 Jul 2014 15:49:24 +0530
Message-ID: <CAMf-jSnyKmH4ROaEQfMG2BXDiMeSAe9A4kMPBzxs61hLbiYGsw@mail.gmail.com>
Subject: Re: [RFC/PATCH 06/12] clk: qcom: Add MSM8960's HFPLLs
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,



On Wed, Jun 25, 2014 at 5:36 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Describe the HFPLLs present on MSM8960 devices.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clk/qcom/gcc-msm8960.c | 82 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
>
> diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
> index f4ffd91901f8..d04fc99541e4 100644
> --- a/drivers/clk/qcom/gcc-msm8960.c
> +++ b/drivers/clk/qcom/gcc-msm8960.c
> @@ -30,6 +30,7 @@
>  #include "clk-pll.h"
>  #include "clk-rcg.h"
>  #include "clk-branch.h"
> +#include "clk-hfpll.h"
>  #include "reset.h"
>
>  static struct clk_pll pll3 = {
> @@ -75,6 +76,84 @@ static struct clk_regmap pll8_vote = {
>         },
>  };
>
> +static struct hfpll_data hfpll0_data = {
> +       .mode_reg = 0x3200,
> +       .l_reg = 0x3208,
> +       .m_reg = 0x320c,
> +       .n_reg = 0x3210,
> +       .config_reg = 0x3204,
> +       .status_reg = 0x321c,
> +        .config_val = 0x7845c665,
> +        .droop_reg = 0x3214,

Needs tabs at the beginning as indent. Checkpatch fails at above three lines.

> +        .droop_val = 0x0108c000,
> +       .min_rate = 600000000UL,
> +       .max_rate = 1800000000UL,
> +};
> +
> +static struct clk_hfpll hfpll0 = {
> +       .d = &hfpll0_data,
> +       .clkr.hw.init = &(struct clk_init_data){
> +               .parent_names = (const char *[]){ "pxo" },
> +               .num_parents = 1,
> +               .name = "hfpll0",
> +               .ops = &clk_ops_hfpll,
> +               .flags = CLK_IGNORE_UNUSED,
> +       },
> +       .lock = __SPIN_LOCK_UNLOCKED(hfpll0.lock),
> +};
> +
> +static struct hfpll_data hfpll1_data = {
> +       .mode_reg = 0x3300,
> +       .l_reg = 0x3308,
> +       .m_reg = 0x330c,
> +       .n_reg = 0x3310,
> +       .config_reg = 0x3304,
> +       .status_reg = 0x331c,
> +        .config_val = 0x7845c665,
> +        .droop_reg = 0x3314,
> +        .droop_val = 0x0108c000,

Needs tabs and the beginning as indent. Checkpatch fails at above three lines.

> +       .min_rate = 600000000UL,
> +       .max_rate = 1800000000UL,
> +};
> +
> +static struct clk_hfpll hfpll1 = {
> +       .d = &hfpll1_data,
> +       .clkr.hw.init = &(struct clk_init_data){
> +               .parent_names = (const char *[]){ "pxo" },
> +               .num_parents = 1,
> +               .name = "hfpll1",
> +               .ops = &clk_ops_hfpll,
> +               .flags = CLK_IGNORE_UNUSED,
> +       },
> +       .lock = __SPIN_LOCK_UNLOCKED(hfpll1.lock),
> +};
> +
> +static struct hfpll_data hfpll_l2_data = {
> +       .mode_reg = 0x3400,
> +       .l_reg = 0x3408,
> +       .m_reg = 0x340c,
> +       .n_reg = 0x3410,
> +       .config_reg = 0x3404,
> +       .status_reg = 0x341c,
> +        .config_val = 0x7845c665,
> +        .droop_reg = 0x3414,

Same at above three lines.

> +        .droop_val = 0x0108c000,
> +       .min_rate = 600000000UL,
> +       .max_rate = 1800000000UL,
> +};
> +
> +static struct clk_hfpll hfpll_l2 = {
> +       .d = &hfpll_l2_data,
> +       .clkr.hw.init = &(struct clk_init_data){
> +               .parent_names = (const char *[]){ "pxo" },
> +               .num_parents = 1,
> +               .name = "hfpll_l2",
> +               .ops = &clk_ops_hfpll,
> +               .flags = CLK_IGNORE_UNUSED,
> +       },
> +       .lock = __SPIN_LOCK_UNLOCKED(hfpll_l2.lock),
> +};
> +
>  static struct clk_pll pll14 = {
>         .l_reg = 0x31c4,
>         .m_reg = 0x31c8,
> @@ -2763,6 +2842,9 @@ static struct clk_regmap *gcc_msm8960_clks[] = {
>         [PMIC_ARB1_H_CLK] = &pmic_arb1_h_clk.clkr,
>         [PMIC_SSBI2_CLK] = &pmic_ssbi2_clk.clkr,
>         [RPM_MSG_RAM_H_CLK] = &rpm_msg_ram_h_clk.clkr,
> +       [PLL9] = &hfpll0.clkr,
> +       [PLL10] = &hfpll1.clkr,
> +       [PLL12] = &hfpll_l2.clkr,
>  };
>
>  static const struct qcom_reset_map gcc_msm8960_resets[] = {
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
