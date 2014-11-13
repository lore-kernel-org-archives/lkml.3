Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaKMO4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:56:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57584 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaKMO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:56:10 -0500
Date: Thu, 13 Nov 2014 14:56:09 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "nsekhar@ti.com" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: Invert CPUIDLE_FLAG_TIME_VALID logic
Message-ID: <20141113145609.GA9726@red-moon>
References: <1415804630-5055-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415804630-5055-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 03:03:50PM +0000, Daniel Lezcano wrote:
> The only place where the time is invalid is when the ACPI_CSTATE_FFH entry
> method is not set. Otherwise for all the drivers, the time can be correctly
> measured.
> 
> Instead of duplicating the CPUIDLE_FLAG_TIME_VALID flag in all the drivers
> for all the states, just invert the logic by replacing it by the flag
> CPUIDLE_FLAG_TIME_INVALID, hence we can set this flag only for the acpi idle
> driver, remove the former flag from all the drivers and invert the logic with
> this flag in the different governor.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Are we sure that ACPI C1 invalid residency time is *still* an issue after
we moved the residency accounting to the idle core ?

I have a feeling you can remove this flag entirely, but I will let x86
guys speak for themselves.

Other than that, it makes sense to me:

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

> ---
>  arch/arm/include/asm/cpuidle.h         |   1 -
>  arch/arm/mach-davinci/cpuidle.c        |   1 -
>  arch/arm/mach-imx/cpuidle-imx5.c       |   1 -
>  arch/arm/mach-imx/cpuidle-imx6q.c      |   3 +-
>  arch/arm/mach-imx/cpuidle-imx6sl.c     |   3 +-
>  arch/arm/mach-omap2/cpuidle34xx.c      |   7 ---
>  arch/arm/mach-omap2/cpuidle44xx.c      |   5 +-
>  arch/arm/mach-s3c64xx/cpuidle.c        |   1 -
>  arch/arm/mach-shmobile/pm-sh7372.c     |   4 --
>  arch/arm/mach-tegra/cpuidle-tegra114.c |   1 -
>  arch/arm/mach-tegra/cpuidle-tegra20.c  |   3 +-
>  arch/arm/mach-tegra/cpuidle-tegra30.c  |   1 -
>  arch/mips/include/asm/idle.h           |   1 -
>  arch/sh/kernel/cpu/shmobile/cpuidle.c  |   3 -
>  arch/x86/kernel/apm_32.c               |   1 -
>  drivers/acpi/processor_idle.c          |   6 +-
>  drivers/cpuidle/cpuidle-arm64.c        |   1 -
>  drivers/cpuidle/cpuidle-at91.c         |   1 -
>  drivers/cpuidle/cpuidle-big_little.c   |   6 +-
>  drivers/cpuidle/cpuidle-calxeda.c      |   1 -
>  drivers/cpuidle/cpuidle-cps.c          |   7 +--
>  drivers/cpuidle/cpuidle-exynos.c       |   1 -
>  drivers/cpuidle/cpuidle-kirkwood.c     |   1 -
>  drivers/cpuidle/cpuidle-mvebu-v7.c     |   8 +--
>  drivers/cpuidle/cpuidle-powernv.c      |   6 +-
>  drivers/cpuidle/cpuidle-pseries.c      |   3 -
>  drivers/cpuidle/cpuidle-ux500.c        |   3 +-
>  drivers/cpuidle/cpuidle-zynq.c         |   1 -
>  drivers/cpuidle/driver.c               |   1 -
>  drivers/cpuidle/dt_idle_states.c       |   2 +-
>  drivers/cpuidle/governors/ladder.c     |   2 +-
>  drivers/cpuidle/governors/menu.c       |   2 +-
>  drivers/idle/intel_idle.c              | 108 ++++++++++++++++-----------------
>  include/linux/cpuidle.h                |   4 +-
>  34 files changed, 75 insertions(+), 125 deletions(-)
> 
> diff --git a/arch/arm/include/asm/cpuidle.h b/arch/arm/include/asm/cpuidle.h
> index 2fca60a..af319ac 100644
> --- a/arch/arm/include/asm/cpuidle.h
> +++ b/arch/arm/include/asm/cpuidle.h
> @@ -15,7 +15,6 @@ static inline int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
>         .exit_latency           = 1,\
>         .target_residency       = 1,\
>         .power_usage            = p,\
> -       .flags                  = CPUIDLE_FLAG_TIME_VALID,\
>         .name                   = "WFI",\
>         .desc                   = "ARM WFI",\
>  }
> diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
> index f1ac1c9..b4675fc 100644
> --- a/arch/arm/mach-davinci/cpuidle.c
> +++ b/arch/arm/mach-davinci/cpuidle.c
> @@ -66,7 +66,6 @@ static struct cpuidle_driver davinci_idle_driver = {
>                 .enter                  = davinci_enter_idle,
>                 .exit_latency           = 10,
>                 .target_residency       = 10000,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "DDR SR",
>                 .desc                   = "WFI and DDR Self Refresh",
>         },
> diff --git a/arch/arm/mach-imx/cpuidle-imx5.c b/arch/arm/mach-imx/cpuidle-imx5.c
> index 5a47e3c..3feca52 100644
> --- a/arch/arm/mach-imx/cpuidle-imx5.c
> +++ b/arch/arm/mach-imx/cpuidle-imx5.c
> @@ -24,7 +24,6 @@ static struct cpuidle_driver imx5_cpuidle_driver = {
>                 .enter            = imx5_cpuidle_enter,
>                 .exit_latency     = 2,
>                 .target_residency = 1,
> -               .flags            = CPUIDLE_FLAG_TIME_VALID,
>                 .name             = "IMX5 SRPG",
>                 .desc             = "CPU state retained,powered off",
>         },
> diff --git a/arch/arm/mach-imx/cpuidle-imx6q.c b/arch/arm/mach-imx/cpuidle-imx6q.c
> index aa93578..d76d086 100644
> --- a/arch/arm/mach-imx/cpuidle-imx6q.c
> +++ b/arch/arm/mach-imx/cpuidle-imx6q.c
> @@ -53,8 +53,7 @@ static struct cpuidle_driver imx6q_cpuidle_driver = {
>                 {
>                         .exit_latency = 50,
>                         .target_residency = 75,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID |
> -                                CPUIDLE_FLAG_TIMER_STOP,
> +                       .flags = CPUIDLE_FLAG_TIMER_STOP,
>                         .enter = imx6q_enter_wait,
>                         .name = "WAIT",
>                         .desc = "Clock off",
> diff --git a/arch/arm/mach-imx/cpuidle-imx6sl.c b/arch/arm/mach-imx/cpuidle-imx6sl.c
> index d4b6b81..7d92e65 100644
> --- a/arch/arm/mach-imx/cpuidle-imx6sl.c
> +++ b/arch/arm/mach-imx/cpuidle-imx6sl.c
> @@ -40,8 +40,7 @@ static struct cpuidle_driver imx6sl_cpuidle_driver = {
>                 {
>                         .exit_latency = 50,
>                         .target_residency = 75,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID |
> -                               CPUIDLE_FLAG_TIMER_STOP,
> +                       .flags = CPUIDLE_FLAG_TIMER_STOP,
>                         .enter = imx6sl_enter_wait,
>                         .name = "WAIT",
>                         .desc = "Clock off",
> diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
> index e18709d..aa7b379 100644
> --- a/arch/arm/mach-omap2/cpuidle34xx.c
> +++ b/arch/arm/mach-omap2/cpuidle34xx.c
> @@ -265,7 +265,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 2 + 2,
>                         .target_residency = 5,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C1",
>                         .desc             = "MPU ON + CORE ON",
>                 },
> @@ -273,7 +272,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 10 + 10,
>                         .target_residency = 30,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C2",
>                         .desc             = "MPU ON + CORE ON",
>                 },
> @@ -281,7 +279,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 50 + 50,
>                         .target_residency = 300,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C3",
>                         .desc             = "MPU RET + CORE ON",
>                 },
> @@ -289,7 +286,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 1500 + 1800,
>                         .target_residency = 4000,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C4",
>                         .desc             = "MPU OFF + CORE ON",
>                 },
> @@ -297,7 +293,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 2500 + 7500,
>                         .target_residency = 12000,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C5",
>                         .desc             = "MPU RET + CORE RET",
>                 },
> @@ -305,7 +300,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 3000 + 8500,
>                         .target_residency = 15000,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C6",
>                         .desc             = "MPU OFF + CORE RET",
>                 },
> @@ -313,7 +307,6 @@ static struct cpuidle_driver omap3_idle_driver = {
>                         .enter            = omap3_enter_idle_bm,
>                         .exit_latency     = 10000 + 30000,
>                         .target_residency = 30000,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "C7",
>                         .desc             = "MPU OFF + CORE OFF",
>                 },
> diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
> index 2498ab0..01e398a 100644
> --- a/arch/arm/mach-omap2/cpuidle44xx.c
> +++ b/arch/arm/mach-omap2/cpuidle44xx.c
> @@ -196,7 +196,6 @@ static struct cpuidle_driver omap4_idle_driver = {
>                         /* C1 - CPU0 ON + CPU1 ON + MPU ON */
>                         .exit_latency = 2 + 2,
>                         .target_residency = 5,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .enter = omap_enter_idle_simple,
>                         .name = "C1",
>                         .desc = "CPUx ON, MPUSS ON"
> @@ -205,7 +204,7 @@ static struct cpuidle_driver omap4_idle_driver = {
>                         /* C2 - CPU0 OFF + CPU1 OFF + MPU CSWR */
>                         .exit_latency = 328 + 440,
>                         .target_residency = 960,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED,
> +                       .flags = CPUIDLE_FLAG_COUPLED,
>                         .enter = omap_enter_idle_coupled,
>                         .name = "C2",
>                         .desc = "CPUx OFF, MPUSS CSWR",
> @@ -214,7 +213,7 @@ static struct cpuidle_driver omap4_idle_driver = {
>                         /* C3 - CPU0 OFF + CPU1 OFF + MPU OSWR */
>                         .exit_latency = 460 + 518,
>                         .target_residency = 1100,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_COUPLED,
> +                       .flags = CPUIDLE_FLAG_COUPLED,
>                         .enter = omap_enter_idle_coupled,
>                         .name = "C3",
>                         .desc = "CPUx OFF, MPUSS OSWR",
> diff --git a/arch/arm/mach-s3c64xx/cpuidle.c b/arch/arm/mach-s3c64xx/cpuidle.c
> index 3c8ab07..2eb0724 100644
> --- a/arch/arm/mach-s3c64xx/cpuidle.c
> +++ b/arch/arm/mach-s3c64xx/cpuidle.c
> @@ -48,7 +48,6 @@ static struct cpuidle_driver s3c64xx_cpuidle_driver = {
>                         .enter            = s3c64xx_enter_idle,
>                         .exit_latency     = 1,
>                         .target_residency = 1,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID,
>                         .name             = "IDLE",
>                         .desc             = "System active, ARM gated",
>                 },
> diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
> index 7e5c267..0e37da6 100644
> --- a/arch/arm/mach-shmobile/pm-sh7372.c
> +++ b/arch/arm/mach-shmobile/pm-sh7372.c
> @@ -423,7 +423,6 @@ static struct cpuidle_driver sh7372_cpuidle_driver = {
>                 .desc = "Core Standby Mode",
>                 .exit_latency = 10,
>                 .target_residency = 20 + 10,
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .enter = sh7372_enter_core_standby,
>         },
>         .states[2] = {
> @@ -431,7 +430,6 @@ static struct cpuidle_driver sh7372_cpuidle_driver = {
>                 .desc = "A3SM PLL ON",
>                 .exit_latency = 20,
>                 .target_residency = 30 + 20,
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .enter = sh7372_enter_a3sm_pll_on,
>         },
>         .states[3] = {
> @@ -439,7 +437,6 @@ static struct cpuidle_driver sh7372_cpuidle_driver = {
>                 .desc = "A3SM PLL OFF",
>                 .exit_latency = 120,
>                 .target_residency = 30 + 120,
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .enter = sh7372_enter_a3sm_pll_off,
>         },
>         .states[4] = {
> @@ -447,7 +444,6 @@ static struct cpuidle_driver sh7372_cpuidle_driver = {
>                 .desc = "A4S PLL OFF",
>                 .exit_latency = 240,
>                 .target_residency = 30 + 240,
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .enter = sh7372_enter_a4s,
>                 .disabled = true,
>         },
> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
> index e3ebdce..b309082 100644
> --- a/arch/arm/mach-tegra/cpuidle-tegra114.c
> +++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
> @@ -75,7 +75,6 @@ static struct cpuidle_driver tegra_idle_driver = {
>                         .exit_latency           = 500,
>                         .target_residency       = 1000,
>                         .power_usage            = 0,
> -                       .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                         .name                   = "powered-down",
>                         .desc                   = "CPU power gated",
>                 },
> diff --git a/arch/arm/mach-tegra/cpuidle-tegra20.c b/arch/arm/mach-tegra/cpuidle-tegra20.c
> index b30bf5c..4f25a7c 100644
> --- a/arch/arm/mach-tegra/cpuidle-tegra20.c
> +++ b/arch/arm/mach-tegra/cpuidle-tegra20.c
> @@ -59,8 +59,7 @@ static struct cpuidle_driver tegra_idle_driver = {
>                         .exit_latency     = 5000,
>                         .target_residency = 10000,
>                         .power_usage      = 0,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID |
> -                       CPUIDLE_FLAG_COUPLED,
> +                       .flags            = CPUIDLE_FLAG_COUPLED,
>                         .name             = "powered-down",
>                         .desc             = "CPU power gated",
>                 },
> diff --git a/arch/arm/mach-tegra/cpuidle-tegra30.c b/arch/arm/mach-tegra/cpuidle-tegra30.c
> index 3556127..f8815ed 100644
> --- a/arch/arm/mach-tegra/cpuidle-tegra30.c
> +++ b/arch/arm/mach-tegra/cpuidle-tegra30.c
> @@ -56,7 +56,6 @@ static struct cpuidle_driver tegra_idle_driver = {
>                         .exit_latency           = 2000,
>                         .target_residency       = 2200,
>                         .power_usage            = 0,
> -                       .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                         .name                   = "powered-down",
>                         .desc                   = "CPU power gated",
>                 },
> diff --git a/arch/mips/include/asm/idle.h b/arch/mips/include/asm/idle.h
> index 1c967ab..a2d18ab 100644
> --- a/arch/mips/include/asm/idle.h
> +++ b/arch/mips/include/asm/idle.h
> @@ -22,7 +22,6 @@ extern int mips_cpuidle_wait_enter(struct cpuidle_device *dev,
>         .exit_latency           = 1,\
>         .target_residency       = 1,\
>         .power_usage            = UINT_MAX,\
> -       .flags                  = CPUIDLE_FLAG_TIME_VALID,\
>         .name                   = "wait",\
>         .desc                   = "MIPS wait",\
>  }
> diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
> index e3abfd4..53b8eeb 100644
> --- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
> +++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
> @@ -59,7 +59,6 @@ static struct cpuidle_driver cpuidle_driver = {
>                         .exit_latency = 1,
>                         .target_residency = 1 * 2,
>                         .power_usage = 3,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .enter = cpuidle_sleep_enter,
>                         .name = "C1",
>                         .desc = "SuperH Sleep Mode",
> @@ -68,7 +67,6 @@ static struct cpuidle_driver cpuidle_driver = {
>                         .exit_latency = 100,
>                         .target_residency = 1 * 2,
>                         .power_usage = 1,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .enter = cpuidle_sleep_enter,
>                         .name = "C2",
>                         .desc = "SuperH Sleep Mode [SF]",
> @@ -78,7 +76,6 @@ static struct cpuidle_driver cpuidle_driver = {
>                         .exit_latency = 2300,
>                         .target_residency = 1 * 2,
>                         .power_usage = 1,
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .enter = cpuidle_sleep_enter,
>                         .name = "C3",
>                         .desc = "SuperH Mobile Standby Mode [SF]",
> diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
> index 5848744..927ec92 100644
> --- a/arch/x86/kernel/apm_32.c
> +++ b/arch/x86/kernel/apm_32.c
> @@ -378,7 +378,6 @@ static struct cpuidle_driver apm_idle_driver = {
>                 { /* entry 1 is for APM idle */
>                         .name = "APM",
>                         .desc = "APM idle",
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .exit_latency = 250,    /* WAG */
>                         .target_residency = 500,        /* WAG */
>                         .enter = &apm_cpu_idle
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 17f9ec5..380b4b4 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -985,8 +985,8 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
>                 state->flags = 0;
>                 switch (cx->type) {
>                         case ACPI_STATE_C1:
> -                       if (cx->entry_method == ACPI_CSTATE_FFH)
> -                               state->flags |= CPUIDLE_FLAG_TIME_VALID;
> +                       if (cx->entry_method != ACPI_CSTATE_FFH)
> +                               state->flags |= CPUIDLE_FLAG_TIME_INVALID;
> 
>                         state->enter = acpi_idle_enter_c1;
>                         state->enter_dead = acpi_idle_play_dead;
> @@ -994,14 +994,12 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
>                         break;
> 
>                         case ACPI_STATE_C2:
> -                       state->flags |= CPUIDLE_FLAG_TIME_VALID;
>                         state->enter = acpi_idle_enter_simple;
>                         state->enter_dead = acpi_idle_play_dead;
>                         drv->safe_state_index = count;
>                         break;
> 
>                         case ACPI_STATE_C3:
> -                       state->flags |= CPUIDLE_FLAG_TIME_VALID;
>                         state->enter = pr->flags.bm_check ?
>                                         acpi_idle_enter_bm :
>                                         acpi_idle_enter_simple;
> diff --git a/drivers/cpuidle/cpuidle-arm64.c b/drivers/cpuidle/cpuidle-arm64.c
> index 50997ea..87320e6 100644
> --- a/drivers/cpuidle/cpuidle-arm64.c
> +++ b/drivers/cpuidle/cpuidle-arm64.c
> @@ -73,7 +73,6 @@ static struct cpuidle_driver arm64_idle_driver = {
>                 .exit_latency           = 1,
>                 .target_residency       = 1,
>                 .power_usage            = UINT_MAX,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "WFI",
>                 .desc                   = "ARM64 WFI",
>         }
> diff --git a/drivers/cpuidle/cpuidle-at91.c b/drivers/cpuidle/cpuidle-at91.c
> index a077437..1964ff0 100644
> --- a/drivers/cpuidle/cpuidle-at91.c
> +++ b/drivers/cpuidle/cpuidle-at91.c
> @@ -43,7 +43,6 @@ static struct cpuidle_driver at91_idle_driver = {
>                 .enter                  = at91_enter_idle,
>                 .exit_latency           = 10,
>                 .target_residency       = 10000,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "RAM_SR",
>                 .desc                   = "WFI and DDR Self Refresh",
>         },
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index fbc00a1..e3e225f 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -67,8 +67,7 @@ static struct cpuidle_driver bl_idle_little_driver = {
>                 .enter                  = bl_enter_powerdown,
>                 .exit_latency           = 700,
>                 .target_residency       = 2500,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID |
> -                                         CPUIDLE_FLAG_TIMER_STOP,
> +               .flags                  = CPUIDLE_FLAG_TIMER_STOP,
>                 .name                   = "C1",
>                 .desc                   = "ARM little-cluster power down",
>         },
> @@ -89,8 +88,7 @@ static struct cpuidle_driver bl_idle_big_driver = {
>                 .enter                  = bl_enter_powerdown,
>                 .exit_latency           = 500,
>                 .target_residency       = 2000,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID |
> -                                         CPUIDLE_FLAG_TIMER_STOP,
> +               .flags                  = CPUIDLE_FLAG_TIMER_STOP,
>                 .name                   = "C1",
>                 .desc                   = "ARM big-cluster power down",
>         },
> diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
> index 6e51114..6541b0b 100644
> --- a/drivers/cpuidle/cpuidle-calxeda.c
> +++ b/drivers/cpuidle/cpuidle-calxeda.c
> @@ -55,7 +55,6 @@ static struct cpuidle_driver calxeda_idle_driver = {
>                 {
>                         .name = "PG",
>                         .desc = "Power Gate",
> -                       .flags = CPUIDLE_FLAG_TIME_VALID,
>                         .exit_latency = 30,
>                         .power_usage = 50,
>                         .target_residency = 200,
> diff --git a/drivers/cpuidle/cpuidle-cps.c b/drivers/cpuidle/cpuidle-cps.c
> index fc7b627..1adb698 100644
> --- a/drivers/cpuidle/cpuidle-cps.c
> +++ b/drivers/cpuidle/cpuidle-cps.c
> @@ -79,7 +79,6 @@ static struct cpuidle_driver cps_driver = {
>                         .enter  = cps_nc_enter,
>                         .exit_latency           = 200,
>                         .target_residency       = 450,
> -                       .flags  = CPUIDLE_FLAG_TIME_VALID,
>                         .name   = "nc-wait",
>                         .desc   = "non-coherent MIPS wait",
>                 },
> @@ -87,8 +86,7 @@ static struct cpuidle_driver cps_driver = {
>                         .enter  = cps_nc_enter,
>                         .exit_latency           = 300,
>                         .target_residency       = 700,
> -                       .flags  = CPUIDLE_FLAG_TIME_VALID |
> -                                 CPUIDLE_FLAG_TIMER_STOP,
> +                       .flags  = CPUIDLE_FLAG_TIMER_STOP,
>                         .name   = "clock-gated",
>                         .desc   = "core clock gated",
>                 },
> @@ -96,8 +94,7 @@ static struct cpuidle_driver cps_driver = {
>                         .enter  = cps_nc_enter,
>                         .exit_latency           = 600,
>                         .target_residency       = 1000,
> -                       .flags  = CPUIDLE_FLAG_TIME_VALID |
> -                                 CPUIDLE_FLAG_TIMER_STOP,
> +                       .flags  = CPUIDLE_FLAG_TIMER_STOP,
>                         .name   = "power-gated",
>                         .desc   = "core power gated",
>                 },
> diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
> index ba9b34b..64d12a8 100644
> --- a/drivers/cpuidle/cpuidle-exynos.c
> +++ b/drivers/cpuidle/cpuidle-exynos.c
> @@ -47,7 +47,6 @@ static struct cpuidle_driver exynos_idle_driver = {
>                         .enter                  = exynos_enter_lowpower,
>                         .exit_latency           = 300,
>                         .target_residency       = 100000,
> -                       .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                         .name                   = "C1",
>                         .desc                   = "ARM power down",
>                 },
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 41ba843..d88f8d7 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -47,7 +47,6 @@ static struct cpuidle_driver kirkwood_idle_driver = {
>                 .enter                  = kirkwood_enter_idle,
>                 .exit_latency           = 10,
>                 .target_residency       = 100000,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "DDR SR",
>                 .desc                   = "WFI and DDR Self Refresh",
>         },
> diff --git a/drivers/cpuidle/cpuidle-mvebu-v7.c b/drivers/cpuidle/cpuidle-mvebu-v7.c
> index 45371bb..dd4c176 100644
> --- a/drivers/cpuidle/cpuidle-mvebu-v7.c
> +++ b/drivers/cpuidle/cpuidle-mvebu-v7.c
> @@ -53,7 +53,6 @@ static struct cpuidle_driver armadaxp_idle_driver = {
>                 .exit_latency           = 10,
>                 .power_usage            = 50,
>                 .target_residency       = 100,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "MV CPU IDLE",
>                 .desc                   = "CPU power down",
>         },
> @@ -62,8 +61,7 @@ static struct cpuidle_driver armadaxp_idle_driver = {
>                 .exit_latency           = 100,
>                 .power_usage            = 5,
>                 .target_residency       = 1000,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID |
> -                                               MVEBU_V7_FLAG_DEEP_IDLE,
> +               .flags                  = MVEBU_V7_FLAG_DEEP_IDLE,
>                 .name                   = "MV CPU DEEP IDLE",
>                 .desc                   = "CPU and L2 Fabric power down",
>         },
> @@ -78,8 +76,7 @@ static struct cpuidle_driver armada370_idle_driver = {
>                 .exit_latency           = 100,
>                 .power_usage            = 5,
>                 .target_residency       = 1000,
> -               .flags                  = (CPUIDLE_FLAG_TIME_VALID |
> -                                          MVEBU_V7_FLAG_DEEP_IDLE),
> +               .flags                  = MVEBU_V7_FLAG_DEEP_IDLE,
>                 .name                   = "Deep Idle",
>                 .desc                   = "CPU and L2 Fabric power down",
>         },
> @@ -94,7 +91,6 @@ static struct cpuidle_driver armada38x_idle_driver = {
>                 .exit_latency           = 10,
>                 .power_usage            = 5,
>                 .target_residency       = 100,
> -               .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                 .name                   = "Idle",
>                 .desc                   = "CPU and SCU power down",
>         },
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index 7d3a349..e9248bb 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -93,7 +93,6 @@ static struct cpuidle_state powernv_states[MAX_POWERNV_IDLE_STATES] = {
>         { /* Snooze */
>                 .name = "snooze",
>                 .desc = "snooze",
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .exit_latency = 0,
>                 .target_residency = 0,
>                 .enter = &snooze_loop },
> @@ -202,7 +201,7 @@ static int powernv_add_idle_states(void)
>                         /* Add NAP state */
>                         strcpy(powernv_states[nr_idle_states].name, "Nap");
>                         strcpy(powernv_states[nr_idle_states].desc, "Nap");
> -                       powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIME_VALID;
> +                       powernv_states[nr_idle_states].flags = 0;
>                         powernv_states[nr_idle_states].exit_latency =
>                                         ((unsigned int)latency_ns) / 1000;
>                         powernv_states[nr_idle_states].target_residency =
> @@ -215,8 +214,7 @@ static int powernv_add_idle_states(void)
>                         /* Add FASTSLEEP state */
>                         strcpy(powernv_states[nr_idle_states].name, "FastSleep");
>                         strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
> -                       powernv_states[nr_idle_states].flags =
> -                               CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TIMER_STOP;
> +                       powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIMER_STOP;
>                         powernv_states[nr_idle_states].exit_latency =
>                                         ((unsigned int)latency_ns) / 1000;
>                         powernv_states[nr_idle_states].target_residency =
> diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
> index 6f7b019..bb9e2b6 100644
> --- a/drivers/cpuidle/cpuidle-pseries.c
> +++ b/drivers/cpuidle/cpuidle-pseries.c
> @@ -142,14 +142,12 @@ static struct cpuidle_state dedicated_states[] = {
>         { /* Snooze */
>                 .name = "snooze",
>                 .desc = "snooze",
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .exit_latency = 0,
>                 .target_residency = 0,
>                 .enter = &snooze_loop },
>         { /* CEDE */
>                 .name = "CEDE",
>                 .desc = "CEDE",
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .exit_latency = 10,
>                 .target_residency = 100,
>                 .enter = &dedicated_cede_loop },
> @@ -162,7 +160,6 @@ static struct cpuidle_state shared_states[] = {
>         { /* Shared Cede */
>                 .name = "Shared Cede",
>                 .desc = "Shared Cede",
> -               .flags = CPUIDLE_FLAG_TIME_VALID,
>                 .exit_latency = 0,
>                 .target_residency = 0,
>                 .enter = &shared_cede_loop },
> diff --git a/drivers/cpuidle/cpuidle-ux500.c b/drivers/cpuidle/cpuidle-ux500.c
> index 5e35804..292e65a 100644
> --- a/drivers/cpuidle/cpuidle-ux500.c
> +++ b/drivers/cpuidle/cpuidle-ux500.c
> @@ -101,8 +101,7 @@ static struct cpuidle_driver ux500_idle_driver = {
>                         .enter            = ux500_enter_idle,
>                         .exit_latency     = 70,
>                         .target_residency = 260,
> -                       .flags            = CPUIDLE_FLAG_TIME_VALID |
> -                                           CPUIDLE_FLAG_TIMER_STOP,
> +                       .flags            = CPUIDLE_FLAG_TIMER_STOP,
>                         .name             = "ApIdle",
>                         .desc             = "ARM Retention",
>                 },
> diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
> index c61b8b2..022dec8 100644
> --- a/drivers/cpuidle/cpuidle-zynq.c
> +++ b/drivers/cpuidle/cpuidle-zynq.c
> @@ -52,7 +52,6 @@ static struct cpuidle_driver zynq_idle_driver = {
>                         .enter                  = zynq_enter_idle,
>                         .exit_latency           = 10,
>                         .target_residency       = 10000,
> -                       .flags                  = CPUIDLE_FLAG_TIME_VALID,
>                         .name                   = "RAM_SR",
>                         .desc                   = "WFI and RAM Self Refresh",
>                 },
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index e431d11..2697e87 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -201,7 +201,6 @@ static void poll_idle_init(struct cpuidle_driver *drv)
>         state->exit_latency = 0;
>         state->target_residency = 0;
>         state->power_usage = -1;
> -       state->flags = CPUIDLE_FLAG_TIME_VALID;
>         state->enter = poll_idle;
>         state->disabled = false;
>  }
> diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
> index 52f4d11..6e6f0b2 100644
> --- a/drivers/cpuidle/dt_idle_states.c
> +++ b/drivers/cpuidle/dt_idle_states.c
> @@ -73,7 +73,7 @@ static int init_state_node(struct cpuidle_state *idle_state,
>                 return -EINVAL;
>         }
> 
> -       idle_state->flags = CPUIDLE_FLAG_TIME_VALID;
> +       idle_state->flags = 0;
>         if (of_property_read_bool(state_node, "local-timer-stop"))
>                 idle_state->flags |= CPUIDLE_FLAG_TIMER_STOP;
>         /*
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index 06b57c4..37263d9 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -79,7 +79,7 @@ static int ladder_select_state(struct cpuidle_driver *drv,
> 
>         last_state = &ldev->states[last_idx];
> 
> -       if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
> +       if (!(drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_INVALID)) {
>                 last_residency = cpuidle_get_last_residency(dev) - \
>                                          drv->states[last_idx].exit_latency;
>         }
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 710a233..659d7b0 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -405,7 +405,7 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>          * the measured amount of time is less than the exit latency,
>          * assume the state was never reached and the exit latency is 0.
>          */
> -       if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID))) {
> +       if (unlikely(target->flags & CPUIDLE_FLAG_TIME_INVALID)) {
>                 /* Use timer value as is */
>                 measured_us = data->next_timer_us;
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 9b7ee7e..9cceacb 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -128,28 +128,28 @@ static struct cpuidle_state nehalem_cstates[] = {
>         {
>                 .name = "C1-NHM",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 3,
>                 .target_residency = 6,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-NHM",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-NHM",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 20,
>                 .target_residency = 80,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-NHM",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 200,
>                 .target_residency = 800,
>                 .enter = &intel_idle },
> @@ -161,35 +161,35 @@ static struct cpuidle_state snb_cstates[] = {
>         {
>                 .name = "C1-SNB",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 2,
>                 .target_residency = 2,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-SNB",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-SNB",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 80,
>                 .target_residency = 211,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-SNB",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 104,
>                 .target_residency = 345,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7-SNB",
>                 .desc = "MWAIT 0x30",
> -               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 109,
>                 .target_residency = 345,
>                 .enter = &intel_idle },
> @@ -201,42 +201,42 @@ static struct cpuidle_state byt_cstates[] = {
>         {
>                 .name = "C1-BYT",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 1,
>                 .target_residency = 1,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-BYT",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 15,
>                 .target_residency = 30,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6N-BYT",
>                 .desc = "MWAIT 0x58",
> -               .flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 40,
>                 .target_residency = 275,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6S-BYT",
>                 .desc = "MWAIT 0x52",
> -               .flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 140,
>                 .target_residency = 560,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7-BYT",
>                 .desc = "MWAIT 0x60",
> -               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 1200,
>                 .target_residency = 1500,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7S-BYT",
>                 .desc = "MWAIT 0x64",
> -               .flags = MWAIT2flg(0x64) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x64) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 10000,
>                 .target_residency = 20000,
>                 .enter = &intel_idle },
> @@ -248,35 +248,35 @@ static struct cpuidle_state ivb_cstates[] = {
>         {
>                 .name = "C1-IVB",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 1,
>                 .target_residency = 1,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-IVB",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-IVB",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 59,
>                 .target_residency = 156,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-IVB",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 80,
>                 .target_residency = 300,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7-IVB",
>                 .desc = "MWAIT 0x30",
> -               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 87,
>                 .target_residency = 300,
>                 .enter = &intel_idle },
> @@ -288,28 +288,28 @@ static struct cpuidle_state ivt_cstates[] = {
>         {
>                 .name = "C1-IVT",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 1,
>                 .target_residency = 1,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-IVT",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 80,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-IVT",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 59,
>                 .target_residency = 156,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-IVT",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 82,
>                 .target_residency = 300,
>                 .enter = &intel_idle },
> @@ -321,28 +321,28 @@ static struct cpuidle_state ivt_cstates_4s[] = {
>         {
>                 .name = "C1-IVT-4S",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 1,
>                 .target_residency = 1,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-IVT-4S",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 250,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-IVT-4S",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 59,
>                 .target_residency = 300,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-IVT-4S",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 84,
>                 .target_residency = 400,
>                 .enter = &intel_idle },
> @@ -354,28 +354,28 @@ static struct cpuidle_state ivt_cstates_8s[] = {
>         {
>                 .name = "C1-IVT-8S",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 1,
>                 .target_residency = 1,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-IVT-8S",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 500,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-IVT-8S",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 59,
>                 .target_residency = 600,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-IVT-8S",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 88,
>                 .target_residency = 700,
>                 .enter = &intel_idle },
> @@ -387,56 +387,56 @@ static struct cpuidle_state hsw_cstates[] = {
>         {
>                 .name = "C1-HSW",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 2,
>                 .target_residency = 2,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-HSW",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-HSW",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 33,
>                 .target_residency = 100,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-HSW",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 133,
>                 .target_residency = 400,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7s-HSW",
>                 .desc = "MWAIT 0x32",
> -               .flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 166,
>                 .target_residency = 500,
>                 .enter = &intel_idle },
>         {
>                 .name = "C8-HSW",
>                 .desc = "MWAIT 0x40",
> -               .flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 300,
>                 .target_residency = 900,
>                 .enter = &intel_idle },
>         {
>                 .name = "C9-HSW",
>                 .desc = "MWAIT 0x50",
> -               .flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 600,
>                 .target_residency = 1800,
>                 .enter = &intel_idle },
>         {
>                 .name = "C10-HSW",
>                 .desc = "MWAIT 0x60",
> -               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 2600,
>                 .target_residency = 7700,
>                 .enter = &intel_idle },
> @@ -447,56 +447,56 @@ static struct cpuidle_state bdw_cstates[] = {
>         {
>                 .name = "C1-BDW",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 2,
>                 .target_residency = 2,
>                 .enter = &intel_idle },
>         {
>                 .name = "C1E-BDW",
>                 .desc = "MWAIT 0x01",
> -               .flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x01),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C3-BDW",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 40,
>                 .target_residency = 100,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-BDW",
>                 .desc = "MWAIT 0x20",
> -               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 133,
>                 .target_residency = 400,
>                 .enter = &intel_idle },
>         {
>                 .name = "C7s-BDW",
>                 .desc = "MWAIT 0x32",
> -               .flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 166,
>                 .target_residency = 500,
>                 .enter = &intel_idle },
>         {
>                 .name = "C8-BDW",
>                 .desc = "MWAIT 0x40",
> -               .flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 300,
>                 .target_residency = 900,
>                 .enter = &intel_idle },
>         {
>                 .name = "C9-BDW",
>                 .desc = "MWAIT 0x50",
> -               .flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 600,
>                 .target_residency = 1800,
>                 .enter = &intel_idle },
>         {
>                 .name = "C10-BDW",
>                 .desc = "MWAIT 0x60",
> -               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 2600,
>                 .target_residency = 7700,
>                 .enter = &intel_idle },
> @@ -508,28 +508,28 @@ static struct cpuidle_state atom_cstates[] = {
>         {
>                 .name = "C1E-ATM",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 10,
>                 .target_residency = 20,
>                 .enter = &intel_idle },
>         {
>                 .name = "C2-ATM",
>                 .desc = "MWAIT 0x10",
> -               .flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x10),
>                 .exit_latency = 20,
>                 .target_residency = 80,
>                 .enter = &intel_idle },
>         {
>                 .name = "C4-ATM",
>                 .desc = "MWAIT 0x30",
> -               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 100,
>                 .target_residency = 400,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-ATM",
>                 .desc = "MWAIT 0x52",
> -               .flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 140,
>                 .target_residency = 560,
>                 .enter = &intel_idle },
> @@ -540,14 +540,14 @@ static struct cpuidle_state avn_cstates[] = {
>         {
>                 .name = "C1-AVN",
>                 .desc = "MWAIT 0x00",
> -               .flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +               .flags = MWAIT2flg(0x00),
>                 .exit_latency = 2,
>                 .target_residency = 2,
>                 .enter = &intel_idle },
>         {
>                 .name = "C6-AVN",
>                 .desc = "MWAIT 0x51",
> -               .flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> +               .flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TLB_FLUSHED,
>                 .exit_latency = 15,
>                 .target_residency = 45,
>                 .enter = &intel_idle },
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 25e0df6..a07e087 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -53,7 +53,7 @@ struct cpuidle_state {
>  };
> 
>  /* Idle State Flags */
> -#define CPUIDLE_FLAG_TIME_VALID        (0x01) /* is residency time measurable? */
> +#define CPUIDLE_FLAG_TIME_INVALID      (0x01) /* is residency time measurable? */
>  #define CPUIDLE_FLAG_COUPLED   (0x02) /* state applies to multiple cpus */
>  #define CPUIDLE_FLAG_TIMER_STOP (0x04)  /* timer is stopped on this state */
> 
> @@ -90,7 +90,7 @@ DECLARE_PER_CPU(struct cpuidle_device, cpuidle_dev);
>   * cpuidle_get_last_residency - retrieves the last state's residency time
>   * @dev: the target CPU
>   *
> - * NOTE: this value is invalid if CPUIDLE_FLAG_TIME_VALID isn't set
> + * NOTE: this value is invalid if CPUIDLE_FLAG_TIME_INVALID is set
>   */
>  static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
>  {
> --
> 1.9.1
> 
> 
