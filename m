Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3E0MtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:49:07 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:38917 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab3E0MtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <1369658492-31358-2-git-send-email-philippe.begnic.st@gmail.com>
References: <1369658492-31358-1-git-send-email-philippe.begnic.st@gmail.com>
	<1369658492-31358-2-git-send-email-philippe.begnic.st@gmail.com>
Date: Mon, 27 May 2013 14:49:03 +0200
Message-ID: <CAPDyKFo1J5Dt-iMtfL=Gf4_5ooTuapDzVBwq9s6zFGY7O4TUfA@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: ux500: Pass clock base adresses in initcall for
 u8540 and u9540
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Philippe Begnic <philippe.begnic.st@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        linux-kernel@vger.kernel.org, olivier.clergeaud@st.com,
        Philippe Begnic <philippe.begnic@st.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2013 14:41, Philippe Begnic <philippe.begnic.st@gmail.com> wrote:
> From: Philippe Begnic <philippe.begnic@st.com>
>
> Align on u8500 version, pass clock base address in clk_init functions
> for u8540 and u9540.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Philippe Begnic <philippe.begnic@st.com>
> ---
>  arch/arm/mach-ux500/cpu.c               |    6 ++++--
>  drivers/clk/ux500/u8540_clk.c           |    4 ++--
>  drivers/clk/ux500/u9540_clk.c           |    4 ++--
>  include/linux/platform_data/clk-ux500.h |    6 ++++--
>  4 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
> index b6145ea..e6fb023 100644
> --- a/arch/arm/mach-ux500/cpu.c
> +++ b/arch/arm/mach-ux500/cpu.c
> @@ -76,13 +76,15 @@ void __init ux500_init_irq(void)
>         } else if (cpu_is_u9540()) {
>                 prcmu_early_init(U8500_PRCMU_BASE, SZ_8K - 1);
>                 ux500_pm_init(U8500_PRCMU_BASE, SZ_8K - 1);
> -               u8500_clk_init(U8500_CLKRST1_BASE, U8500_CLKRST2_BASE,
> +               u9540_clk_init(U8500_CLKRST1_BASE, U8500_CLKRST2_BASE,
>                                U8500_CLKRST3_BASE, U8500_CLKRST5_BASE,
>                                U8500_CLKRST6_BASE);
>         } else if (cpu_is_u8540()) {
>                 prcmu_early_init(U8500_PRCMU_BASE, SZ_8K + SZ_4K - 1);
>                 ux500_pm_init(U8500_PRCMU_BASE, SZ_8K + SZ_4K - 1);
> -               u8540_clk_init();
> +               u8540_clk_init(U8500_CLKRST1_BASE, U8500_CLKRST2_BASE,
> +                              U8500_CLKRST3_BASE, U8500_CLKRST5_BASE,
> +                              U8500_CLKRST6_BASE);
>         }
>  }
>
> diff --git a/drivers/clk/ux500/u8540_clk.c b/drivers/clk/ux500/u8540_clk.c
> index 10adfd2..90f3c88 100644
> --- a/drivers/clk/ux500/u8540_clk.c
> +++ b/drivers/clk/ux500/u8540_clk.c
> @@ -12,10 +12,10 @@
>  #include <linux/clk-provider.h>
>  #include <linux/mfd/dbx500-prcmu.h>
>  #include <linux/platform_data/clk-ux500.h>
> -
>  #include "clk.h"
>
> -void u8540_clk_init(void)
> +void u8540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> +                   u32 clkrst5_base, u32 clkrst6_base)
>  {
>         /* register clocks here */
>  }
> diff --git a/drivers/clk/ux500/u9540_clk.c b/drivers/clk/ux500/u9540_clk.c
> index dbc0191..4479478 100644
> --- a/drivers/clk/ux500/u9540_clk.c
> +++ b/drivers/clk/ux500/u9540_clk.c
> @@ -12,10 +12,10 @@
>  #include <linux/clk-provider.h>
>  #include <linux/mfd/dbx500-prcmu.h>
>  #include <linux/platform_data/clk-ux500.h>
> -
>  #include "clk.h"
>
> -void u9540_clk_init(void)
> +void u9540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> +                   u32 clkrst5_base, u32 clkrst6_base)
>  {
>         /* register clocks here */
>  }
> diff --git a/include/linux/platform_data/clk-ux500.h b/include/linux/platform_data/clk-ux500.h
> index 320d9c3..9d98f3a 100644
> --- a/include/linux/platform_data/clk-ux500.h
> +++ b/include/linux/platform_data/clk-ux500.h
> @@ -12,7 +12,9 @@
>
>  void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>                     u32 clkrst5_base, u32 clkrst6_base);
> -void u9540_clk_init(void);
> -void u8540_clk_init(void);
> +void u9540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> +                   u32 clkrst5_base, u32 clkrst6_base);
> +void u8540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> +                   u32 clkrst5_base, u32 clkrst6_base);
>
>  #endif /* __CLK_UX500_H */
> --
> 1.7.9.5
>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
