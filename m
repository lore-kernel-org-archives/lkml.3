Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3EaTZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:25:40 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50298 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3EaTZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:25:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
References: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
Message-ID: <20130531192528.21525.46053@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RESEND] ARM: tegra114: correctly output clk_32k
Date: Fri, 31 May 2013 12:25:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexandre Courbot (2013-05-25 19:56:31)
> Tegra has a blink timer register that allows to modulate the
> clk_32k clock before outputting it. Since clk_32k is presented to the
> kernel as a fixed clock, make sure this register does not tamper with
> the clock frequency and that clk_32k is outputted as-is, similarly to
> what is done on t20 and t30.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>

Taken into clk-next.

Regards,
Mike

> ---
>  drivers/clk/tegra/clk-tegra114.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> index d78e16e..dc76d67 100644
> --- a/drivers/clk/tegra/clk-tegra114.c
> +++ b/drivers/clk/tegra/clk-tegra114.c
> @@ -127,6 +127,7 @@
>  #define PMC_DPD_PADS_ORIDE_BLINK_ENB 20
>  #define PMC_CTRL 0
>  #define PMC_CTRL_BLINK_ENB 7
> +#define PMC_BLINK_TIMER 0x40
>  
>  #define OSC_CTRL                       0x50
>  #define OSC_CTRL_OSC_FREQ_SHIFT                28
> @@ -1625,6 +1626,8 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
>         clks[clk_out_3] = clk;
>  
>         /* blink */
> +       /* clear the blink timer register to directly output clk_32k */
> +       writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
>         clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
>                                 pmc_base + PMC_DPD_PADS_ORIDE,
>                                 PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
> -- 
> 1.8.2.3
