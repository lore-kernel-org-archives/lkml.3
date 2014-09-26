Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaIZIrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:47:10 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:46151 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaIZIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <1411662520-22795-9-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-9-git-send-email-geert+renesas@glider.be>
Date: Fri, 26 Sep 2014 10:47:05 +0200
Message-ID: <CAPDyKFoizgHPZmcDA4KNUtj-Cncc2AydNo1aULihHca+zXJwUA@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] ARM: shmobile: R-Mobile: Store SYSC base address
 in rmobile_pm_domain
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 18:28, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Replace the hardcoded addresses for accessing the SYSC PM domain
> registers by register offsets, relative to the SYSC base address stored
> in struct rmobile_pm_domain.
>
> In the future, the SYSC base address will come from DT.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
> v3:
>   - No changes
> v2:
>   - No changes
>
>  arch/arm/mach-shmobile/pm-r8a7740.c | 14 ++++++++++++++
>  arch/arm/mach-shmobile/pm-rmobile.c | 24 +++++++++++++-----------
>  arch/arm/mach-shmobile/pm-rmobile.h |  1 +
>  arch/arm/mach-shmobile/pm-sh7372.c  | 11 +++++++++++
>  4 files changed, 39 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-shmobile/pm-r8a7740.c b/arch/arm/mach-shmobile/pm-r8a7740.c
> index 41e61f1b5d44f00d..f92e64fd91de5631 100644
> --- a/arch/arm/mach-shmobile/pm-r8a7740.c
> +++ b/arch/arm/mach-shmobile/pm-r8a7740.c
> @@ -9,10 +9,14 @@
>   * for more details.
>   */
>  #include <linux/console.h>
> +#include <linux/io.h>
>  #include <linux/suspend.h>
> +
>  #include "common.h"
>  #include "pm-rmobile.h"
>
> +#define SYSC_BASE      IOMEM(0xe6180000)
> +
>  #if defined(CONFIG_PM) && !defined(CONFIG_ARCH_MULTIPLATFORM)
>  static int r8a7740_pd_a3sm_suspend(void)
>  {
> @@ -35,39 +39,49 @@ static int r8a7740_pd_a3sp_suspend(void)
>  static struct rmobile_pm_domain r8a7740_pm_domains[] = {
>         {
>                 .genpd.name     = "A4LC",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 1,
>         }, {
>                 .genpd.name     = "A4MP",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 2,
>         }, {
>                 .genpd.name     = "D4",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 3,
>         }, {
>                 .genpd.name     = "A4R",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 5,
>         }, {
>                 .genpd.name     = "A3RV",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 6,
>         }, {
>                 .genpd.name     = "A4S",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 10,
>                 .no_debug       = true,
>         }, {
>                 .genpd.name     = "A3SP",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 11,
>                 .gov            = &pm_domain_always_on_gov,
>                 .no_debug       = true,
>                 .suspend        = r8a7740_pd_a3sp_suspend,
>         }, {
>                 .genpd.name     = "A3SM",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 12,
>                 .gov            = &pm_domain_always_on_gov,
>                 .suspend        = r8a7740_pd_a3sm_suspend,
>         }, {
>                 .genpd.name     = "A3SG",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 13,
>         }, {
>                 .genpd.name     = "A4SU",
> +               .base           = SYSC_BASE,
>                 .bit_shift      = 20,
>         },
>  };
> diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
> index ae846dfcd69293f7..8b876fcf7d0fc2ba 100644
> --- a/arch/arm/mach-shmobile/pm-rmobile.c
> +++ b/arch/arm/mach-shmobile/pm-rmobile.c
> @@ -20,9 +20,9 @@
>  #include "pm-rmobile.h"
>
>  /* SYSC */
> -#define SPDCR          IOMEM(0xe6180008)
> -#define SWUCR          IOMEM(0xe6180014)
> -#define PSTR           IOMEM(0xe6180080)
> +#define SPDCR  0x08    /* SYS Power Down Control Register */
> +#define SWUCR  0x14    /* SYS Wakeup Control Register */
> +#define PSTR   0x80    /* Power Status Register */
>
>  #define PSTR_RETRIES   100
>  #define PSTR_DELAY_US  10
> @@ -39,12 +39,12 @@ static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
>                         return ret;
>         }
>
> -       if (__raw_readl(PSTR) & mask) {
> +       if (__raw_readl(rmobile_pd->base + PSTR) & mask) {
>                 unsigned int retry_count;
> -               __raw_writel(mask, SPDCR);
> +               __raw_writel(mask, rmobile_pd->base + SPDCR);
>
>                 for (retry_count = PSTR_RETRIES; retry_count; retry_count--) {
> -                       if (!(__raw_readl(SPDCR) & mask))
> +                       if (!(__raw_readl(rmobile_pd->base + SPDCR) & mask))
>                                 break;
>                         cpu_relax();
>                 }
> @@ -52,7 +52,8 @@ static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
>
>         if (!rmobile_pd->no_debug)
>                 pr_debug("%s: Power off, 0x%08x -> PSTR = 0x%08x\n",
> -                        genpd->name, mask, __raw_readl(PSTR));
> +                        genpd->name, mask,
> +                        __raw_readl(rmobile_pd->base + PSTR));
>
>         return 0;
>  }
> @@ -64,13 +65,13 @@ static int __rmobile_pd_power_up(struct rmobile_pm_domain *rmobile_pd,
>         unsigned int retry_count;
>         int ret = 0;
>
> -       if (__raw_readl(PSTR) & mask)
> +       if (__raw_readl(rmobile_pd->base + PSTR) & mask)
>                 goto out;
>
> -       __raw_writel(mask, SWUCR);
> +       __raw_writel(mask, rmobile_pd->base + SWUCR);
>
>         for (retry_count = 2 * PSTR_RETRIES; retry_count; retry_count--) {
> -               if (!(__raw_readl(SWUCR) & mask))
> +               if (!(__raw_readl(rmobile_pd->base + SWUCR) & mask))
>                         break;
>                 if (retry_count > PSTR_RETRIES)
>                         udelay(PSTR_DELAY_US);
> @@ -82,7 +83,8 @@ static int __rmobile_pd_power_up(struct rmobile_pm_domain *rmobile_pd,
>
>         if (!rmobile_pd->no_debug)
>                 pr_debug("%s: Power on, 0x%08x -> PSTR = 0x%08x\n",
> -                        rmobile_pd->genpd.name, mask, __raw_readl(PSTR));
> +                        rmobile_pd->genpd.name, mask,
> +                        __raw_readl(rmobile_pd->base + PSTR));
>
>  out:
>         if (ret == 0 && rmobile_pd->resume && do_resume)
> diff --git a/arch/arm/mach-shmobile/pm-rmobile.h b/arch/arm/mach-shmobile/pm-rmobile.h
> index 8f66b343162b0411..0602130bb260c31d 100644
> --- a/arch/arm/mach-shmobile/pm-rmobile.h
> +++ b/arch/arm/mach-shmobile/pm-rmobile.h
> @@ -21,6 +21,7 @@ struct rmobile_pm_domain {
>         struct dev_power_governor *gov;
>         int (*suspend)(void);
>         void (*resume)(void);
> +       void __iomem *base;
>         unsigned int bit_shift;
>         bool no_debug;
>  };
> diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
> index 7e5c2676c48902f1..7181a280b3b541af 100644
> --- a/arch/arm/mach-shmobile/pm-sh7372.c
> +++ b/arch/arm/mach-shmobile/pm-sh7372.c
> @@ -45,6 +45,8 @@
>  #define PLLC01STPCR IOMEM(0xe61500c8)
>
>  /* SYSC */
> +#define SYSC_BASE IOMEM(0xe6180000)
> +
>  #define SBAR IOMEM(0xe6180020)
>  #define WUPRMSK IOMEM(0xe6180028)
>  #define WUPSMSK IOMEM(0xe618002c)
> @@ -118,24 +120,28 @@ static struct rmobile_pm_domain sh7372_pm_domains[] = {
>                 .genpd.name = "A4LC",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 1,
>         },
>         {
>                 .genpd.name = "A4MP",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 2,
>         },
>         {
>                 .genpd.name = "D4",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 3,
>         },
>         {
>                 .genpd.name = "A4R",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 5,
>                 .suspend = sh7372_a4r_pd_suspend,
>                 .resume = sh7372_intcs_resume,
> @@ -144,18 +150,21 @@ static struct rmobile_pm_domain sh7372_pm_domains[] = {
>                 .genpd.name = "A3RV",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 6,
>         },
>         {
>                 .genpd.name = "A3RI",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 8,
>         },
>         {
>                 .genpd.name = "A4S",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 10,
>                 .gov = &pm_domain_always_on_gov,
>                 .no_debug = true,
> @@ -166,6 +175,7 @@ static struct rmobile_pm_domain sh7372_pm_domains[] = {
>                 .genpd.name = "A3SP",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 11,
>                 .gov = &pm_domain_always_on_gov,
>                 .no_debug = true,
> @@ -175,6 +185,7 @@ static struct rmobile_pm_domain sh7372_pm_domains[] = {
>                 .genpd.name = "A3SG",
>                 .genpd.power_on_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
>                 .genpd.power_off_latency_ns = PM_DOMAIN_ON_OFF_LATENCY_NS,
> +               .base = SYSC_BASE,
>                 .bit_shift = 13,
>         },
>  };
> --
> 1.9.1
>
