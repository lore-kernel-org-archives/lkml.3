Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaGGQEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:04:24 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54139 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaGGQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <2031373.hXVBStNvpj@amdc1032>
References: <2031373.hXVBStNvpj@amdc1032>
Date: Mon, 7 Jul 2014 21:34:14 +0530
X-Google-Sender-Auth: xo5YDzTRiE7rRpdymp-GUsGaR80
Message-ID: <CAGm_ybgiL6SF7UY0HCMxw=O=HeNPwkx=oD5D=CrpR2P9V+_VRw@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: add EXYNOS3250 PMU support
From: Vikas Sajjan <vikas.sajjan@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Jun 2, 2014 at 10:24 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> This is needed for suspend/resume and cpuidle AFTR mode support.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> against next-20140602
>
>  arch/arm/mach-exynos/pmu.c      | 163 +++++++++++++++++++++++++++++++++++++++-
>  arch/arm/mach-exynos/regs-pmu.h | 128 +++++++++++++++++++++++++++++++
>  2 files changed, 290 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index fb0deda..9e9bad5 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -18,6 +18,98 @@
>
>  static const struct exynos_pmu_conf *exynos_pmu_config;
>
> +static struct exynos_pmu_conf exynos3250_pmu_config[] = {
> +       /* { .reg = address, .val = { AFTR, W-AFTR, SLEEP } */
> +       { EXYNOS3_ARM_CORE0_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
> +       { EXYNOS3_ARM_CORE1_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
> +       { EXYNOS3_ARM_CORE2_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE2_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE2_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
> +       { EXYNOS3_ARM_CORE3_SYS_PWR_REG,                { 0x0, 0x0, 0x2} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE3_LOCAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ARM_CORE3_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
> +       { EXYNOS3_ISP_ARM_SYS_PWR_REG,                  { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,    { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,  { 0x0, 0x0, 0x0} },
> +       { EXYNOS3_ARM_COMMON_SYS_PWR_REG,               { 0x0, 0x0, 0x2} },
> +       { EXYNOS3_ARM_L2_SYS_PWR_REG,                   { 0x0, 0x0, 0x3} },
> +       { EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,             { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,             { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_CMU_RESET_SYS_PWR_REG,                { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,           { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,            { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,       { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,     { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,     { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,        { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,              { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,         { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,          { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,       { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,            { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,            { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,            { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,           { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,            { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,         { 0x1, 0x0, 0x0} },
> +       { EXYNOS3_TOP_BUS_SYS_PWR_REG,                  { 0x3, 0x0, 0x0} },
> +       { EXYNOS3_TOP_RETENTION_SYS_PWR_REG,            { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_TOP_PWR_SYS_PWR_REG,                  { 0x3, 0x3, 0x3} },
> +       { EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,          { 0x3, 0x0, 0x0} },
> +       { EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,    { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,          { 0x3, 0x3, 0x3} },
> +       { EXYNOS3_LOGIC_RESET_SYS_PWR_REG,              { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,              { 0x1, 0x1, 0x1} },
> +       { EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,      { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,      { 0x1, 0x0, 0x1} },
> +       { EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,     { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,        { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,       { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,            { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,              { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_XUSBXTI_SYS_PWR_REG,                  { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_XXTI_SYS_PWR_REG,                     { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,            { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,    { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_GPIO_MODE_SYS_PWR_REG,                { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,         { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,            { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,        { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,    { 0x1, 0x1, 0x0} },
> +       { EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG,{ 0x1, 0x1, 0x0} },
> +       { EXYNOS3_CAM_SYS_PWR_REG,                      { 0x7, 0x0, 0x0} },
> +       { EXYNOS3_MFC_SYS_PWR_REG,                      { 0x7, 0x0, 0x0} },
> +       { EXYNOS3_G3D_SYS_PWR_REG,                      { 0x7, 0x7, 0x0} },
> +       { EXYNOS3_LCD0_SYS_PWR_REG,                     { 0x7, 0x7, 0x0} },
> +       { EXYNOS3_ISP_SYS_PWR_REG,                      { 0x7, 0x0, 0x0} },
> +       { EXYNOS3_MAUDIO_SYS_PWR_REG,                   { 0x7, 0x0, 0x0} },
> +       { EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,           { 0x1, 0x0, 0x0} },
> +       { PMU_TABLE_END,},
> +};
> +
>  static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>         /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
>         { S5P_ARM_CORE0_LOWPWR,                 { 0x0, 0x0, 0x2 } },
> @@ -316,6 +408,35 @@ static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
>         { PMU_TABLE_END,},
>  };
>
> +static void __iomem *exynos3250_list_feed[] = {
> +       EXYNOS3_ARM_CORE_OPTION(0),
> +       EXYNOS3_ARM_CORE_OPTION(1),
> +       EXYNOS3_ARM_CORE_OPTION(2),
> +       EXYNOS3_ARM_CORE_OPTION(3),
> +       EXYNOS3_ARM_COMMON_OPTION,
> +       EXYNOS3_TOP_PWR_OPTION,
> +       EXYNOS3_CORE_TOP_PWR_OPTION,
> +       S5P_CAM_OPTION,
> +       S5P_MFC_OPTION,
> +       S5P_G3D_OPTION,
> +       S5P_LCD0_OPTION,
> +       S5P_ISP_OPTION,
> +};
> +
> +static void exynos3250_init_pmu(void)
> +{
> +       unsigned int i;
> +       unsigned int tmp;
> +
> +       /* Enable only SC_FEEDBACK */
> +       for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
> +               tmp = __raw_readl(exynos3250_list_feed[i]);
> +               tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
> +               tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
> +               __raw_writel(tmp, exynos3250_list_feed[i]);
> +       }
> +}
> +
>  static void __iomem * const exynos5_list_both_cnt_feed[] = {
>         EXYNOS5_ARM_CORE0_OPTION,
>         EXYNOS5_ARM_CORE1_OPTION,
> @@ -380,6 +501,19 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
>                 __raw_writel(exynos_pmu_config[i].val[mode],
>                                 exynos_pmu_config[i].reg);
>
> +       if (soc_is_exynos3250()) {

we are NO MORE using is_soc_exynosxxxx()  in pmu.c or pm.c, please rebase on
1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33660.html
2] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33675.html


> +               exynos3250_init_pmu();
> +
> +               if (mode == SYS_SLEEP) {
> +                       __raw_writel(0x00000BB8, EXYNOS3_XUSBXTI_DURATION);
> +                       __raw_writel(0x00000BB8, EXYNOS3_XXTI_DURATION);
> +                       __raw_writel(0x00001D4C,
> +                                    EXYNOS3_EXT_REGULATOR_DURATION);
> +                       __raw_writel(0x00001D4C,
> +                                    EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
> +               }
> +       }
> +
>         if (soc_is_exynos4412()) {
>                 for (i = 0; exynos4412_pmu_config[i].reg != PMU_TABLE_END ; i++)
>                         __raw_writel(exynos4412_pmu_config[i].val[mode],
> @@ -393,7 +527,34 @@ static int __init exynos_pmu_init(void)
>
>         exynos_pmu_config = exynos4210_pmu_config;
>
> -       if (soc_is_exynos4210()) {
> +       if (soc_is_exynos3250()) {
> +               /*
> +                * To prevent form issuing new bus request form L2 memory system
> +                * If core status is power down, should be set '1' to L2 power down
> +                */
> +               value = __raw_readl(EXYNOS3_ARM_COMMON_OPTION);
> +               value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
> +               __raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
> +
> +               /* Enable USE_STANDBY_WFI for all CORE */
> +               __raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
> +
> +               /*
> +                * Set PSHOLD port for ouput high
> +                */
> +               value = __raw_readl(S5P_PS_HOLD_CONTROL);
> +               value |= S5P_PS_HOLD_OUTPUT_HIGH;
> +               __raw_writel(value, S5P_PS_HOLD_CONTROL);
> +               /*
> +                * Enable signal for PSHOLD port
> +                */
> +               value = __raw_readl(S5P_PS_HOLD_CONTROL);
> +               value |= S5P_PS_HOLD_EN;
> +               __raw_writel(value, S5P_PS_HOLD_CONTROL);
> +
> +               exynos_pmu_config = exynos3250_pmu_config;
> +               pr_info("EXYNOS3250 PMU Initialize\n");
> +       } else if (soc_is_exynos4210()) {
>                 exynos_pmu_config = exynos4210_pmu_config;
>                 pr_info("EXYNOS4210 PMU Initialize\n");
>         } else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
> index 1d13b08..e204a60 100644
> --- a/arch/arm/mach-exynos/regs-pmu.h
> +++ b/arch/arm/mach-exynos/regs-pmu.h
> @@ -24,7 +24,19 @@
>  #define S5P_CENTRAL_SEQ_OPTION                 S5P_PMUREG(0x0208)
>
>  #define S5P_USE_STANDBY_WFI0                   (1 << 16)
> +#define S5P_USE_STANDBY_WFI1                   (1 << 17)
> +#define S5P_USE_STANDBY_WFI2                   (1 << 19)
> +#define S5P_USE_STANDBY_WFI3                   (1 << 20)
>  #define S5P_USE_STANDBY_WFE0                   (1 << 24)
> +#define S5P_USE_STANDBY_WFE1                   (1 << 25)
> +#define S5P_USE_STANDBY_WFE2                   (1 << 27)
> +#define S5P_USE_STANDBY_WFE3                   (1 << 28)
> +
> +#define S5P_USE_STANDBY_WFI_ALL \
> +       (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFI1 | \
> +        S5P_USE_STANDBY_WFI2 | S5P_USE_STANDBY_WFI3 | \
> +        S5P_USE_STANDBY_WFE0 | S5P_USE_STANDBY_WFE1 | \
> +        S5P_USE_STANDBY_WFE2 | S5P_USE_STANDBY_WFE3)
>
>  #define EXYNOS_SWRESET                         S5P_PMUREG(0x0400)
>  #define EXYNOS5440_SWRESET                     S5P_PMUREG(0x00C4)
> @@ -126,6 +138,17 @@
>  #define S5P_PAD_RET_EBIA_OPTION                        S5P_PMUREG(0x3188)
>  #define S5P_PAD_RET_EBIB_OPTION                        S5P_PMUREG(0x31A8)
>
> +#define S5P_PS_HOLD_CONTROL                    S5P_PMUREG(0x330C)
> +#define S5P_PS_HOLD_EN                         (1 << 31)
> +#define S5P_PS_HOLD_OUTPUT_HIGH                        (3 << 8)
> +
> +#define S5P_CAM_OPTION                         S5P_PMUREG(0x3C08)
> +#define S5P_MFC_OPTION                         S5P_PMUREG(0x3C48)
> +#define S5P_G3D_OPTION                         S5P_PMUREG(0x3C68)
> +#define S5P_LCD0_OPTION                                S5P_PMUREG(0x3C88)
> +#define S5P_LCD1_OPTION                                S5P_PMUREG(0x3CA8)
> +#define S5P_ISP_OPTION                         S5P_LCD1_OPTION
> +
>  #define S5P_CORE_LOCAL_PWR_EN                  0x3
>  #define S5P_INT_LOCAL_PWR_EN                   0x7
>
> @@ -186,6 +209,111 @@
>  #define S5P_DIS_IRQ_CORE3                      S5P_PMUREG(0x1034)
>  #define S5P_DIS_IRQ_CENTRAL3                   S5P_PMUREG(0x1038)
>
> +/* Only for EXYNOS3XXX */
> +#define EXYNOS3_ARM_CORE0_SYS_PWR_REG                  S5P_PMUREG(0x1000)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG    S5P_PMUREG(0x1004)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG  S5P_PMUREG(0x1008)
> +#define EXYNOS3_ARM_CORE1_SYS_PWR_REG                  S5P_PMUREG(0x1010)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG    S5P_PMUREG(0x1014)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG  S5P_PMUREG(0x1018)
> +#define EXYNOS3_ARM_CORE2_SYS_PWR_REG                  S5P_PMUREG(0x1020)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE2_LOCAL_SYS_PWR_REG    S5P_PMUREG(0x1024)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE2_CENTRAL_SYS_PWR_REG  S5P_PMUREG(0x1028)
> +#define EXYNOS3_ARM_CORE3_SYS_PWR_REG                  S5P_PMUREG(0x1030)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE3_LOCAL_SYS_PWR_REG    S5P_PMUREG(0x1034)
> +#define EXYNOS3_DIS_IRQ_ARM_CORE3_CENTRAL_SYS_PWR_REG  S5P_PMUREG(0x1038)
> +#define EXYNOS3_ISP_ARM_SYS_PWR_REG                    S5P_PMUREG(0x1050)
> +#define EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG      S5P_PMUREG(0x1054)
> +#define EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG    S5P_PMUREG(0x1058)
> +#define EXYNOS3_ARM_COMMON_SYS_PWR_REG                 S5P_PMUREG(0x1080)
> +#define EXYNOS3_ARM_L2_SYS_PWR_REG                     S5P_PMUREG(0x10C0)
> +#define EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG               S5P_PMUREG(0x1100)
> +#define EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG               S5P_PMUREG(0x1104)
> +#define EXYNOS3_CMU_RESET_SYS_PWR_REG                  S5P_PMUREG(0x110C)
> +#define EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG       S5P_PMUREG(0x1110)
> +#define EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG       S5P_PMUREG(0x1114)
> +#define EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG          S5P_PMUREG(0x111C)
> +#define EXYNOS3_APLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x1120)
> +#define EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x1124)
> +#define EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x1128)
> +#define EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x112C)
> +#define EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG            S5P_PMUREG(0x1130)
> +#define EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG            S5P_PMUREG(0x1134)
> +#define EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG            S5P_PMUREG(0x1138)
> +#define EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG            S5P_PMUREG(0x1140)
> +#define EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG            S5P_PMUREG(0x1148)
> +#define EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG            S5P_PMUREG(0x114C)
> +#define EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG           S5P_PMUREG(0x1150)
> +#define EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG            S5P_PMUREG(0x1154)
> +#define EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG         S5P_PMUREG(0x1158)
> +#define EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG              S5P_PMUREG(0x1160)
> +#define EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG              S5P_PMUREG(0x1168)
> +#define EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG              S5P_PMUREG(0x116C)
> +#define EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG             S5P_PMUREG(0x1170)
> +#define EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG              S5P_PMUREG(0x1174)
> +#define EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG           S5P_PMUREG(0x1178)
> +#define EXYNOS3_TOP_BUS_SYS_PWR_REG                    S5P_PMUREG(0x1180)
> +#define EXYNOS3_TOP_RETENTION_SYS_PWR_REG              S5P_PMUREG(0x1184)
> +#define EXYNOS3_TOP_PWR_SYS_PWR_REG                    S5P_PMUREG(0x1188)
> +#define EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG            S5P_PMUREG(0x1190)
> +#define EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG      S5P_PMUREG(0x1194)
> +#define EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG            S5P_PMUREG(0x1198)
> +#define EXYNOS3_LOGIC_RESET_SYS_PWR_REG                        S5P_PMUREG(0x11A0)
> +#define EXYNOS3_OSCCLK_GATE_SYS_PWR_REG                        S5P_PMUREG(0x11A4)
> +#define EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG                S5P_PMUREG(0x11B0)
> +#define EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG                S5P_PMUREG(0x11B4)
> +#define EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG         S5P_PMUREG(0x1200)
> +#define EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG       S5P_PMUREG(0x1204)
> +#define EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG          S5P_PMUREG(0x1208)
> +#define EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG         S5P_PMUREG(0x1218)
> +#define EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG         S5P_PMUREG(0x1220)
> +#define EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG         S5P_PMUREG(0x1224)
> +#define EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG         S5P_PMUREG(0x1228)
> +#define EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG         S5P_PMUREG(0x122C)
> +#define EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG         S5P_PMUREG(0x1230)
> +#define EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG         S5P_PMUREG(0x1234)
> +#define EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG         S5P_PMUREG(0x1238)
> +#define EXYNOS3_PAD_ISOLATION_SYS_PWR_REG              S5P_PMUREG(0x1240)
> +#define EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG                        S5P_PMUREG(0x1260)
> +#define EXYNOS3_XUSBXTI_SYS_PWR_REG                    S5P_PMUREG(0x1280)
> +#define EXYNOS3_XXTI_SYS_PWR_REG                       S5P_PMUREG(0x1284)
> +#define EXYNOS3_EXT_REGULATOR_SYS_PWR_REG              S5P_PMUREG(0x12C0)
> +#define EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG      S5P_PMUREG(0x12C4)
> +#define EXYNOS3_GPIO_MODE_SYS_PWR_REG                  S5P_PMUREG(0x1300)
> +#define EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG           S5P_PMUREG(0x1340)
> +#define EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG              S5P_PMUREG(0x1344)
> +#define EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG          S5P_PMUREG(0x1348)
> +#define EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG      S5P_PMUREG(0x1350)
> +#define EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG  S5P_PMUREG(0x1354)
> +#define EXYNOS3_CAM_SYS_PWR_REG                                S5P_PMUREG(0x1380)
> +#define EXYNOS3_MFC_SYS_PWR_REG                                S5P_PMUREG(0x1388)
> +#define EXYNOS3_G3D_SYS_PWR_REG                                S5P_PMUREG(0x138C)
> +#define EXYNOS3_LCD0_SYS_PWR_REG                       S5P_PMUREG(0x1390)
> +#define EXYNOS3_ISP_SYS_PWR_REG                                S5P_PMUREG(0x1394)
> +#define EXYNOS3_MAUDIO_SYS_PWR_REG                     S5P_PMUREG(0x1398)
> +#define EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG             S5P_PMUREG(0x13B0)
> +#define EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG              S5P_PMUREG(0x13B4)
> +#define EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG             S5P_PMUREG(0x13B8)
> +#define EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG         S5P_PMUREG(0x13C0)
> +#define EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x13C4)
> +#define EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG                        S5P_PMUREG(0x13C8)
> +
> +#define EXYNOS3_ARM_CORE0_OPTION                       S5P_PMUREG(0x2008)
> +#define EXYNOS3_ARM_CORE_OPTION(_nr)                   (EXYNOS3_ARM_CORE0_OPTION + ((_nr) * 0x80))
> +
> +#define EXYNOS3_ARM_COMMON_OPTION                      S5P_PMUREG(0x2408)
> +#define EXYNOS3_TOP_PWR_OPTION                         S5P_PMUREG(0x2C48)
> +#define EXYNOS3_CORE_TOP_PWR_OPTION                    S5P_PMUREG(0x2CA8)
> +#define EXYNOS3_XUSBXTI_DURATION                       S5P_PMUREG(0x341C)
> +#define EXYNOS3_XXTI_DURATION                          S5P_PMUREG(0x343C)
> +#define EXYNOS3_EXT_REGULATOR_DURATION                 S5P_PMUREG(0x361C)
> +#define EXYNOS3_EXT_REGULATOR_COREBLK_DURATION         S5P_PMUREG(0x363C)
> +
> +/* for XXX_OPTION */
> +#define EXYNOS3_OPTION_USE_SC_COUNTER                  (1 << 0)
> +#define EXYNOS3_OPTION_USE_SC_FEEDBACK                 (1 << 1)
> +#define EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN  (1 << 7)
> +
>  /* For EXYNOS5 */
>
>  #define EXYNOS5_SYS_I2C_CFG                                    S5P_SYSREG(0x0234)
> --
> 1.8.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
