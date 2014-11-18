Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaKRRev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:34:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:20359 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbaKRRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:34:47 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-12-546b8334f570
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] ARM: EXYNOS: add Exynos3250 PMU support
Date: Tue, 18 Nov 2014 18:34:41 +0100
Message-id: <1908469.QaqIJlesoD@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jAV2T5uwQg/OX9C2uf3nOatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLBZt/cJusWrXH0aLm8+2MzlweuycdZfdY/OSeo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKuHX3E2vB7F7GihlHjBoYn1d0MXJySAiYSPROnMQKYYtJ
	XLi3nq2LkYtDSGARo8TBY1fYIZwWJokTx06DVbEJWElMbF/FCGKLCKhJ9CzeCmYzC+xkktjX
	y9PFyMEhLGAt8XtVKkiYRUBV4t+rF8wgYV4BTYk3s5lAwqICnhI7px8A6+QVEJT4MfkeC8QU
	eYl9+6eyQthaEut3HmeawMg3C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yf
	u4kRHLrPpHcwrmqwOMQowMGoxMObODUrRIg1say4MvcQowQHs5II77luoBBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGJpcdOekr+47y8q1a1eOornHm
	M8910/mSvRoLjoY9rdkvYiFyuzJ/H9/mnnc+/RYPtA4piJW2VBUuZFpoNmtT6atpMo4B+R3f
	+eWmHHAX9xOu5azyrV3W5rPxQxf/8hdZM3aumzb3V+jP3mVKx9f/j1KQdfq/1ntO/nmDpWFs
	Qe/ZbnvOXvhOiaU4I9FQi7moOBEACTTMrlkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the PMU code for the future:
- suspend/resume (S2R) support
- cpuidle AFTR/W-AFTR modes support
on Exynos3250.

Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Vikas Sajjan <vikas.sajjan@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v4:
- rebased on top of next-20141114 branch of linux-next kernel tree
  (it also applies fine to for-next branch of linux-samsung.git)
- removed writing to undocumented CORE2 and CORE3 related registers
- fixed values used for EXYNOS3_[G3D,LCD]_SYS_PWR_REG registers
- added defines for values used for EXYNOS3_*_DURATION registers
- removed redundat pr_info("EXYNOS3250 PMU Initialize\n")

v3:
- rebased on top of for-next branch of linux-samsung.git and
  [PATCH v7] mfd: syscon: Decouple syscon interface from platform devices
  (https://lkml.org/lkml/2014/9/30/156)
  [PATCH v9 0/2] ARM: Exynos: Convert PMU implementation into a platform driver
  (https://lkml.org/lkml/2014/10/6/89)
  [PATCH v9 0/2] Adds PMU and S2R support for exynos5420
  (http://www.spinics.net/lists/arm-kernel/msg368207.html)

v2:
- rebased on top of next-20140708 and
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32410.html
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33660.html
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33675.html

  this patch also applies fine after/before Exynos5800 PMU support:
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33835.html

 arch/arm/mach-exynos/pmu.c      | 167 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h | 128 ++++++++++++++++++++++++++++++
 2 files changed, 295 insertions(+)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 6c8a76d..673723f 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -31,6 +31,7 @@ struct exynos_pmu_data {
 
 	void (*pmu_init)(void);
 	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerdown_conf_extra)(enum sys_powerdown);
 };
 
 struct exynos_pmu_context {
@@ -51,6 +52,92 @@ static inline u32 pmu_raw_readl(u32 offset)
 	return readl_relaxed(pmu_base_addr + offset);
 }
 
+static struct exynos_pmu_conf exynos3250_pmu_config[] = {
+	/* { .offset = offset, .val = { AFTR, W-AFTR, SLEEP } */
+	{ EXYNOS3_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_CORE1_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG,{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ISP_ARM_SYS_PWR_REG,			{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
+	{ EXYNOS3_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
+	{ EXYNOS3_ARM_L2_SYS_PWR_REG,			{ 0x0, 0x0, 0x3} },
+	{ EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_APLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ EXYNOS3_TOP_BUS_SYS_PWR_REG,			{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG,		{ 0x3, 0x0, 0x0} },
+	{ EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG,		{ 0x3, 0x3, 0x3} },
+	{ EXYNOS3_LOGIC_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_SYS_PWR_REG,		{ 0x1, 0x1, 0x1} },
+	{ EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG,	{ 0x1, 0x0, 0x1} },
+	{ EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ISOLATION_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XUSBXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_XXTI_SYS_PWR_REG,			{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG,	{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG,{ 0x1, 0x1, 0x0} },
+	{ EXYNOS3_CAM_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MFC_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_G3D_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_LCD0_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_ISP_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_MAUDIO_SYS_PWR_REG,			{ 0x7, 0x0, 0x0} },
+	{ EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG,		{ 0x1, 0x0, 0x0} },
+	{ PMU_TABLE_END,},
+};
+
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
@@ -495,6 +582,44 @@ static struct exynos_pmu_conf exynos5420_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
+static unsigned int const exynos3250_list_feed[] = {
+	EXYNOS3_ARM_CORE_OPTION(0),
+	EXYNOS3_ARM_CORE_OPTION(1),
+	EXYNOS3_ARM_CORE_OPTION(2),
+	EXYNOS3_ARM_CORE_OPTION(3),
+	EXYNOS3_ARM_COMMON_OPTION,
+	EXYNOS3_TOP_PWR_OPTION,
+	EXYNOS3_CORE_TOP_PWR_OPTION,
+	S5P_CAM_OPTION,
+	S5P_MFC_OPTION,
+	S5P_G3D_OPTION,
+	S5P_LCD0_OPTION,
+	S5P_ISP_OPTION,
+};
+
+static void exynos3250_powerdown_conf_extra(enum sys_powerdown mode)
+{
+	unsigned int i;
+	unsigned int tmp;
+
+	/* Enable only SC_FEEDBACK */
+	for (i = 0; i < ARRAY_SIZE(exynos3250_list_feed); i++) {
+		tmp = pmu_raw_readl(exynos3250_list_feed[i]);
+		tmp &= ~(EXYNOS3_OPTION_USE_SC_COUNTER);
+		tmp |= EXYNOS3_OPTION_USE_SC_FEEDBACK;
+		pmu_raw_writel(tmp, exynos3250_list_feed[i]);
+	}
+
+	if (mode != SYS_SLEEP)
+		return;
+
+	pmu_raw_writel(XUSBXTI_DURATION, EXYNOS3_XUSBXTI_DURATION);
+	pmu_raw_writel(XXTI_DURATION, EXYNOS3_XXTI_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_DURATION, EXYNOS3_EXT_REGULATOR_DURATION);
+	pmu_raw_writel(EXT_REGULATOR_COREBLK_DURATION,
+		       EXYNOS3_EXT_REGULATOR_COREBLK_DURATION);
+}
+
 static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_ARM_CORE0_OPTION,
 	EXYNOS5_ARM_CORE1_OPTION,
@@ -632,6 +757,9 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 					pmu_data->pmu_config[i].offset);
 	}
 
+	if (pmu_data->powerdown_conf_extra)
+		pmu_data->powerdown_conf_extra(mode);
+
 	if (pmu_data->pmu_config_extra) {
 		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
 			pmu_raw_writel(pmu_data->pmu_config_extra[i].val[mode],
@@ -639,6 +767,36 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	}
 }
 
+static void exynos3250_pmu_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * To prevent form issuing new bus request form L2 memory system
+	 * If core status is power down, should be set '1' to L2 power down
+	 */
+	value = pmu_raw_readl(EXYNOS3_ARM_COMMON_OPTION);
+	value |= EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
+	pmu_raw_writel(value, EXYNOS3_ARM_COMMON_OPTION);
+
+	/* Enable USE_STANDBY_WFI for all CORE */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI_ALL, S5P_CENTRAL_SEQ_OPTION);
+
+	/*
+	 * Set PSHOLD port for output high
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_OUTPUT_HIGH;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+
+	/*
+	 * Enable signal for PSHOLD port
+	 */
+	value = pmu_raw_readl(S5P_PS_HOLD_CONTROL);
+	value |= S5P_PS_HOLD_EN;
+	pmu_raw_writel(value, S5P_PS_HOLD_CONTROL);
+}
+
 static void exynos5250_pmu_init(void)
 {
 	unsigned int value;
@@ -717,6 +875,12 @@ static void exynos5420_pmu_init(void)
 }
 
 
+static const struct exynos_pmu_data exynos3250_pmu_data = {
+	.pmu_config	= exynos3250_pmu_config,
+	.pmu_init	= exynos3250_pmu_init,
+	.powerdown_conf_extra	= exynos3250_powerdown_conf_extra,
+};
+
 static const struct exynos_pmu_data exynos4210_pmu_data = {
 	.pmu_config	= exynos4210_pmu_config,
 };
@@ -747,6 +911,9 @@ static struct exynos_pmu_data exynos5420_pmu_data = {
  */
 static const struct of_device_id exynos_pmu_of_device_ids[] = {
 	{
+		.compatible = "samsung,exynos3250-pmu",
+		.data = &exynos3250_pmu_data,
+	}, {
 		.compatible = "samsung,exynos4210-pmu",
 		.data = &exynos4210_pmu_data,
 	}, {
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 46b973b..d5a66e9 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -19,7 +19,20 @@
 #define S5P_CENTRAL_SEQ_OPTION			0x0208
 
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
+#define S5P_USE_STANDBY_WFI1			(1 << 17)
+#define S5P_USE_STANDBY_WFI2			(1 << 19)
+#define S5P_USE_STANDBY_WFI3			(1 << 20)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
+#define S5P_USE_STANDBY_WFE1			(1 << 25)
+#define S5P_USE_STANDBY_WFE2			(1 << 27)
+#define S5P_USE_STANDBY_WFE3			(1 << 28)
+
+#define S5P_USE_STANDBY_WFI_ALL \
+	(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFI1 | \
+	 S5P_USE_STANDBY_WFI2 | S5P_USE_STANDBY_WFI3 | \
+	 S5P_USE_STANDBY_WFE0 | S5P_USE_STANDBY_WFE1 | \
+	 S5P_USE_STANDBY_WFE2 | S5P_USE_STANDBY_WFE3)
+
 #define S5P_USE_DELAYED_RESET_ASSERTION		BIT(12)
 
 #define EXYNOS_CORE_PO_RESET(n)			((1 << 4) << n)
@@ -154,6 +167,17 @@
 #define S5P_PAD_RET_EBIA_OPTION			0x3188
 #define S5P_PAD_RET_EBIB_OPTION			0x31A8
 
+#define S5P_PS_HOLD_CONTROL			0x330C
+#define S5P_PS_HOLD_EN				(1 << 31)
+#define S5P_PS_HOLD_OUTPUT_HIGH			(3 << 8)
+
+#define S5P_CAM_OPTION				0x3C08
+#define S5P_MFC_OPTION				0x3C48
+#define S5P_G3D_OPTION				0x3C68
+#define S5P_LCD0_OPTION				0x3C88
+#define S5P_LCD1_OPTION				0x3CA8
+#define S5P_ISP_OPTION				S5P_LCD1_OPTION
+
 #define S5P_CORE_LOCAL_PWR_EN			0x3
 #define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
 
@@ -214,6 +238,110 @@
 #define S5P_DIS_IRQ_CORE3			0x1034
 #define S5P_DIS_IRQ_CENTRAL3			0x1038
 
+/* Only for EXYNOS3XXX */
+#define EXYNOS3_ARM_CORE0_SYS_PWR_REG			0x1000
+#define EXYNOS3_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG	0x1004
+#define EXYNOS3_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG	0x1008
+#define EXYNOS3_ARM_CORE1_SYS_PWR_REG			0x1010
+#define EXYNOS3_DIS_IRQ_ARM_CORE1_LOCAL_SYS_PWR_REG	0x1014
+#define EXYNOS3_DIS_IRQ_ARM_CORE1_CENTRAL_SYS_PWR_REG	0x1018
+#define EXYNOS3_ISP_ARM_SYS_PWR_REG			0x1050
+#define EXYNOS3_DIS_IRQ_ISP_ARM_LOCAL_SYS_PWR_REG	0x1054
+#define EXYNOS3_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG	0x1058
+#define EXYNOS3_ARM_COMMON_SYS_PWR_REG			0x1080
+#define EXYNOS3_ARM_L2_SYS_PWR_REG			0x10C0
+#define EXYNOS3_CMU_ACLKSTOP_SYS_PWR_REG		0x1100
+#define EXYNOS3_CMU_SCLKSTOP_SYS_PWR_REG		0x1104
+#define EXYNOS3_CMU_RESET_SYS_PWR_REG			0x110C
+#define EXYNOS3_CMU_ACLKSTOP_COREBLK_SYS_PWR_REG	0x1110
+#define EXYNOS3_CMU_SCLKSTOP_COREBLK_SYS_PWR_REG	0x1114
+#define EXYNOS3_CMU_RESET_COREBLK_SYS_PWR_REG		0x111C
+#define EXYNOS3_APLL_SYSCLK_SYS_PWR_REG			0x1120
+#define EXYNOS3_MPLL_SYSCLK_SYS_PWR_REG			0x1124
+#define EXYNOS3_VPLL_SYSCLK_SYS_PWR_REG			0x1128
+#define EXYNOS3_EPLL_SYSCLK_SYS_PWR_REG			0x112C
+#define EXYNOS3_MPLLUSER_SYSCLK_SYS_PWR_REG		0x1130
+#define EXYNOS3_BPLLUSER_SYSCLK_SYS_PWR_REG		0x1134
+#define EXYNOS3_EPLLUSER_SYSCLK_SYS_PWR_REG		0x1138
+#define EXYNOS3_CMU_CLKSTOP_CAM_SYS_PWR_REG		0x1140
+#define EXYNOS3_CMU_CLKSTOP_MFC_SYS_PWR_REG		0x1148
+#define EXYNOS3_CMU_CLKSTOP_G3D_SYS_PWR_REG		0x114C
+#define EXYNOS3_CMU_CLKSTOP_LCD0_SYS_PWR_REG		0x1150
+#define EXYNOS3_CMU_CLKSTOP_ISP_SYS_PWR_REG		0x1154
+#define EXYNOS3_CMU_CLKSTOP_MAUDIO_SYS_PWR_REG		0x1158
+#define EXYNOS3_CMU_RESET_CAM_SYS_PWR_REG		0x1160
+#define EXYNOS3_CMU_RESET_MFC_SYS_PWR_REG		0x1168
+#define EXYNOS3_CMU_RESET_G3D_SYS_PWR_REG		0x116C
+#define EXYNOS3_CMU_RESET_LCD0_SYS_PWR_REG		0x1170
+#define EXYNOS3_CMU_RESET_ISP_SYS_PWR_REG		0x1174
+#define EXYNOS3_CMU_RESET_MAUDIO_SYS_PWR_REG		0x1178
+#define EXYNOS3_TOP_BUS_SYS_PWR_REG			0x1180
+#define EXYNOS3_TOP_RETENTION_SYS_PWR_REG		0x1184
+#define EXYNOS3_TOP_PWR_SYS_PWR_REG			0x1188
+#define EXYNOS3_TOP_BUS_COREBLK_SYS_PWR_REG		0x1190
+#define EXYNOS3_TOP_RETENTION_COREBLK_SYS_PWR_REG	0x1194
+#define EXYNOS3_TOP_PWR_COREBLK_SYS_PWR_REG		0x1198
+#define EXYNOS3_LOGIC_RESET_SYS_PWR_REG			0x11A0
+#define EXYNOS3_OSCCLK_GATE_SYS_PWR_REG			0x11A4
+#define EXYNOS3_LOGIC_RESET_COREBLK_SYS_PWR_REG		0x11B0
+#define EXYNOS3_OSCCLK_GATE_COREBLK_SYS_PWR_REG		0x11B4
+#define EXYNOS3_PAD_RETENTION_DRAM_SYS_PWR_REG		0x1200
+#define EXYNOS3_PAD_RETENTION_MAUDIO_SYS_PWR_REG	0x1204
+#define EXYNOS3_PAD_RETENTION_SPI_SYS_PWR_REG		0x1208
+#define EXYNOS3_PAD_RETENTION_MMC2_SYS_PWR_REG		0x1218
+#define EXYNOS3_PAD_RETENTION_GPIO_SYS_PWR_REG		0x1220
+#define EXYNOS3_PAD_RETENTION_UART_SYS_PWR_REG		0x1224
+#define EXYNOS3_PAD_RETENTION_MMC0_SYS_PWR_REG		0x1228
+#define EXYNOS3_PAD_RETENTION_MMC1_SYS_PWR_REG		0x122C
+#define EXYNOS3_PAD_RETENTION_EBIA_SYS_PWR_REG		0x1230
+#define EXYNOS3_PAD_RETENTION_EBIB_SYS_PWR_REG		0x1234
+#define EXYNOS3_PAD_RETENTION_JTAG_SYS_PWR_REG		0x1238
+#define EXYNOS3_PAD_ISOLATION_SYS_PWR_REG		0x1240
+#define EXYNOS3_PAD_ALV_SEL_SYS_PWR_REG			0x1260
+#define EXYNOS3_XUSBXTI_SYS_PWR_REG			0x1280
+#define EXYNOS3_XXTI_SYS_PWR_REG			0x1284
+#define EXYNOS3_EXT_REGULATOR_SYS_PWR_REG		0x12C0
+#define EXYNOS3_EXT_REGULATOR_COREBLK_SYS_PWR_REG	0x12C4
+#define EXYNOS3_GPIO_MODE_SYS_PWR_REG			0x1300
+#define EXYNOS3_GPIO_MODE_MAUDIO_SYS_PWR_REG		0x1340
+#define EXYNOS3_TOP_ASB_RESET_SYS_PWR_REG		0x1344
+#define EXYNOS3_TOP_ASB_ISOLATION_SYS_PWR_REG		0x1348
+#define EXYNOS3_TOP_ASB_RESET_COREBLK_SYS_PWR_REG	0x1350
+#define EXYNOS3_TOP_ASB_ISOLATION_COREBLK_SYS_PWR_REG	0x1354
+#define EXYNOS3_CAM_SYS_PWR_REG				0x1380
+#define EXYNOS3_MFC_SYS_PWR_REG				0x1388
+#define EXYNOS3_G3D_SYS_PWR_REG				0x138C
+#define EXYNOS3_LCD0_SYS_PWR_REG			0x1390
+#define EXYNOS3_ISP_SYS_PWR_REG				0x1394
+#define EXYNOS3_MAUDIO_SYS_PWR_REG			0x1398
+#define EXYNOS3_DRAM_FREQ_DOWN_SYS_PWR_REG		0x13B0
+#define EXYNOS3_DDRPHY_DLLOFF_SYS_PWR_REG		0x13B4
+#define EXYNOS3_CMU_SYSCLK_ISP_SYS_PWR_REG		0x13B8
+#define EXYNOS3_LPDDR_PHY_DLL_LOCK_SYS_PWR_REG		0x13C0
+#define EXYNOS3_BPLL_SYSCLK_SYS_PWR_REG			0x13C4
+#define EXYNOS3_UPLL_SYSCLK_SYS_PWR_REG			0x13C8
+
+#define EXYNOS3_ARM_CORE0_OPTION			0x2008
+#define EXYNOS3_ARM_CORE_OPTION(_nr)	\
+			(EXYNOS3_ARM_CORE0_OPTION + ((_nr) * 0x80))
+
+#define EXYNOS3_ARM_COMMON_OPTION			0x2408
+#define EXYNOS3_TOP_PWR_OPTION				0x2C48
+#define EXYNOS3_CORE_TOP_PWR_OPTION			0x2CA8
+#define EXYNOS3_XUSBXTI_DURATION			0x341C
+#define EXYNOS3_XXTI_DURATION				0x343C
+#define EXYNOS3_EXT_REGULATOR_DURATION			0x361C
+#define EXYNOS3_EXT_REGULATOR_COREBLK_DURATION		0x363C
+#define XUSBXTI_DURATION				0x00000BB8
+#define XXTI_DURATION					XUSBXTI_DURATION
+#define EXT_REGULATOR_DURATION				0x00001D4C
+#define EXT_REGULATOR_COREBLK_DURATION			EXT_REGULATOR_DURATION
+
+/* for XXX_OPTION */
+#define EXYNOS3_OPTION_USE_SC_COUNTER			(1 << 0)
+#define EXYNOS3_OPTION_USE_SC_FEEDBACK			(1 << 1)
+#define EXYNOS3_OPTION_SKIP_DEACTIVATE_ACEACP_IN_PWDN	(1 << 7)
+
 /* For EXYNOS5 */
 
 #define EXYNOS5_AUTO_WDTRESET_DISABLE				0x0408
-- 
1.8.2.3


