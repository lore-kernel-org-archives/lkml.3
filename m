Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaJTDck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:32:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaJTDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:32:36 -0400
X-AuditID: cbfee68e-f79b46d000002b74-e2-544482507a5c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        cw00.choi@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common clock
 framework
Date: Mon, 20 Oct 2014 12:32:12 +0900
Message-id: <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkUDewySXE4KGqxd9Jx9gtJq07wGRx
	/ctzVos/E1rZLHb9vc9oMen+BBaLHQ1HWC1u/GpjtehdcJXN4mzTG3aLKX+WM1lsenyN1eLy
	rjlsFjPO72OyuH2Z12Lp9YtMFk8nXGSzOHX9M5vF4TftrBYzJr9kszg2Ywmjxapdfxgt9u6c
	zOgg7rFm3hpGj5bmHjaP378mMXr8XfWC2WPnrLvsHneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+S
	C+CK4rJJSc3JLEst0rdL4Mr4t3cua8GWDcwVHS8msTQwbn/D1MXIySEhYCLx9l4TM4QtJnHh
	3nq2LkYuDiGBpYwSs6/sZIMpWg70D4gtJDCdUeLKcX6IoiYmiW3/54NNYhPQktj/4gZYg4hA
	tsSVxvvMIEXMAh+YJXpuvWYBSQgLREjMvn0XrIhFQFWiack6sNW8Aq4SG36eYIXYJifxYc8j
	dhCbU8BN4nDXf6AFHEDbXCVmbFYFmSkhsIVDYknzKxaIOQIS3yYfYgGpkRCQldh0AOobSYmD
	K26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMG5P/3vWt4Px5gHrQ4wCHIxK
	PLw7zFxChFgTy4orcw8xmgJtmMgsJZqcD0wOeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MMrMdGqydclMioiZ8mbef/W/AqouC5r7595NPDmJY8+s
	jMfb9rXqH7sUKmN0xnwB47vcadtigtyX6EueFJ64oTfzIU/xq1+P37xNvGjg0Kdj9bL0cVV5
	WLLGSXuXvFNnSg9dnXLu8e7PV35oeF5vru88VvvMnzEnNCFgR8YOlb+vQ6t/BxYaWSixFGck
	GmoxFxUnAgDt47741gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xoG5Ak0uIwb6nyhZ/Jx1jt5i07gCT
	xfUvz1kt/kxoZbPY9fc+o8Wk+xNYLHY0HGG1uPGrjdWid8FVNouzTW/YLab8Wc5ksenxNVaL
	y7vmsFnMOL+PyeL2ZV6LpdcvMlk8nXCRzeLU9c9sFofftLNazJj8ks3i2IwljBardv1htNi7
	czKjg7jHmnlrGD1amnvYPH7/msTo8XfVC2aPnbPusnvcubaHzWPzknqPKyeaWD36tqxi9Pi8
	SS6AK6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH
	6F0lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8a/vXNZC7ZsYK7oeDGJ
	pYFx+xumLkZODgkBE4nlwCCCsMUkLtxbzwZiCwlMZ5S4cpy/i5ELyG5iktj2fz5YA5uAlsT+
	FzfAikQEsiWuNN5nBiliFvjALNFz6zULSEJYIEJi9u27YEUsAqoSTUvWMYPYvAKuEht+noDa
	JifxYc8jdhCbU8BN4nDXf6AFHEDbXCVmbFadwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpe
	cn7uJkZwWngmtYNxZYPFIUYBDkYlHt4dZi4hQqyJZcWVuYcYJTiYlUR4/2UAhXhTEiurUovy
	44tKc1KLDzGaAh01kVlKNDkfmLLySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphak
	FsH0MXFwSjUwqpvcXVhx4syMrVrx97d891tdcudzX6XVhvWLJ5W1bZm++mVtyM68D1wO9bMs
	7rfn+5rd3fJTWsOvKYhP6fGmCX+n9XL+ynQ55aXq7LP+ZVHDm1/xBh8bOVXW2S3+rMYesnW7
	xpVqiza13wYMzeeW3ZhcuevstEXu1jHiNaeeeL8//t6HtzVnmxJLcUaioRZzUXEiAI5eZiMh	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
using common clock framework. The CMU (Clock Management Unit) of Exynos4415
controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
and function clocks for individual IPs.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/Makefile           |    1 +
 drivers/clk/samsung/clk-exynos4415.c   | 1133 ++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos4415.h |  360 ++++++++++
 3 files changed, 1494 insertions(+)
 create mode 100644 drivers/clk/samsung/clk-exynos4415.c
 create mode 100644 include/dt-bindings/clock/exynos4415.h

diff --git a/drivers/clk/samsung/Makefile b/drivers/clk/samsung/Makefile
index 6fb4bc6..d8535e6 100644
--- a/drivers/clk/samsung/Makefile
+++ b/drivers/clk/samsung/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-pll.o
 obj-$(CONFIG_SOC_EXYNOS3250)	+= clk-exynos3250.o
 obj-$(CONFIG_ARCH_EXYNOS4)	+= clk-exynos4.o
+obj-$(CONFIG_SOC_EXYNOS4415)	+= clk-exynos4415.o
 obj-$(CONFIG_SOC_EXYNOS5250)	+= clk-exynos5250.o
 obj-$(CONFIG_SOC_EXYNOS5260)	+= clk-exynos5260.o
 obj-$(CONFIG_SOC_EXYNOS5410)	+= clk-exynos5410.o
diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
new file mode 100644
index 0000000..a4b6211
--- /dev/null
+++ b/drivers/clk/samsung/clk-exynos4415.c
@@ -0,0 +1,1133 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Common Clock Framework support for Exynos4415 SoC.
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/syscore_ops.h>
+
+#include <dt-bindings/clock/exynos4415.h>
+
+#include "clk.h"
+#include "clk-pll.h"
+
+#define SRC_LEFTBUS		0x4200
+#define DIV_LEFTBUS		0x4500
+#define GATE_IP_LEFTBUS		0x4800
+#define GATE_IP_IMAGE		0x4930
+#define SRC_RIGHTBUS		0x8200
+#define DIV_RIGHTBUS		0x8500
+#define GATE_IP_RIGHTBUS	0x8800
+#define GATE_IP_PERIR		0x8960
+#define EPLL_LOCK		0xc010
+#define G3D_PLL_LOCK		0xc020
+#define DISP_PLL_LOCK		0xc030
+#define ISP_PLL_LOCK		0xc040
+#define EPLL_CON0		0xc110
+#define EPLL_CON1		0xc114
+#define EPLL_CON2		0xc118
+#define G3D_PLL_CON0		0xc120
+#define G3D_PLL_CON1		0xc124
+#define G3D_PLL_CON2		0xc128
+#define ISP_PLL_CON0		0xc130
+#define ISP_PLL_CON1		0xc134
+#define ISP_PLL_CON2		0xc138
+#define DISP_PLL_CON0		0xc140
+#define DISP_PLL_CON1		0xc144
+#define DISP_PLL_CON2		0xc148
+#define SRC_TOP0		0xc210
+#define SRC_TOP1		0xc214
+#define SRC_CAM			0xc220
+#define SRC_TV			0xc224
+#define SRC_MFC			0xc228
+#define SRC_G3D			0xc22c
+#define SRC_LCD			0xc234
+#define SRC_ISP			0xc238
+#define SRC_MAUDIO		0xc23c
+#define SRC_FSYS		0xc240
+#define SRC_PERIL0		0xc250
+#define SRC_PERIL1		0xc254
+#define SRC_CAM1		0xc258
+#define SRC_TOP_ISP0		0xc25c
+#define SRC_TOP_ISP1		0xc260
+#define SRC_MASK_TOP		0xc310
+#define SRC_MASK_CAM		0xc320
+#define SRC_MASK_TV		0xc324
+#define SRC_MASK_LCD		0xc334
+#define SRC_MASK_ISP		0xc338
+#define SRC_MASK_MAUDIO		0xc33c
+#define SRC_MASK_FSYS		0xc340
+#define SRC_MASK_PERIL0		0xc350
+#define SRC_MASK_PERIL1		0xc354
+#define DIV_TOP			0xc510
+#define DIV_CAM			0xc520
+#define DIV_TV			0xc524
+#define DIV_MFC			0xc528
+#define DIV_G3D			0xc52c
+#define DIV_LCD			0xc534
+#define DIV_ISP			0xc538
+#define DIV_MAUDIO		0xc53c
+#define DIV_FSYS0		0xc540
+#define DIV_FSYS1		0xc544
+#define DIV_FSYS2		0xc548
+#define DIV_PERIL0		0xc550
+#define DIV_PERIL1		0xc554
+#define DIV_PERIL2		0xc558
+#define DIV_PERIL3		0xc55c
+#define DIV_PERIL4		0xc560
+#define DIV_PERIL5		0xc564
+#define DIV_CAM1		0xc568
+#define DIV_TOP_ISP1		0xc56c
+#define DIV_TOP_ISP0		0xc570
+#define CLKDIV2_RATIO		0xc580
+#define GATE_SCLK_CAM		0xc820
+#define GATE_SCLK_TV		0xc824
+#define GATE_SCLK_MFC		0xc828
+#define GATE_SCLK_G3D		0xc82c
+#define GATE_SCLK_LCD		0xc834
+#define GATE_SCLK_MAUDIO	0xc83c
+#define GATE_SCLK_FSYS		0xc840
+#define GATE_SCLK_PERIL		0xc850
+#define GATE_IP_CAM		0xc920
+#define GATE_IP_TV		0xc924
+#define GATE_IP_MFC		0xc928
+#define GATE_IP_G3D		0xc92c
+#define GATE_IP_LCD		0xc934
+#define GATE_IP_FSYS		0xc940
+#define GATE_IP_PERIL		0xc950
+#define GATE_BLOCK		0xc970
+#define APLL_LOCK		0x14000
+#define APLL_CON0		0x14100
+#define SRC_CPU			0x14200
+#define DIV_CPU0		0x14500
+#define DIV_CPU1		0x14504
+
+enum exynos4415_plls {
+	apll, epll, g3d_pll, isp_pll, disp_pll,
+	nr_plls,
+};
+
+/*
+ * Support for CMU save/restore across system suspends
+ */
+#ifdef CONFIG_PM_SLEEP
+static struct samsung_clk_reg_dump *clk_regs;
+static struct samsung_clk_provider *ctx;
+
+static unsigned long cmu_clk_regs[] __initdata = {
+	SRC_LEFTBUS,
+	DIV_LEFTBUS,
+	GATE_IP_LEFTBUS,
+	GATE_IP_IMAGE,
+	SRC_RIGHTBUS,
+	DIV_RIGHTBUS,
+	GATE_IP_RIGHTBUS,
+	GATE_IP_PERIR,
+	EPLL_LOCK,
+	G3D_PLL_LOCK,
+	DISP_PLL_LOCK,
+	ISP_PLL_LOCK,
+	EPLL_CON0,
+	EPLL_CON1,
+	EPLL_CON2,
+	G3D_PLL_CON0,
+	G3D_PLL_CON1,
+	G3D_PLL_CON2,
+	ISP_PLL_CON0,
+	ISP_PLL_CON1,
+	ISP_PLL_CON2,
+	DISP_PLL_CON0,
+	DISP_PLL_CON1,
+	DISP_PLL_CON2,
+	SRC_TOP0,
+	SRC_TOP1,
+	SRC_CAM,
+	SRC_TV,
+	SRC_MFC,
+	SRC_G3D,
+	SRC_LCD,
+	SRC_ISP,
+	SRC_MAUDIO,
+	SRC_FSYS,
+	SRC_PERIL0,
+	SRC_PERIL1,
+	SRC_CAM1,
+	SRC_TOP_ISP0,
+	SRC_TOP_ISP1,
+	SRC_MASK_TOP,
+	SRC_MASK_CAM,
+	SRC_MASK_TV,
+	SRC_MASK_LCD,
+	SRC_MASK_ISP,
+	SRC_MASK_MAUDIO,
+	SRC_MASK_FSYS,
+	SRC_MASK_PERIL0,
+	SRC_MASK_PERIL1,
+	DIV_TOP,
+	DIV_CAM,
+	DIV_TV,
+	DIV_MFC,
+	DIV_G3D,
+	DIV_LCD,
+	DIV_ISP,
+	DIV_MAUDIO,
+	DIV_FSYS0,
+	DIV_FSYS1,
+	DIV_FSYS2,
+	DIV_PERIL0,
+	DIV_PERIL1,
+	DIV_PERIL2,
+	DIV_PERIL3,
+	DIV_PERIL4,
+	DIV_PERIL5,
+	DIV_CAM1,
+	DIV_TOP_ISP1,
+	DIV_TOP_ISP0,
+	CLKDIV2_RATIO,
+	GATE_SCLK_CAM,
+	GATE_SCLK_TV,
+	GATE_SCLK_MFC,
+	GATE_SCLK_G3D,
+	GATE_SCLK_LCD,
+	GATE_SCLK_MAUDIO,
+	GATE_SCLK_FSYS,
+	GATE_SCLK_PERIL,
+	GATE_IP_CAM,
+	GATE_IP_TV,
+	GATE_IP_MFC,
+	GATE_IP_G3D,
+	GATE_IP_LCD,
+	GATE_IP_FSYS,
+	GATE_IP_PERIL,
+	GATE_BLOCK,
+	APLL_LOCK,
+	APLL_CON0,
+	SRC_CPU,
+	DIV_CPU0,
+	DIV_CPU1,
+};
+
+static int exynos_clk_suspend(void)
+{
+	samsung_clk_save(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
+
+	return 0;
+}
+
+static void exynos_clk_resume(void)
+{
+	samsung_clk_restore(ctx->reg_base, clk_regs, ARRAY_SIZE(cmu_clk_regs));
+}
+
+static struct syscore_ops exynos_clk_syscore_ops = {
+	.suspend = exynos_clk_suspend,
+	.resume = exynos_clk_resume,
+};
+
+static void exynos_clk_sleep_init(void)
+{
+	clk_regs = samsung_clk_alloc_reg_dump(cmu_clk_regs,
+						ARRAY_SIZE(cmu_clk_regs));
+	if (!clk_regs) {
+		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
+		goto err;
+	}
+
+	register_syscore_ops(&exynos_clk_syscore_ops);
+
+	return;
+err:
+	if (clk_regs)
+		kfree(clk_regs);
+}
+#else
+static inline void exynos_clk_sleep_init(void) { }
+#endif
+
+/* list of all parent clock list */
+PNAME(mout_g3d_pllsrc_p)	= { "fin_pll", };
+
+PNAME(mout_apll_p)		= { "fin_pll", "fout_apll", };
+PNAME(mout_g3d_pll_p)		= { "fin_pll", "fout_g3d_pll", };
+PNAME(mout_isp_pll_p)		= { "fin_pll", "fout_isp_pll", };
+PNAME(mout_disp_pll_p)		= { "fin_pll", "fout_disp_pll", };
+
+PNAME(mout_mpll_user_p)		= { "fin_pll", "div_mpll_pre", };
+PNAME(mout_epll_p)		= { "fin_pll", "fout_epll", };
+PNAME(mout_core_p)		= { "mout_apll", "mout_mpll_user_c", };
+PNAME(mout_hpm_p)		= { "mout_apll", "mout_mpll_user_c", };
+
+PNAME(mout_ebi_p)		= { "div_aclk_200", "div_aclk_160", };
+PNAME(mout_ebi_1_p)		= { "mout_ebi", "mout_g3d_pll", };
+
+PNAME(mout_gdl_p)		= { "mout_mpll_user_l", };
+PNAME(mout_gdr_p)		= { "mout_mpll_user_r", };
+
+PNAME(mout_aclk_266_p)		= { "mout_mpll_user_t", "mout_g3d_pll", };
+
+PNAME(group_epll_g3dpll_p)	= { "mout_epll", "mout_g3d_pll" };
+PNAME(group_sclk_p)		= { "xxti", "xusbxti",
+				    "none", "mout_isp_pll",
+				    "none", "none", "div_mpll_pre",
+				    "mout_epll", "mout_g3d_pll", };
+PNAME(group_spdif_p)		= { "mout_audio0", "mout_audio1",
+				    "mout_audio2", "spdif_extclk", };
+PNAME(group_sclk_audio2_p)	= { "audiocdclk2", "none",
+				    "none", "mout_isp_pll",
+				    "mout_disp_pll", "xusbxti",
+				    "div_mpll_pre", "mout_epll",
+				    "mout_g3d_pll", };
+PNAME(group_sclk_audio1_p)	= { "audiocdclk1", "none",
+				    "none", "mout_isp_pll",
+				    "mout_disp_pll", "xusbxti",
+				    "div_mpll_pre", "mout_epll",
+				    "mout_g3d_pll", };
+PNAME(group_sclk_audio0_p)	= { "audiocdclk0", "none",
+				    "none", "mout_isp_pll",
+				    "mout_disp_pll", "xusbxti",
+				    "div_mpll_pre", "mout_epll",
+				    "mout_g3d_pll", };
+PNAME(group_fimc_lclk_p)	= { "xxti", "xusbxti",
+				    "none", "mout_isp_pll",
+				    "none", "mout_disp_pll",
+				    "mout_mpll_user_t", "mout_epll",
+				    "mout_g3d_pll", };
+PNAME(group_sclk_fimd0_p)	= { "xxti", "xusbxti",
+				    "m_bitclkhsdiv4_4l", "mout_isp_pll",
+				    "mout_disp_pll", "sclk_hdmiphy",
+				    "div_mpll_pre", "mout_epll",
+				    "mout_g3d_pll", };
+PNAME(mout_hdmi_p)		= { "sclk_pixel", "sclk_hdmiphy" };
+PNAME(mout_mfc_p)		= { "mout_mfc_0", "mout_mfc_1" };
+PNAME(mout_g3d_p)		= { "mout_g3d_0", "mout_g3d_1" };
+PNAME(mout_jpeg_p)		= { "mout_jpeg_0", "mout_jpeg_1" };
+PNAME(mout_jpeg1_p)		= { "mout_epll", "mout_g3d_pll" };
+PNAME(group_aclk_isp0_300_p)	= { "mout_isp_pll", "div_mpll_pre" };
+PNAME(group_aclk_isp0_400_user_p) = { "fin_pll", "div_aclk_400_mcuisp" };
+PNAME(group_aclk_isp0_300_user_p) = { "fin_pll", "mout_aclk_isp0_300" };
+PNAME(group_aclk_isp1_300_user_p) = { "fin_pll", "mout_aclk_isp1_300" };
+PNAME(group_mout_mpll_user_t_p)	= { "mout_mpll_user_t" };
+
+static struct samsung_fixed_factor_clock fixed_factor_clks[] __initdata = {
+	/* HACK: fin_pll hardcoded to xusbxti until detection is implemented. */
+	FFACTOR(CLK_FIN_PLL, "fin_pll", "xusbxti", 1, 1, 0),
+};
+
+static struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
+	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
+};
+
+static struct samsung_mux_clock mux_clks[] __initdata = {
+	/*
+	 * NOTE: Following table is sorted by register address in ascending
+	 * order and then bitfield shift in descending order, as it is done
+	 * in the User's Manual. When adding new entries, please make sure
+	 * that the order is preserved, to avoid merge conflicts and make
+	 * further work with defined data easier.
+	 */
+
+	/* SRC_LEFTBUS */
+	MUX(CLK_MOUT_MPLL_USER_L, "mout_mpll_user_l", mout_mpll_user_p,
+		SRC_LEFTBUS, 4, 1),
+	MUX(CLK_MOUT_GDL, "mout_gdl", mout_gdl_p, SRC_LEFTBUS, 0, 1),
+
+	/* SRC_RIGHTBUS */
+	MUX(CLK_MOUT_MPLL_USER_R, "mout_mpll_user_r", mout_mpll_user_p,
+		SRC_RIGHTBUS, 4, 1),
+	MUX(CLK_MOUT_GDR, "mout_gdr", mout_gdr_p, SRC_RIGHTBUS, 0, 1),
+
+	/* SRC_TOP0 */
+	MUX(CLK_MOUT_EBI, "mout_ebi", mout_ebi_p, SRC_TOP0, 28, 1),
+	MUX(CLK_MOUT_ACLK_200, "mout_aclk_200", group_mout_mpll_user_t_p,
+		SRC_TOP0, 24, 1),
+	MUX(CLK_MOUT_ACLK_160, "mout_aclk_160", group_mout_mpll_user_t_p,
+		SRC_TOP0, 20, 1),
+	MUX(CLK_MOUT_ACLK_100, "mout_aclk_100", group_mout_mpll_user_t_p,
+		SRC_TOP0, 16, 1),
+	MUX(CLK_MOUT_ACLK_266, "mout_aclk_266", mout_aclk_266_p,
+		SRC_TOP0, 12, 1),
+	MUX(CLK_MOUT_G3D_PLL, "mout_g3d_pll", mout_g3d_pll_p,
+		SRC_TOP0, 8, 1),
+	MUX(CLK_MOUT_EPLL, "mout_epll", mout_epll_p, SRC_TOP0, 4, 1),
+	MUX(CLK_MOUT_EBI_1, "mout_ebi_1", mout_ebi_1_p, SRC_TOP0, 0, 1),
+
+	/* SRC_TOP1 */
+	MUX(CLK_MOUT_ISP_PLL, "mout_isp_pll", mout_isp_pll_p,
+		SRC_TOP1, 28, 1),
+	MUX(CLK_MOUT_DISP_PLL, "mout_disp_pll", mout_disp_pll_p,
+		SRC_TOP1, 16, 1),
+	MUX(CLK_MOUT_MPLL_USER_T, "mout_mpll_user_t", mout_mpll_user_p,
+		SRC_TOP1, 12, 1),
+	MUX(CLK_MOUT_ACLK_400_MCUISP, "mout_aclk_400_mcuisp",
+		group_mout_mpll_user_t_p, SRC_TOP1, 8, 1),
+	MUX(CLK_MOUT_G3D_PLLSRC, "mout_g3d_pllsrc", mout_g3d_pllsrc_p,
+		SRC_TOP1, 0, 1),
+
+	/* SRC_CAM */
+	MUX(CLK_MOUT_CSIS1, "mout_csis1", group_fimc_lclk_p, SRC_CAM, 28, 4),
+	MUX(CLK_MOUT_CSIS0, "mout_csis0", group_fimc_lclk_p, SRC_CAM, 24, 4),
+	MUX(CLK_MOUT_CAM1, "mout_cam1", group_fimc_lclk_p, SRC_CAM, 20, 4),
+	MUX(CLK_MOUT_FIMC3_LCLK, "mout_fimc3_lclk", group_fimc_lclk_p, SRC_CAM,
+		12, 4),
+	MUX(CLK_MOUT_FIMC2_LCLK, "mout_fimc2_lclk", group_fimc_lclk_p, SRC_CAM,
+		8, 4),
+	MUX(CLK_MOUT_FIMC1_LCLK, "mout_fimc1_lclk", group_fimc_lclk_p, SRC_CAM,
+		4, 4),
+	MUX(CLK_MOUT_FIMC0_LCLK, "mout_fimc0_lclk", group_fimc_lclk_p, SRC_CAM,
+		0, 4),
+
+	/* SRC_TV */
+	MUX(CLK_MOUT_HDMI, "mout_hdmi", mout_hdmi_p, SRC_TV, 0, 1),
+
+	/* SRC_MFC */
+	MUX(CLK_MOUT_MFC, "mout_mfc", mout_mfc_p, SRC_MFC, 8, 1),
+	MUX(CLK_MOUT_MFC_1, "mout_mfc_1", group_epll_g3dpll_p, SRC_MFC, 4, 1),
+	MUX(CLK_MOUT_MFC_0, "mout_mfc_0", group_mout_mpll_user_t_p, SRC_MFC, 0,
+		1),
+
+	/* SRC_G3D */
+	MUX(CLK_MOUT_G3D, "mout_g3d", mout_g3d_p, SRC_G3D, 8, 1),
+	MUX(CLK_MOUT_G3D_1, "mout_g3d_1", group_epll_g3dpll_p, SRC_G3D, 4, 1),
+	MUX(CLK_MOUT_G3D_0, "mout_g3d_0", group_mout_mpll_user_t_p, SRC_G3D, 0,
+		1),
+
+	/* SRC_LCD */
+	MUX(CLK_MOUT_MIPI0, "mout_mipi0", group_fimc_lclk_p, SRC_LCD, 12, 4),
+	MUX(CLK_MOUT_FIMD0, "mout_fimd0", group_sclk_fimd0_p, SRC_LCD, 0, 4),
+
+	/* SRC_ISP */
+	MUX(CLK_MOUT_TSADC_ISP, "mout_tsadc_isp", group_fimc_lclk_p, SRC_ISP,
+		16, 4),
+	MUX(CLK_MOUT_UART_ISP, "mout_uart_isp", group_fimc_lclk_p, SRC_ISP,
+		12, 4),
+	MUX(CLK_MOUT_SPI1_ISP, "mout_spi1_isp", group_fimc_lclk_p, SRC_ISP,
+		8, 4),
+	MUX(CLK_MOUT_SPI0_ISP, "mout_spi0_isp", group_fimc_lclk_p, SRC_ISP,
+		4, 4),
+	MUX(CLK_MOUT_PWM_ISP, "mout_pwm_isp", group_fimc_lclk_p, SRC_ISP,
+		0, 4),
+
+	/* SRC_MAUDIO */
+	MUX(CLK_MOUT_AUDIO0, "mout_audio0", group_sclk_audio0_p, SRC_MAUDIO,
+		0,4),
+
+	/* SRC_FSYS */
+	MUX(CLK_MOUT_TSADC, "mout_tsadc", group_sclk_p, SRC_FSYS, 28, 4),
+	MUX(CLK_MOUT_MMC2, "mout_mmc2", group_sclk_p, SRC_FSYS, 8, 4),
+	MUX(CLK_MOUT_MMC1, "mout_mmc1", group_sclk_p, SRC_FSYS, 4, 4),
+	MUX(CLK_MOUT_MMC0, "mout_mmc0", group_sclk_p, SRC_FSYS, 0, 4),
+
+	/* SRC_PERIL0 */
+	MUX(CLK_MOUT_UART3, "mout_uart3", group_sclk_p, SRC_PERIL0, 12, 4),
+	MUX(CLK_MOUT_UART2, "mout_uart2", group_sclk_p, SRC_PERIL0, 8, 4),
+	MUX(CLK_MOUT_UART1, "mout_uart1", group_sclk_p, SRC_PERIL0, 4, 4),
+	MUX(CLK_MOUT_UART0, "mout_uart0", group_sclk_p, SRC_PERIL0, 0, 4),
+
+	/* SRC_PERIL1 */
+	MUX(CLK_MOUT_SPI2, "mout_spi2", group_sclk_p, SRC_PERIL1, 24, 4),
+	MUX(CLK_MOUT_SPI1, "mout_spi1", group_sclk_p, SRC_PERIL1, 20, 4),
+	MUX(CLK_MOUT_SPI0, "mout_spi0", group_sclk_p, SRC_PERIL1, 16, 4),
+	MUX(CLK_MOUT_SPDIF, "mout_spdif", group_spdif_p, SRC_PERIL1, 8, 4),
+	MUX(CLK_MOUT_AUDIO2, "mout_audio2", group_sclk_audio2_p, SRC_PERIL1,
+		4, 4),
+	MUX(CLK_MOUT_AUDIO1, "mout_audio1", group_sclk_audio1_p, SRC_PERIL1,
+		0, 4),
+
+	/* SRC_CPU */
+	MUX(CLK_MOUT_MPLL_USER_C, "mout_mpll_user_c", mout_mpll_user_p,
+		SRC_CPU, 24, 1),
+	MUX(CLK_MOUT_HPM, "mout_hpm", mout_hpm_p, SRC_CPU, 20, 1),
+	MUX_F(CLK_MOUT_CORE, "mout_core", mout_core_p, SRC_CPU, 16, 1, 0,
+		CLK_MUX_READ_ONLY),
+	MUX_F(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
+		CLK_SET_RATE_PARENT, 0),
+
+	/* SRC_CAM1 */
+	MUX(CLK_MOUT_PXLASYNC_CSIS1_FIMC, "mout_pxlasync_csis1",
+		group_fimc_lclk_p, SRC_CAM1, 20, 1),
+	MUX(CLK_MOUT_PXLASYNC_CSIS0_FIMC, "mout_pxlasync_csis0",
+		group_fimc_lclk_p, SRC_CAM1, 16, 1),
+	MUX(CLK_MOUT_JPEG, "mout_jpeg", mout_jpeg_p, SRC_CAM1, 8, 1),
+	MUX(CLK_MOUT_JPEG1, "mout_jpeg_1", mout_jpeg1_p, SRC_CAM1, 4, 1),
+	MUX(CLK_MOUT_JPEG0, "mout_jpeg_0", group_mout_mpll_user_t_p, SRC_CAM1,
+		0, 1),
+
+	/* SRC_TOP_ISP0 */
+	MUX(CLK_MOUT_ACLK_ISP0_300, "mout_aclk_isp0_300",
+		group_aclk_isp0_300_p, SRC_TOP_ISP0, 8, 1),
+	MUX(CLK_MOUT_ACLK_ISP0_400, "mout_aclk_isp0_400_user",
+		group_aclk_isp0_400_user_p, SRC_TOP_ISP0, 4, 1),
+	MUX(CLK_MOUT_ACLK_ISP0_300_USER, "mout_aclk_isp0_300_user",
+		group_aclk_isp0_300_user_p, SRC_TOP_ISP0, 0, 1),
+
+	/* SRC_TOP_ISP1 */
+	MUX(CLK_MOUT_ACLK_ISP1_300, "mout_aclk_isp1_300",
+		group_aclk_isp0_300_p, SRC_TOP_ISP1, 4, 1),
+	MUX(CLK_MOUT_ACLK_ISP1_300_USER, "mout_aclk_isp1_300_user",
+		group_aclk_isp1_300_user_p, SRC_TOP_ISP1, 0, 1),
+};
+
+static struct samsung_div_clock div_clks[] __initdata = {
+	/*
+	 * NOTE: Following table is sorted by register address in ascending
+	 * order and then bitfield shift in descending order, as it is done
+	 * in the User's Manual. When adding new entries, please make sure
+	 * that the order is preserved, to avoid merge conflicts and make
+	 * further work with defined data easier.
+	 */
+
+	/* DIV_LEFTBUS */
+	DIV(CLK_DIV_GPL, "div_gpl", "div_gdl", DIV_LEFTBUS, 4, 3),
+	DIV(CLK_DIV_GDL, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 4),
+
+	/* DIV_RIGHTBUS */
+	DIV(CLK_DIV_GPR, "div_gpr", "div_gdr", DIV_RIGHTBUS, 4, 3),
+	DIV(CLK_DIV_GDR, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 4),
+
+	/* DIV_TOP */
+	DIV(CLK_DIV_ACLK_400_MCUISP, "div_aclk_400_mcuisp",
+		"mout_aclk_400_mcuisp", DIV_TOP, 24, 3),
+	DIV(CLK_DIV_EBI, "div_ebi", "mout_ebi_1", DIV_TOP, 16, 3),
+	DIV(CLK_DIV_ACLK_200, "div_aclk_200", "mout_aclk_200", DIV_TOP, 12, 3),
+	DIV(CLK_DIV_ACLK_160, "div_aclk_160", "mout_aclk_160", DIV_TOP, 8, 3),
+	DIV(CLK_DIV_ACLK_100, "div_aclk_100", "mout_aclk_100", DIV_TOP, 4, 4),
+	DIV(CLK_DIV_ACLK_266, "div_aclk_266", "mout_aclk_266", DIV_TOP, 0, 3),
+
+	/* DIV_CAM */
+	DIV(CLK_DIV_CSIS1, "div_csis1", "mout_csis1", DIV_CAM, 28, 4),
+	DIV(CLK_DIV_CSIS0, "div_csis0", "mout_csis0", DIV_CAM, 24, 4),
+	DIV(CLK_DIV_CAM1, "div_cam1", "mout_cam1", DIV_CAM, 20, 4),
+	DIV(CLK_DIV_FIMC3_LCLK, "div_fimc3_lclk", "mout_fimc3_lclk", DIV_CAM,
+		12, 4),
+	DIV(CLK_DIV_FIMC2_LCLK, "div_fimc2_lclk", "mout_fimc2_lclk", DIV_CAM,
+		8, 4),
+	DIV(CLK_DIV_FIMC1_LCLK, "div_fimc1_lclk", "mout_fimc1_lclk", DIV_CAM,
+		4, 4),
+	DIV(CLK_DIV_FIMC0_LCLK, "div_fimc0_lclk", "mout_fimc0_lclk", DIV_CAM,
+		0, 4),
+
+	/* DIV_TV */
+	DIV(CLK_DIV_TV_BLK, "div_tv_blk", "mout_g3d_pll", DIV_TV, 0, 4),
+
+	/* DIV_MFC */
+	DIV(CLK_DIV_MFC, "div_mfc", "mout_mfc", DIV_MFC, 0, 4),
+
+	/* DIV_G3D */
+	DIV(CLK_DIV_G3D, "div_g3d", "mout_g3d", DIV_G3D, 0, 4),
+
+	/* DIV_LCD */
+	DIV_F(CLK_DIV_MIPI0_PRE, "div_mipi0_pre", "div_mipi0", DIV_LCD, 20, 4,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_MIPI0, "div_mipi0", "mout_mipi0", DIV_LCD, 16, 4),
+	DIV(CLK_DIV_FIMD0, "div_fimd0", "mout_fimd0", DIV_LCD, 0, 4),
+
+	/* DIV_ISP */
+	DIV(CLK_DIV_UART_ISP, "div_uart_isp", "mout_uart_isp", DIV_ISP, 28, 4),
+	DIV_F(CLK_DIV_SPI1_ISP_PRE, "div_spi1_isp_pre", "div_spi1_isp",
+		DIV_ISP, 20, 8, CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_SPI1_ISP, "div_spi1_isp", "mout_spi1_isp", DIV_ISP, 16, 4),
+	DIV_F(CLK_DIV_SPI0_ISP_PRE, "div_spi0_isp_pre", "div_spi0_isp",
+		DIV_ISP, 8, 8, CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_SPI0_ISP, "div_spi0_isp", "mout_spi0_isp", DIV_ISP, 4, 4),
+	DIV(CLK_DIV_PWM_ISP, "div_pwm_isp", "mout_pwm_isp", DIV_ISP, 0, 4),
+
+	/* DIV_MAUDIO */
+	DIV(CLK_DIV_PCM0, "div_pcm0", "div_audio0", DIV_MAUDIO, 4, 8),
+	DIV(CLK_DIV_AUDIO0, "div_audio0", "mout_audio0", DIV_MAUDIO, 0, 4),
+
+	/* DIV_FSYS0 */
+	DIV_F(CLK_DIV_TSADC_PRE, "div_tsadc_pre", "div_tsadc", DIV_FSYS0, 8, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_TSADC, "div_tsadc", "mout_tsadc", DIV_FSYS0, 0, 4),
+
+	/* DIV_FSYS1 */
+	DIV_F(CLK_DIV_MMC1_PRE, "div_mmc1_pre", "div_mmc1", DIV_FSYS1, 24, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_MMC1, "div_mmc1", "mout_mmc1", DIV_FSYS1, 16, 4),
+	DIV_F(CLK_DIV_MMC0_PRE, "div_mmc0_pre", "div_mmc0", DIV_FSYS1, 8, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_MMC0, "div_mmc0", "mout_mmc0", DIV_FSYS1, 0, 4),
+
+	/* DIV_FSYS2 */
+	DIV_F(CLK_DIV_MMC2_PRE, "div_mmc2_pre", "div_mmc2", DIV_FSYS2, 8, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV_F(CLK_DIV_MMC2_PRE, "div_mmc2", "mout_mmc2", DIV_FSYS2, 0, 4,
+		CLK_SET_RATE_PARENT, 0),
+
+	/* DIV_PERIL0 */
+	DIV(CLK_DIV_UART3, "div_uart3", "mout_uart3", DIV_PERIL0, 12, 4),
+	DIV(CLK_DIV_UART2, "div_uart2", "mout_uart2", DIV_PERIL0, 8, 4),
+	DIV(CLK_DIV_UART1, "div_uart1", "mout_uart1", DIV_PERIL0, 4, 4),
+	DIV(CLK_DIV_UART0, "div_uart0", "mout_uart0", DIV_PERIL0, 0, 4),
+
+	/* DIV_PERIL1 */
+	DIV_F(CLK_DIV_SPI1_PRE, "div_spi1_pre", "div_spi1", DIV_PERIL1, 24, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_SPI1, "div_spi1", "mout_spi1", DIV_PERIL1, 16, 4),
+	DIV_F(CLK_DIV_SPI0_PRE, "div_spi0_pre", "div_spi0", DIV_PERIL1, 8, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_SPI0, "div_spi0", "mout_spi0", DIV_PERIL1, 0, 4),
+
+	/* DIV_PERIL2 */
+	DIV_F(CLK_DIV_SPI2_PRE, "div_spi2_pre", "div_spi2", DIV_PERIL2, 8, 8,
+		CLK_SET_RATE_PARENT, 0),
+	DIV(CLK_DIV_SPI2, "div_spi2", "mout_spi2", DIV_PERIL2, 0, 4),
+
+	/* DIV_PERIL4 */
+	DIV(CLK_DIV_PCM2, "div_pcm2", "div_audio2", DIV_PERIL4, 20, 8),
+	DIV(CLK_DIV_AUDIO2, "div_audio2", "mout_audio2", DIV_PERIL4, 16, 4),
+	DIV(CLK_DIV_PCM1, "div_pcm1", "div_audio1", DIV_PERIL4, 20, 8),
+	DIV(CLK_DIV_AUDIO1, "div_audio1", "mout_audio1", DIV_PERIL4, 0, 4),
+
+	/* DIV_PERIL5 */
+	DIV(CLK_DIV_I2S1, "div_i2s1", "div_audio1", DIV_PERIL5, 0, 6),
+
+	/* DIV_CAM1 */
+	DIV(CLK_DIV_PXLASYNC_CSIS1_FIMC, "div_pxlasync_csis1_fimc",
+		"mout_pxlasync_csis1", DIV_CAM1, 24, 4),
+	DIV(CLK_DIV_PXLASYNC_CSIS0_FIMC, "div_pxlasync_csis0_fimc",
+		"mout_pxlasync_csis0", DIV_CAM1, 20, 4),
+	DIV(CLK_DIV_JPEG, "div_jpeg", "mout_jpeg", DIV_CAM1, 0, 4),
+
+	/* DIV_CPU0 */
+	DIV(CLK_DIV_CORE2, "div_core2", "div_core", DIV_CPU0, 28, 3),
+	DIV_F(CLK_DIV_APLL, "div_apll", "mout_apll", DIV_CPU0, 24, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+	DIV(CLK_DIV_PCLK_DBG, "div_pclk_dbg", "div_core2", DIV_CPU0, 20, 3),
+	DIV(CLK_DIV_ATB, "div_atb", "div_core2", DIV_CPU0, 16, 3),
+	DIV(CLK_DIV_PERIPH, "div_periph", "div_core2", DIV_CPU0, 12, 3),
+	DIV(CLK_DIV_COREM1, "div_corem1", "div_core2", DIV_CPU0, 8, 3),
+	DIV(CLK_DIV_COREM0, "div_corem0", "div_core2", DIV_CPU0, 4, 3),
+	DIV_F(CLK_DIV_CORE, "div_core", "mout_core", DIV_CPU0, 0, 3,
+		CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
+
+	/* DIV_CPU1 */
+	DIV(CLK_DIV_HPM, "div_hpm", "div_copy", DIV_CPU1, 4, 3),
+	DIV(CLK_DIV_COPY, "div_copy", "mout_hpm", DIV_CPU1, 0, 3),
+};
+
+static struct samsung_gate_clock gate_clks[] __initdata = {
+	/*
+	 * NOTE: Following table is sorted by register address in ascending
+	 * order and then bitfield shift in descending order, as it is done
+	 * in the User's Manual. When adding new entries, please make sure
+	 * that the order is preserved, to avoid merge conflicts and make
+	 * further work with defined data easier.
+	 */
+
+	/* GATE_IP_LEFTBUS */
+	GATE(CLK_ASYNC_G3D, "async_g3d", "div_aclk_100", GATE_IP_LEFTBUS, 6,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_MFCL, "async_mfcl", "div_aclk_100", GATE_IP_LEFTBUS, 4,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_TVX, "async_tvx", "div_aclk_100", GATE_IP_LEFTBUS, 3,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PPMULEFT, "ppmuleft", "div_aclk_100", GATE_IP_LEFTBUS, 1,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_GPIO_LEFT, "gpio_left", "div_aclk_100", GATE_IP_LEFTBUS, 0,
+		CLK_IGNORE_UNUSED, 0),
+
+	/* GATE_IP_IMAGE */
+	GATE(CLK_PPMUIMAGE, "ppmuimage", "div_aclk_100", GATE_IP_IMAGE,
+		9, 0, 0),
+	GATE(CLK_QEMDMA2, "qe_mdma2", "div_aclk_100", GATE_IP_IMAGE,
+		8, 0, 0),
+	GATE(CLK_QEROTATOR, "qe_rotator", "div_aclk_100", GATE_IP_IMAGE,
+		7, 0, 0),
+	GATE(CLK_SMMUMDMA2, "smmu_mdam2", "div_aclk_100", GATE_IP_IMAGE,
+		5, 0, 0),
+	GATE(CLK_SMMUROTATOR, "smmu_rotator", "div_aclk_100", GATE_IP_IMAGE,
+		4, 0, 0),
+	GATE(CLK_MDMA2, "mdma2", "div_aclk_100", GATE_IP_IMAGE, 2, 0, 0),
+	GATE(CLK_ROTATOR, "rotator", "div_aclk_100", GATE_IP_IMAGE, 1, 0, 0),
+
+	/* GATE_IP_RIGHTBUS */
+	GATE(CLK_ASYNC_ISPMX, "async_ispmx", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_MAUDIOX, "async_maudiox", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 7, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_MFCR, "async_mfcr", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_FSYSD, "async_fsysd", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_LCD0X, "async_lcd0x", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ASYNC_CAMX, "async_camx", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PPMURIGHT, "ppmuright", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_GPIO_RIGHT, "gpio_right", "div_aclk_100",
+		GATE_IP_RIGHTBUS, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* GATE_IP_PERIR */
+	GATE(CLK_ANTIRBK_APBIF, "antirbk_apbif", "div_aclk_100",
+		GATE_IP_PERIR, 24, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_EFUSE_WRITER_APBIF, "efuse_writer_apbif", "div_aclk_100",
+		GATE_IP_PERIR, 23, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_MONOCNT, "monocnt", "div_aclk_100", GATE_IP_PERIR, 22,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC6, "tzpc6", "div_aclk_100", GATE_IP_PERIR, 21,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PROVISIONKEY1, "provisionkey1", "div_aclk_100",
+		GATE_IP_PERIR, 20, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PROVISIONKEY0, "provisionkey0", "div_aclk_100",
+		GATE_IP_PERIR, 19, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CMU_ISPPART, "cmu_isppart", "div_aclk_100", GATE_IP_PERIR, 18,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TMU_APBIF, "tmu_apbif", "div_aclk_100",
+		GATE_IP_PERIR, 17, 0, 0),
+	GATE(CLK_KEYIF, "keyif", "div_aclk_100", GATE_IP_PERIR, 16, 0, 0),
+	GATE(CLK_RTC, "rtc", "div_aclk_100", GATE_IP_PERIR, 15, 0, 0),
+	GATE(CLK_WDT, "wdt", "div_aclk_100", GATE_IP_PERIR, 14, 0, 0),
+	GATE(CLK_MCT, "mct", "div_aclk_100", GATE_IP_PERIR, 13, 0, 0),
+	GATE(CLK_SECKEY, "seckey", "div_aclk_100", GATE_IP_PERIR, 12,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_HDMI_CEC, "hdmi_cec", "div_aclk_100", GATE_IP_PERIR, 11,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC5, "tzpc5", "div_aclk_100", GATE_IP_PERIR, 10,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC4, "tzpc4", "div_aclk_100", GATE_IP_PERIR, 9,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC3, "tzpc3", "div_aclk_100", GATE_IP_PERIR, 8,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC2, "tzpc2", "div_aclk_100", GATE_IP_PERIR, 7,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC1, "tzpc1", "div_aclk_100", GATE_IP_PERIR, 6,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_TZPC0, "tzpc0", "div_aclk_100", GATE_IP_PERIR, 5,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CMU_COREPART, "cmu_corepart", "div_aclk_100", GATE_IP_PERIR, 4,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CMU_TOPPART, "cmu_toppart", "div_aclk_100", GATE_IP_PERIR, 3,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PMU_APBIF, "pmu_apbif", "div_aclk_100", GATE_IP_PERIR, 2,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_SYSREG, "sysreg", "div_aclk_100", GATE_IP_PERIR, 1,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_CHIP_ID, "chip_id", "div_aclk_100", GATE_IP_PERIR, 0,
+		CLK_IGNORE_UNUSED, 0),
+
+	/* GATE_SCLK_CAM - non-completed */
+	GATE(CLK_SCLK_PXLAYSNC_CSIS1_FIMC, "sclk_pxlasync_csis1_fimc",
+		"div_pxlasync_csis1_fimc", GATE_SCLK_CAM, 11,
+		CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PXLAYSNC_CSIS0_FIMC, "sclk_pxlasync_csis0_fimc",
+		"div_pxlasync_csis0_fimc", GATE_SCLK_CAM, 10, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_JPEG, "sclk_jpeg", "div_jpeg",
+		GATE_SCLK_CAM, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_CSIS1, "sclk_csis1", "div_csis1",
+		GATE_SCLK_CAM, 7, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_CSIS0, "sclk_csis0", "div_csis0",
+		GATE_SCLK_CAM, 6, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_CAM1, "sclk_cam1", "div_cam1",
+		GATE_SCLK_CAM, 5, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_FIMC3_LCLK, "sclk_fimc3_lclk", "div_fimc3_lclk",
+		GATE_SCLK_CAM, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_FIMC2_LCLK, "sclk_fimc2_lclk", "div_fimc2_lclk",
+		GATE_SCLK_CAM, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_FIMC1_LCLK, "sclk_fimc1_lclk", "div_fimc1_lclk",
+		GATE_SCLK_CAM, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_FIMC0_LCLK, "sclk_fimc0_lclk", "div_fimc0_lclk",
+		GATE_SCLK_CAM, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_TV */
+	GATE(CLK_SCLK_PIXEL, "sclk_pixel", "div_tv_blk",
+		GATE_SCLK_TV, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi",
+		GATE_SCLK_TV, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MIXER, "sclk_mixer", "div_tv_blk",
+		GATE_SCLK_TV, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_MFC */
+	GATE(CLK_SCLK_MFC, "sclk_mfc", "div_mfc",
+		GATE_SCLK_MFC, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_G3D */
+	GATE(CLK_SCLK_G3D, "sclk_g3d", "div_g3d",
+		GATE_SCLK_G3D, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_LCD */
+	GATE(CLK_SCLK_MIPIDPHY4L, "sclk_mipidphy4l", "div_mipi0",
+		GATE_SCLK_LCD, 4, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MIPI0, "sclk_mipi0", "div_mipi0_pre",
+		GATE_SCLK_LCD, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MDNIE0, "sclk_mdnie0", "div_fimd0",
+		GATE_SCLK_LCD, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_FIMD0, "sclk_fimd0", "div_fimd0",
+		GATE_SCLK_LCD, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_MAUDIO */
+	GATE(CLK_SCLK_PCM0, "sclk_pcm0", "div_pcm0",
+		GATE_SCLK_MAUDIO, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_AUDIO0, "sclk_audio0", "div_audio0",
+		GATE_SCLK_MAUDIO, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_FSYS */
+	GATE(CLK_SCLK_TSADC, "sclk_tsadc", "div_tsadc_pre",
+		GATE_SCLK_FSYS, 9, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_EBI, "sclk_ebi", "div_ebi",
+		GATE_SCLK_FSYS, 6, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC2, "sclk_mmc2", "div_mmc2_pre",
+		GATE_SCLK_FSYS, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC1, "sclk_mmc1", "div_mmc1_pre",
+		GATE_SCLK_FSYS, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MMC0, "sclk_mmc0", "div_mmc0_pre",
+		GATE_SCLK_FSYS, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_SCLK_PERIL */
+	GATE(CLK_SCLK_I2S, "sclk_i2s1", "div_i2s1",
+		GATE_SCLK_PERIL, 18, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PCM2, "sclk_pcm2", "div_pcm2",
+		GATE_SCLK_PERIL, 16, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_PCM1, "sclk_pcm1", "div_pcm1",
+		GATE_SCLK_PERIL, 15, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_AUDIO2, "sclk_audio2", "div_audio2",
+		GATE_SCLK_PERIL, 14, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_AUDIO1, "sclk_audio1", "div_audio1",
+		GATE_SCLK_PERIL, 13, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "mout_spdif",
+		GATE_SCLK_PERIL, 10, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI2, "sclk_spi2", "div_spi2_pre",
+		GATE_SCLK_PERIL, 8, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI1, "sclk_spi1", "div_spi1_pre",
+		GATE_SCLK_PERIL, 7, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_SPI0, "sclk_spi0", "div_spi0_pre",
+		GATE_SCLK_PERIL, 6, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART3, "sclk_uart3", "div_uart3",
+		GATE_SCLK_PERIL, 3, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART2, "sclk_uart2", "div_uart2",
+		GATE_SCLK_PERIL, 2, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART1, "sclk_uart1", "div_uart1",
+		GATE_SCLK_PERIL, 1, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_UART0, "sclk_uart0", "div_uart0",
+		GATE_SCLK_PERIL, 0, CLK_SET_RATE_PARENT, 0),
+
+	/* GATE_IP_CAM */
+	GATE(CLK_SMMUFIMC_LITE2, "smmufimc_lite2", "div_aclk_160", GATE_IP_CAM, 22,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_FIMC_LITE2, "fimc_lite2", "div_aclk_160", GATE_IP_CAM, 20,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PIXELASYNCM1, "pixelasyncm1", "div_aclk_160", GATE_IP_CAM, 18,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PIXELASYNCM0, "pixelasyncm0", "div_aclk_160", GATE_IP_CAM, 17,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PPMUCAMIF, "ppmucamif", "div_aclk_160", GATE_IP_CAM, 16,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_SMMUJPEG, "smmujpeg", "div_aclk_160", GATE_IP_CAM, 11, 0, 0),
+	GATE(CLK_SMMUFIMC3, "smmufimc3", "div_aclk_160", GATE_IP_CAM, 10, 0, 0),
+	GATE(CLK_SMMUFIMC2, "smmufimc2", "div_aclk_160", GATE_IP_CAM, 9, 0, 0),
+	GATE(CLK_SMMUFIMC1, "smmufimc1", "div_aclk_160", GATE_IP_CAM, 8, 0, 0),
+	GATE(CLK_SMMUFIMC0, "smmufimc0", "div_aclk_160", GATE_IP_CAM, 7, 0, 0),
+	GATE(CLK_JPEG, "jpeg", "div_aclk_160", GATE_IP_CAM, 6, 0, 0),
+	GATE(CLK_CSIS1, "csis1", "div_aclk_160", GATE_IP_CAM, 5, 0, 0),
+	GATE(CLK_CSIS0, "csis0", "div_aclk_160", GATE_IP_CAM, 4, 0, 0),
+	GATE(CLK_FIMC3, "fimc3", "div_aclk_160", GATE_IP_CAM, 3, 0, 0),
+	GATE(CLK_FIMC2, "fimc2", "div_aclk_160", GATE_IP_CAM, 2, 0, 0),
+	GATE(CLK_FIMC1, "fimc1", "div_aclk_160", GATE_IP_CAM, 1, 0, 0),
+	GATE(CLK_FIMC0, "fimc0", "div_aclk_160", GATE_IP_CAM, 0, 0, 0),
+
+	/* GATE_IP_TV */
+	GATE(CLK_PPMUTV, "ppmutv", "div_aclk_100", GATE_IP_TV, 5, 0, 0),
+	GATE(CLK_SMMUTV, "smmutv", "div_aclk_100", GATE_IP_TV, 4, 0, 0),
+	GATE(CLK_HDMI, "hdmi", "div_aclk_100", GATE_IP_TV, 3, 0, 0),
+	GATE(CLK_MIXER, "mixer", "div_aclk_100", GATE_IP_TV, 1, 0, 0),
+	GATE(CLK_VP, "vp", "div_aclk_100", GATE_IP_TV, 0, 0, 0),
+
+	/* GATE_IP_MFC */
+	GATE(CLK_PPMUMFC_R, "ppmumfc_r", "div_aclk_200", GATE_IP_MFC, 4,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PPMUMFC_L, "ppmumfc_l", "div_aclk_200", GATE_IP_MFC, 3,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_SMMUMFC_R, "smmumfc_r", "div_aclk_200", GATE_IP_MFC, 2, 0, 0),
+	GATE(CLK_SMMUMFC_L, "smmumfc_l", "div_aclk_200", GATE_IP_MFC, 1, 0, 0),
+	GATE(CLK_MFC, "mfc", "div_aclk_200", GATE_IP_MFC, 0, 0, 0),
+
+	/* GATE_IP_G3D */
+	GATE(CLK_PPMUG3D, "ppmug3d", "div_aclk_200", GATE_IP_G3D, 1,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_G3D, "g3d", "div_aclk_200", GATE_IP_G3D, 0, 0, 0),
+
+	/* GATE_IP_LCD */
+	GATE(CLK_PPMULCD0, "ppmulcd0", "div_aclk_160", GATE_IP_LCD, 5,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_SMMUFIMD0, "smmufimd0", "div_aclk_160", GATE_IP_LCD, 4, 0, 0),
+	GATE(CLK_DSIM0, "dsim0", "div_aclk_160", GATE_IP_LCD, 3, 0, 0),
+	GATE(CLK_SMIES, "smies", "div_aclk_160", GATE_IP_LCD, 2, 0, 0),
+	GATE(CLK_MIE0, "mie0", "div_aclk_160", GATE_IP_LCD, 1, 0, 0),
+	GATE(CLK_FIMD0, "fimd0", "div_aclk_160", GATE_IP_LCD, 0, 0, 0),
+
+	/* GATE_IP_FSYS */
+	GATE(CLK_TSADC, "tsadc", "div_aclk_200", GATE_IP_FSYS, 20, 0, 0),
+	GATE(CLK_PPMUFILE, "ppmufile", "div_aclk_200", GATE_IP_FSYS, 17,
+		CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_NFCON, "nfcon", "div_aclk_200", GATE_IP_FSYS, 16, 0, 0),
+	GATE(CLK_USBDEVICE, "usbdevice", "div_aclk_200", GATE_IP_FSYS, 13, 0, 0),
+	GATE(CLK_USBHOST, "usbhost", "div_aclk_200", GATE_IP_FSYS, 12, 0, 0),
+	GATE(CLK_SROMC, "sromc", "div_aclk_200", GATE_IP_FSYS, 11, 0, 0),
+	GATE(CLK_SDMMC2, "sdmmc2", "div_aclk_200", GATE_IP_FSYS, 7, 0, 0),
+	GATE(CLK_SDMMC1, "sdmmc1", "div_aclk_200", GATE_IP_FSYS, 6, 0, 0),
+	GATE(CLK_SDMMC0, "sdmmc0", "div_aclk_200", GATE_IP_FSYS, 5, 0, 0),
+	GATE(CLK_PDMA1, "pdma1", "div_aclk_200", GATE_IP_FSYS, 1, 0, 0),
+	GATE(CLK_PDMA0, "pdma0", "div_aclk_200", GATE_IP_FSYS, 0, 0, 0),
+
+	/* GATE_IP_PERIL */
+	GATE(CLK_SPDIF, "spdif", "div_aclk_100", GATE_IP_PERIL, 26, 0, 0),
+	GATE(CLK_PWM, "pwm", "div_aclk_100", GATE_IP_PERIL, 24, 0, 0),
+	GATE(CLK_PCM2, "pcm2", "div_aclk_100", GATE_IP_PERIL, 23, 0, 0),
+	GATE(CLK_PCM1, "pcm1", "div_aclk_100", GATE_IP_PERIL, 22, 0, 0),
+	GATE(CLK_I2S1, "i2s1", "div_aclk_100", GATE_IP_PERIL, 20, 0, 0),
+	GATE(CLK_SPI2, "spi2", "div_aclk_100", GATE_IP_PERIL, 18, 0, 0),
+	GATE(CLK_SPI1, "spi1", "div_aclk_100", GATE_IP_PERIL, 17, 0, 0),
+	GATE(CLK_SPI0, "spi0", "div_aclk_100", GATE_IP_PERIL, 16, 0, 0),
+	GATE(CLK_I2CHDMI, "i2chdmi", "div_aclk_100", GATE_IP_PERIL, 14, 0, 0),
+	GATE(CLK_I2C7, "i2c7", "div_aclk_100", GATE_IP_PERIL, 13, 0, 0),
+	GATE(CLK_I2C6, "i2c6", "div_aclk_100", GATE_IP_PERIL, 12, 0, 0),
+	GATE(CLK_I2C5, "i2c5", "div_aclk_100", GATE_IP_PERIL, 11, 0, 0),
+	GATE(CLK_I2C4, "i2c4", "div_aclk_100", GATE_IP_PERIL, 10, 0, 0),
+	GATE(CLK_I2C3, "i2c3", "div_aclk_100", GATE_IP_PERIL, 9, 0, 0),
+	GATE(CLK_I2C2, "i2c2", "div_aclk_100", GATE_IP_PERIL, 8, 0, 0),
+	GATE(CLK_I2C1, "i2c1", "div_aclk_100", GATE_IP_PERIL, 7, 0, 0),
+	GATE(CLK_I2C0, "i2c0", "div_aclk_100", GATE_IP_PERIL, 6, 0, 0),
+	GATE(CLK_UART3, "uart3", "div_aclk_100", GATE_IP_PERIL, 3, 0, 0),
+	GATE(CLK_UART2, "uart2", "div_aclk_100", GATE_IP_PERIL, 2, 0, 0),
+	GATE(CLK_UART1, "uart1", "div_aclk_100", GATE_IP_PERIL, 1, 0, 0),
+	GATE(CLK_UART0, "uart0", "div_aclk_100", GATE_IP_PERIL, 0, 0, 0),
+};
+
+/*
+ * APLL & MPLL & BPLL & ISP_PLL & DISP_PLL & G3D_PLL
+ */
+static struct samsung_pll_rate_table exynos4415_pll_rates[] = {
+	PLL_35XX_RATE(1600000000, 400, 3,  1),
+	PLL_35XX_RATE(1500000000, 250, 2,  1),
+	PLL_35XX_RATE(1400000000, 175, 3,  0),
+	PLL_35XX_RATE(1300000000, 325, 3,  1),
+	PLL_35XX_RATE(1200000000, 400, 4,  1),
+	PLL_35XX_RATE(1100000000, 275, 3,  1),
+	PLL_35XX_RATE(1066000000, 533, 6,  1),
+	PLL_35XX_RATE(1000000000, 250, 3,  1),
+	PLL_35XX_RATE( 960000000, 320, 4,  1),
+	PLL_35XX_RATE( 900000000, 300, 4,  1),
+	PLL_35XX_RATE( 850000000, 425, 6,  1),
+	PLL_35XX_RATE( 800000000, 200, 3,  1),
+	PLL_35XX_RATE( 700000000, 175, 3,  1),
+	PLL_35XX_RATE( 667000000, 667, 12, 1),
+	PLL_35XX_RATE( 600000000, 400, 4,  2),
+	PLL_35XX_RATE( 550000000, 275, 3,  2),
+	PLL_35XX_RATE( 533000000, 533, 6,  2),
+	PLL_35XX_RATE( 520000000, 260, 3,  2),
+	PLL_35XX_RATE( 500000000, 250, 3,  2),
+	PLL_35XX_RATE( 440000000, 220, 3,  2),
+	PLL_35XX_RATE( 400000000, 200, 3,  2),
+	PLL_35XX_RATE( 350000000, 175, 3,  2),
+	PLL_35XX_RATE( 300000000, 300, 3,  3),
+	PLL_35XX_RATE( 266000000, 266, 3,  3),
+	PLL_35XX_RATE( 200000000, 200, 3,  3),
+	PLL_35XX_RATE( 160000000, 160, 3,  3),
+	PLL_35XX_RATE( 100000000, 200, 3,  4),
+	{ /* sentinel */ }
+};
+
+/* EPLL */
+static struct samsung_pll_rate_table exynos4415_epll_rates[] = {
+	PLL_36XX_RATE(800000000, 200, 3, 1,     0),
+	PLL_36XX_RATE(288000000,  96, 2, 2,     0),
+	PLL_36XX_RATE(192000000, 128, 2, 3,     0),
+	PLL_36XX_RATE(144000000,  96, 2, 3,     0),
+	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),
+	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),
+	PLL_36XX_RATE( 80750011, 107, 2, 4, 43691),
+	PLL_36XX_RATE( 73728004,  98, 2, 4, 19923),
+	PLL_36XX_RATE( 67987602, 271, 3, 5, 62285),
+	PLL_36XX_RATE( 65911004, 175, 2, 5, 49982),
+	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),
+	PLL_36XX_RATE( 49152003, 131, 2, 5,  4719),
+	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),
+	PLL_36XX_RATE( 45250000, 181, 3, 5,     0),
+	{ /* sentinel */ }
+};
+
+static struct samsung_pll_clock plls[nr_plls] __initdata = {
+	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
+			APLL_LOCK, APLL_CON0, NULL),
+	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
+			EPLL_LOCK, EPLL_CON0, NULL),
+	[g3d_pll] = PLL(pll_35xx, CLK_FOUT_G3D_PLL, "fout_g3d_pll",
+			"mout_g3d_pllsrc", G3D_PLL_LOCK, G3D_PLL_CON0, NULL),
+	[isp_pll] = PLL(pll_35xx, CLK_FOUT_ISP_PLL, "fout_isp_pll", "fin_pll",
+			ISP_PLL_LOCK, ISP_PLL_CON0, NULL),
+	[disp_pll] = PLL(pll_35xx, CLK_FOUT_DISP_PLL, "fout_disp_pll",
+			"fin_pll", DISP_PLL_LOCK, DISP_PLL_CON0, NULL),
+};
+
+static void __init exynos4415_cmu_init(struct device_node *np)
+{
+	void __iomem *reg_base;
+
+	reg_base = of_iomap(np, 0);
+	if (!reg_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
+	if (!ctx)
+		panic("%s: unable to allocate context.\n", __func__);
+
+	plls[apll].rate_table = exynos4415_pll_rates;
+	plls[epll].rate_table = exynos4415_epll_rates;
+	plls[g3d_pll].rate_table = exynos4415_pll_rates;
+	plls[isp_pll].rate_table = exynos4415_pll_rates;
+	plls[disp_pll].rate_table = exynos4415_pll_rates;
+
+	samsung_clk_register_fixed_factor(ctx, fixed_factor_clks,
+					ARRAY_SIZE(fixed_factor_clks));
+	samsung_clk_register_fixed_rate(ctx, fixed_rate_clks,
+					ARRAY_SIZE(fixed_rate_clks));
+
+	samsung_clk_register_pll(ctx, plls, ARRAY_SIZE(plls), reg_base);
+	samsung_clk_register_mux(ctx, mux_clks, ARRAY_SIZE(mux_clks));
+	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
+	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
+
+	exynos_clk_sleep_init();
+
+	samsung_clk_of_add_provider(np, ctx);
+}
+CLK_OF_DECLARE(exynos4415_cmu, "samsung,exynos4415-cmu", exynos4415_cmu_init);
+
+/*
+ * CMU DMC
+ */
+
+#define MPLL_LOCK		0x008
+#define MPLL_CON0		0x108
+#define MPLL_CON1		0x10c
+#define MPLL_CON2		0x110
+#define BPLL_LOCK		0x118
+#define BPLL_CON0		0x218
+#define BPLL_CON1		0x21c
+#define BPLL_CON2		0x220
+#define SRC_DMC			0x300
+#define DIV_DMC1		0x504
+
+enum exynos4415_dmc_plls {
+	mpll, bpll,
+	nr_dmc_plls,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static struct samsung_clk_reg_dump *dmc_clk_regs;
+static struct samsung_clk_provider *dmc_ctx;
+
+static unsigned long dmc_save_list[] __initdata = {
+	MPLL_LOCK,
+	MPLL_CON0,
+	MPLL_CON1,
+	MPLL_CON2,
+	BPLL_LOCK,
+	BPLL_CON0,
+	BPLL_CON1,
+	BPLL_CON2,
+	SRC_DMC,
+	DIV_DMC1,
+};
+
+static int dmc_clk_suspend(void)
+{
+	samsung_clk_save(dmc_ctx->reg_base,
+				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
+	return 0;
+}
+
+static void dmc_clk_resume(void)
+{
+	samsung_clk_restore(dmc_ctx->reg_base,
+				dmc_clk_regs, ARRAY_SIZE(dmc_save_list));
+}
+
+static struct syscore_ops dmc_clk_syscore_ops = {
+	.suspend = dmc_clk_suspend,
+	.resume = dmc_clk_resume,
+};
+
+static void dmc_clk_sleep_init(void)
+{
+	dmc_clk_regs = samsung_clk_alloc_reg_dump(dmc_save_list,
+						ARRAY_SIZE(dmc_save_list));
+	if (!dmc_clk_regs) {
+		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
+		return;
+	}
+
+	register_syscore_ops(&dmc_clk_syscore_ops);
+}
+#else
+static inline void dmc_clk_sleep_init(void) { }
+#endif /* CONFIG_PM_SLEEP */
+
+PNAME(mout_mpll_p)		= { "fin_pll", "fout_mpll", };
+PNAME(mout_bpll_p)		= { "fin_pll", "fout_bpll", };
+PNAME(mbpll_p)			= { "mout_mpll", "mout_bpll", };
+
+static struct samsung_mux_clock dmc_mux_clks[] __initdata = {
+	MUX(CLK_DMC_MOUT_MPLL, "mout_mpll", mout_mpll_p, SRC_DMC, 12, 1),
+	MUX(CLK_DMC_MOUT_BPLL, "mout_bpll", mout_bpll_p, SRC_DMC, 10, 1),
+	MUX(CLK_DMC_MOUT_DPHY, "mout_dphy", mbpll_p, SRC_DMC, 8, 1),
+	MUX(CLK_DMC_MOUT_DMC_BUS, "mout_dmc_bus", mbpll_p, SRC_DMC, 4, 1),
+};
+
+static struct samsung_div_clock dmc_div_clks[] __initdata = {
+	DIV(CLK_DMC_DIV_DMC, "div_dmc", "div_dmc_pre", DIV_DMC1, 27, 3),
+	DIV(CLK_DMC_DIV_DPHY, "div_dphy", "mout_dphy", DIV_DMC1, 23, 3),
+	DIV(CLK_DMC_DIV_DMC_PRE, "div_dmc_pre", "mout_dmc_bus",
+		DIV_DMC1, 19, 2),
+	DIV(CLK_DMC_DIV_DMCP, "div_dmcp", "div_dmcd", DIV_DMC1, 15, 3),
+	DIV(CLK_DMC_DIV_DMCD, "div_dmcd", "div_dmc", DIV_DMC1, 11, 3),
+	DIV(CLK_DMC_DIV_MPLL_PRE, "div_mpll_pre", "mout_mpll", DIV_DMC1, 8, 2),
+};
+
+static struct samsung_pll_clock dmc_plls[nr_dmc_plls] __initdata = {
+	[mpll] = PLL(pll_35xx, CLK_DMC_FOUT_MPLL, "fout_mpll", "fin_pll",
+		MPLL_LOCK, MPLL_CON0, NULL),
+	[bpll] = PLL(pll_35xx, CLK_DMC_FOUT_BPLL, "fout_bpll", "fin_pll",
+		BPLL_LOCK, BPLL_CON0, NULL),
+};
+
+static void __init exynos4415_cmu_dmc_init(struct device_node *np)
+{
+	void __iomem *reg_base;
+
+	reg_base = of_iomap(np, 0);
+	if (!reg_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	dmc_ctx = samsung_clk_init(np, reg_base, NR_CLKS_DMC);
+	if (!dmc_ctx)
+		panic("%s: unable to allocate context.\n", __func__);
+
+	dmc_plls[mpll].rate_table = exynos4415_pll_rates;
+	dmc_plls[bpll].rate_table = exynos4415_pll_rates;
+
+	samsung_clk_register_pll(dmc_ctx, dmc_plls,
+					ARRAY_SIZE(dmc_plls), reg_base);
+	samsung_clk_register_mux(dmc_ctx, dmc_mux_clks,
+					ARRAY_SIZE(dmc_mux_clks));
+	samsung_clk_register_div(dmc_ctx, dmc_div_clks,
+					ARRAY_SIZE(dmc_div_clks));
+
+	dmc_clk_sleep_init();
+
+	samsung_clk_of_add_provider(np, dmc_ctx);
+}
+CLK_OF_DECLARE(exynos4415_cmu_dmc, "samsung,exynos4415-cmu-dmc",
+		exynos4415_cmu_dmc_init);
diff --git a/include/dt-bindings/clock/exynos4415.h b/include/dt-bindings/clock/exynos4415.h
new file mode 100644
index 0000000..7eed551
--- /dev/null
+++ b/include/dt-bindings/clock/exynos4415.h
@@ -0,0 +1,360 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for Samsung Exynos4415 clock controllers.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_SAMSUNG_EXYNOS4415_CLOCK_H
+#define _DT_BINDINGS_CLOCK_SAMSUNG_EXYNOS4415_CLOCK_H
+
+/*
+ * Let each exported clock get a unique index, which is used on DT-enabled
+ * platforms to lookup the clock from a clock specifier. These indices are
+ * therefore considered an ABI and so must not be changed. This implies
+ * that new clocks should be added either in free spaces between clock groups
+ * or at the end.
+ */
+
+/*
+ * Main CMU
+ */
+
+#define CLK_OSCSEL			1
+#define CLK_FIN_PLL			2
+#define CLK_FOUT_APLL			3
+#define CLK_FOUT_MPLL			4
+#define CLK_FOUT_EPLL			5
+#define CLK_FOUT_G3D_PLL		6
+#define CLK_FOUT_ISP_PLL		7
+#define CLK_FOUT_DISP_PLL		8
+
+/* Muxes */
+#define CLK_MOUT_MPLL_USER_L		16
+#define CLK_MOUT_GDL			17
+#define CLK_MOUT_MPLL_USER_R		18
+#define CLK_MOUT_GDR			19
+#define CLK_MOUT_EBI			20
+#define CLK_MOUT_ACLK_200		21
+#define CLK_MOUT_ACLK_160		22
+#define CLK_MOUT_ACLK_100		23
+#define CLK_MOUT_ACLK_266		24
+#define CLK_MOUT_G3D_PLL		25
+#define CLK_MOUT_EPLL			26
+#define CLK_MOUT_EBI_1			27
+#define CLK_MOUT_ISP_PLL		28
+#define CLK_MOUT_DISP_PLL		29
+#define CLK_MOUT_MPLL_USER_T		30
+#define CLK_MOUT_ACLK_400_MCUISP	31
+#define CLK_MOUT_G3D_PLLSRC		32
+#define CLK_MOUT_CSIS1			33
+#define CLK_MOUT_CSIS0			34
+#define CLK_MOUT_CAM1			35
+#define CLK_MOUT_FIMC3_LCLK		36
+#define CLK_MOUT_FIMC2_LCLK		37
+#define CLK_MOUT_FIMC1_LCLK		38
+#define CLK_MOUT_FIMC0_LCLK		39
+#define CLK_MOUT_MFC			40
+#define CLK_MOUT_MFC_1			41
+#define CLK_MOUT_MFC_0			42
+#define CLK_MOUT_G3D			43
+#define CLK_MOUT_G3D_1			44
+#define CLK_MOUT_G3D_0			45
+#define CLK_MOUT_MIPI0			46
+#define CLK_MOUT_FIMD0			47
+#define CLK_MOUT_TSADC_ISP		48
+#define CLK_MOUT_UART_ISP		49
+#define CLK_MOUT_SPI1_ISP		50
+#define CLK_MOUT_SPI0_ISP		51
+#define CLK_MOUT_PWM_ISP		52
+#define CLK_MOUT_AUDIO0			53
+#define CLK_MOUT_TSADC			54
+#define CLK_MOUT_MMC2			55
+#define CLK_MOUT_MMC1			56
+#define CLK_MOUT_MMC0			57
+#define CLK_MOUT_UART3			58
+#define CLK_MOUT_UART2			59
+#define CLK_MOUT_UART1			60
+#define CLK_MOUT_UART0			61
+#define CLK_MOUT_SPI2			62
+#define CLK_MOUT_SPI1			63
+#define CLK_MOUT_SPI0			64
+#define CLK_MOUT_SPDIF			65
+#define CLK_MOUT_AUDIO2			66
+#define CLK_MOUT_AUDIO1			67
+#define CLK_MOUT_MPLL_USER_C		68
+#define CLK_MOUT_HPM			69
+#define CLK_MOUT_CORE			70
+#define CLK_MOUT_APLL			71
+#define CLK_MOUT_PXLASYNC_CSIS1_FIMC	72
+#define CLK_MOUT_PXLASYNC_CSIS0_FIMC	73
+#define CLK_MOUT_JPEG			74
+#define CLK_MOUT_JPEG1			75
+#define CLK_MOUT_JPEG0			76
+#define CLK_MOUT_ACLK_ISP0_300		77
+#define CLK_MOUT_ACLK_ISP0_400		78
+#define CLK_MOUT_ACLK_ISP0_300_USER	79
+#define CLK_MOUT_ACLK_ISP1_300		80
+#define CLK_MOUT_ACLK_ISP1_300_USER	81
+#define CLK_MOUT_HDMI			82
+
+/* Dividers */
+#define CLK_DIV_GPL			90
+#define CLK_DIV_GDL			91
+#define CLK_DIV_GPR			92
+#define CLK_DIV_GDR			93
+#define CLK_DIV_ACLK_400_MCUISP		94
+#define CLK_DIV_EBI			95
+#define CLK_DIV_ACLK_200		96
+#define CLK_DIV_ACLK_160		97
+#define CLK_DIV_ACLK_100		98
+#define CLK_DIV_ACLK_266		99
+#define CLK_DIV_CSIS1			100
+#define CLK_DIV_CSIS0			101
+#define CLK_DIV_CAM1			102
+#define CLK_DIV_FIMC3_LCLK		103
+#define CLK_DIV_FIMC2_LCLK		104
+#define CLK_DIV_FIMC1_LCLK		105
+#define CLK_DIV_FIMC0_LCLK		106
+#define CLK_DIV_TV_BLK			107
+#define CLK_DIV_MFC			108
+#define CLK_DIV_G3D			109
+#define CLK_DIV_MIPI0_PRE		110
+#define CLK_DIV_MIPI0			111
+#define CLK_DIV_FIMD0			112
+#define CLK_DIV_UART_ISP		113
+#define CLK_DIV_SPI1_ISP_PRE		114
+#define CLK_DIV_SPI1_ISP		115
+#define CLK_DIV_SPI0_ISP_PRE		116
+#define CLK_DIV_SPI0_ISP		117
+#define CLK_DIV_PWM_ISP			118
+#define CLK_DIV_PCM0			119
+#define CLK_DIV_AUDIO0			120
+#define CLK_DIV_TSADC_PRE		121
+#define CLK_DIV_TSADC			122
+#define CLK_DIV_MMC1_PRE		123
+#define CLK_DIV_MMC1			124
+#define CLK_DIV_MMC0_PRE		125
+#define CLK_DIV_MMC0			126
+#define CLK_DIV_MMC2_PRE		127
+#define CLK_DIV_MMC2			128
+#define CLK_DIV_UART3			129
+#define CLK_DIV_UART2			130
+#define CLK_DIV_UART1			131
+#define CLK_DIV_UART0			132
+#define CLK_DIV_SPI1_PRE		133
+#define CLK_DIV_SPI1			134
+#define CLK_DIV_SPI0_PRE		135
+#define CLK_DIV_SPI0			136
+#define CLK_DIV_SPI2_PRE		137
+#define CLK_DIV_SPI2			138
+#define CLK_DIV_PCM2			139
+#define CLK_DIV_AUDIO2			140
+#define CLK_DIV_PCM1			141
+#define CLK_DIV_AUDIO1			142
+#define CLK_DIV_I2S1			143
+#define CLK_DIV_PXLASYNC_CSIS1_FIMC	144
+#define CLK_DIV_PXLASYNC_CSIS0_FIMC	145
+#define CLK_DIV_JPEG			146
+#define CLK_DIV_CORE2			147
+#define CLK_DIV_APLL			148
+#define CLK_DIV_PCLK_DBG		149
+#define CLK_DIV_ATB			150
+#define CLK_DIV_PERIPH			151
+#define CLK_DIV_COREM1			152
+#define CLK_DIV_COREM0			153
+#define CLK_DIV_CORE			154
+#define CLK_DIV_HPM			155
+#define CLK_DIV_COPY			156
+
+/* Gates */
+#define CLK_ASYNC_G3D			180
+#define CLK_ASYNC_MFCL			181
+#define CLK_ASYNC_TVX			182
+#define CLK_PPMULEFT			183
+#define CLK_GPIO_LEFT			184
+#define CLK_PPMUIMAGE			185
+#define CLK_QEMDMA2			186
+#define CLK_QEROTATOR			187
+#define CLK_SMMUMDMA2			188
+#define CLK_SMMUROTATOR			189
+#define CLK_MDMA2			190
+#define CLK_ROTATOR			191
+#define CLK_ASYNC_ISPMX			192
+#define CLK_ASYNC_MAUDIOX		193
+#define CLK_ASYNC_MFCR			194
+#define CLK_ASYNC_FSYSD			195
+#define CLK_ASYNC_LCD0X			196
+#define CLK_ASYNC_CAMX			197
+#define CLK_PPMURIGHT			198
+#define CLK_GPIO_RIGHT			199
+#define CLK_ANTIRBK_APBIF		200
+#define CLK_EFUSE_WRITER_APBIF		201
+#define CLK_MONOCNT			202
+#define CLK_TZPC6			203
+#define CLK_PROVISIONKEY1		204
+#define CLK_PROVISIONKEY0		205
+#define CLK_CMU_ISPPART			206
+#define CLK_TMU_APBIF			207
+#define CLK_KEYIF			208
+#define CLK_RTC				209
+#define CLK_WDT				210
+#define CLK_MCT				211
+#define CLK_SECKEY			212
+#define CLK_HDMI_CEC			213
+#define CLK_TZPC5			214
+#define CLK_TZPC4			215
+#define CLK_TZPC3			216
+#define CLK_TZPC2			217
+#define CLK_TZPC1			218
+#define CLK_TZPC0			219
+#define CLK_CMU_COREPART		220
+#define CLK_CMU_TOPPART			221
+#define CLK_PMU_APBIF			222
+#define CLK_SYSREG			223
+#define CLK_CHIP_ID			224
+#define CLK_SMMUFIMC_LITE2		225
+#define CLK_FIMC_LITE2			226
+#define CLK_PIXELASYNCM1		227
+#define CLK_PIXELASYNCM0		228
+#define CLK_PPMUCAMIF			229
+#define CLK_SMMUJPEG			230
+#define CLK_SMMUFIMC3			231
+#define CLK_SMMUFIMC2			232
+#define CLK_SMMUFIMC1			233
+#define CLK_SMMUFIMC0			234
+#define CLK_JPEG			235
+#define CLK_CSIS1			236
+#define CLK_CSIS0			237
+#define CLK_FIMC3			238
+#define CLK_FIMC2			239
+#define CLK_FIMC1			240
+#define CLK_FIMC0			241
+#define CLK_PPMUTV			242
+#define CLK_SMMUTV			243
+#define CLK_HDMI			244
+#define CLK_MIXER			245
+#define CLK_VP				246
+#define CLK_PPMUMFC_R			247
+#define CLK_PPMUMFC_L			248
+#define CLK_SMMUMFC_R			249
+#define CLK_SMMUMFC_L			250
+#define CLK_MFC				251
+#define CLK_PPMUG3D			252
+#define CLK_G3D				253
+#define CLK_PPMULCD0			254
+#define CLK_SMMUFIMD0			255
+#define CLK_DSIM0			256
+#define CLK_SMIES			257
+#define CLK_MIE0			258
+#define CLK_FIMD0			259
+#define CLK_TSADC			260
+#define CLK_PPMUFILE			261
+#define CLK_NFCON			262
+#define CLK_USBDEVICE			263
+#define CLK_USBHOST			264
+#define CLK_SROMC			265
+#define CLK_SDMMC2			266
+#define CLK_SDMMC1			267
+#define CLK_SDMMC0			268
+#define CLK_PDMA1			269
+#define CLK_PDMA0			270
+#define CLK_SPDIF			271
+#define CLK_PWM				272
+#define CLK_PCM2			273
+#define CLK_PCM1			274
+#define CLK_I2S1			275
+#define CLK_SPI2			276
+#define CLK_SPI1			277
+#define CLK_SPI0			278
+#define CLK_I2CHDMI			279
+#define CLK_I2C7			280
+#define CLK_I2C6			281
+#define CLK_I2C5			282
+#define CLK_I2C4			283
+#define CLK_I2C3			284
+#define CLK_I2C2			285
+#define CLK_I2C1			286
+#define CLK_I2C0			287
+#define CLK_UART3			288
+#define CLK_UART2			289
+#define CLK_UART1			290
+#define CLK_UART0			291
+
+/* Special clocks */
+#define CLK_SCLK_PXLAYSNC_CSIS1_FIMC	330
+#define CLK_SCLK_PXLAYSNC_CSIS0_FIMC	331
+#define CLK_SCLK_JPEG			332
+#define CLK_SCLK_CSIS1			333
+#define CLK_SCLK_CSIS0			334
+#define CLK_SCLK_CAM1			335
+#define CLK_SCLK_FIMC3_LCLK		336
+#define CLK_SCLK_FIMC2_LCLK		337
+#define CLK_SCLK_FIMC1_LCLK		338
+#define CLK_SCLK_FIMC0_LCLK		339
+#define CLK_SCLK_PIXEL			340
+#define CLK_SCLK_HDMI			341
+#define CLK_SCLK_MIXER			342
+#define CLK_SCLK_MFC			343
+#define CLK_SCLK_G3D			344
+#define CLK_SCLK_MIPIDPHY4L		345
+#define CLK_SCLK_MIPI0			346
+#define CLK_SCLK_MDNIE0			347
+#define CLK_SCLK_FIMD0			348
+#define CLK_SCLK_PCM0			349
+#define CLK_SCLK_AUDIO0			350
+#define CLK_SCLK_TSADC			351
+#define CLK_SCLK_EBI			352
+#define CLK_SCLK_MMC2			353
+#define CLK_SCLK_MMC1			354
+#define CLK_SCLK_MMC0			355
+#define CLK_SCLK_I2S			356
+#define CLK_SCLK_PCM2			357
+#define CLK_SCLK_PCM1			358
+#define CLK_SCLK_AUDIO2			359
+#define CLK_SCLK_AUDIO1			360
+#define CLK_SCLK_SPDIF			361
+#define CLK_SCLK_SPI2			362
+#define CLK_SCLK_SPI1			363
+#define CLK_SCLK_SPI0			364
+#define CLK_SCLK_UART3			365
+#define CLK_SCLK_UART2			366
+#define CLK_SCLK_UART1			367
+#define CLK_SCLK_UART0			368
+#define CLK_SCLK_HDMIPHY		369
+
+/*
+ * Total number of clocks of main CMU.
+ * NOTE: Must be equal to last clock ID increased by one.
+ */
+#define CLK_NR_CLKS			370
+
+/*
+ * CMU DMC
+ */
+#define CLK_DMC_FOUT_MPLL		1
+#define CLK_DMC_FOUT_BPLL		2
+
+#define CLK_DMC_MOUT_MPLL		3
+#define CLK_DMC_MOUT_BPLL		4
+#define CLK_DMC_MOUT_DPHY		5
+#define CLK_DMC_MOUT_DMC_BUS		6
+
+#define CLK_DMC_DIV_DMC			7
+#define CLK_DMC_DIV_DPHY		8
+#define CLK_DMC_DIV_DMC_PRE		9
+#define CLK_DMC_DIV_DMCP		10
+#define CLK_DMC_DIV_DMCD		11
+#define CLK_DMC_DIV_MPLL_PRE		12
+
+/*
+ * Total number of clocks of CMU_DMC.
+ * NOTE: Must be equal to highest clock ID increased by one.
+ */
+#define NR_CLKS_DMC			13
+
+#endif /* _DT_BINDINGS_CLOCK_SAMSUNG_EXYNOS4415_CLOCK_H */
-- 
1.8.0

