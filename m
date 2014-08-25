Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaHYHbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:31:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaHYHar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:30:47 -0400
X-AuditID: cbfee68f-f797f6d000001173-ee-53fae61ab005
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv4 2/4] thermal: exynos: Add support for many TRIMINFO_CTRL
 registers
Date: Mon, 25 Aug 2014 16:30:23 +0900
Message-id: <1408951825-2639-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
References: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkRFfq2a9gg1UrFC0aroZY3H1+mNHi
	+pfnrBbzj5xjtViz/yeTxfwr11gt+t8sZLXoXXCVzeJs0xt2i02PgWKXd81hs/jce4TRYsb5
	fUwWS69fZLKYMH0ti0Xr3iPsFk8e9rE5CHqsmbeG0eNyXy+Tx85Zd9k9Fu95yeSxaVUnm8fm
	JfUefVtWMXocv7GdyePzJrkAzigum5TUnMyy1CJ9uwSujLXHfzMWfNOvOL70L3MD41GNLkZO
	DgkBE4llm86wQdhiEhfurQezhQSWMkq0rGGDqbkyaQ5zFyMXUHw6o8SRuStZIJwmJolT01+w
	g1SxCWhJ7H9xA6xDRMBTYu7CFiaQImaBKcwSpzqOsoIkhAXCJN5unwpmswioSlycOw/M5hVw
	kTi5o4kRYp2cxIc9j4CGcnBwCrhKnF1kB3GRi8TfaWvArpAQ+Msuse7NMzaIOQIS3yYfYgGp
	lxCQldh0gBlijKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERhvp/89
	69/BePeA9SFGAQ5GJR7eFZy/goVYE8uKK3MPMZoCbZjILCWanA+M6rySeENjMyMLUxNTYyNz
	SzMlcd6FUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB63FIxO8wfdvTdL+cNUs1N9x1+
	H2TcWRJ5rcaHTyDTfOdEKcZ+qcJk34i17fMXylz4+P/zzB27g09+1N13Nyimr5NJ+V5GRfLk
	to17Txx+yGx5Yuq+j5oqRu2himniTywtXB/+676a8yTd80hk8NSytbP83HZKLWjQkLx72jY+
	7RmD2ATn3bJKLMUZiYZazEXFiQDxzgkPsgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQV2pZ7+CDc5NE7douBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFvOvXGO16H+zkNWid8FVNouzTW/YLTY9Bopd3jWHzeJz7xFGixnn
	9zFZLL1+kcliwvS1LBate4+wWzx52MfmIOixZt4aRo/Lfb1MHjtn3WX3WLznJZPHplWdbB6b
	l9R79G1Zxehx/MZ2Jo/Pm+QCOKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGasPf6bseCbfsXxpX+ZGxiPanQxcnJICJhIXJk0hxnCFpO4cG89WxcjF4eQwHRGiSNzV7JA
	OE1MEqemv2AHqWIT0JLY/+IGG4gtIuApMXdhCxNIEbPAFGaJUx1HWUESwgJhEm+3TwWzWQRU
	JS7OnQdm8wq4SJzc0cQIsU5O4sOeR0BDOTg4BVwlzi6yAwkLAZX8nbaGeQIj7wJGhlWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwfH8TGoH48oGi0OMAhyMSjy8Kzl/BQuxJpYVV+YeYpTg
	YFYS4Z1yHCjEm5JYWZValB9fVJqTWnyI0RToqInMUqLJ+cBUk1cSb2hsYmZkaWRuaGFkbK4k
	znug1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgTHwrPEJnbD3HzvPF19k641Y4Pvjw9RMuwm135rm
	OaVtndLfwC6yZ99zpRN+Yl6y9dkOJRe0Zt47EXxN6eTKqJjFQmpMnP01n19OKa7++IAl1/zj
	8mNbPvuvKtZNb2mpClr2yWuLjeHjB1fVU8Rzbi75k5nBr77tNmeM+bRkXZXEFh6+gAOM/Uos
	xRmJhlrMRcWJABAja379AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support many TRIMINFO_CTRL registers if specific Exynos SoC
has one more TRIMINFO_CTRL registers. Also this patch uses proper 'RELOAD'
shift/mask bit operation to set RELOAD feature instead of static value.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.h |  1 +
 drivers/thermal/samsung/exynos_tmu.c            | 23 ++++++++++++++++++++---
 drivers/thermal/samsung/exynos_tmu.h            |  9 +++++++--
 drivers/thermal/samsung/exynos_tmu_data.c       |  5 ++++-
 drivers/thermal/samsung/exynos_tmu_data.h       |  3 +++
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 3eb2ed9..b211976 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -28,6 +28,7 @@
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
 #define MAX_THRESHOLD_LEVS 5
+#define MAX_TRIMINFO_CTRL_REG	2
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index acbff14..7234f38 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -147,7 +147,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int status, trim_info = 0, con;
+	unsigned int status, trim_info = 0, con, ctrl;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
 	int ret = 0, threshold_code, i, trigger_levs = 0;
 
@@ -164,8 +164,25 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
-		__raw_writel(1, data->base + reg->triminfo_ctrl);
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+		if (reg->triminfo_ctrl_count > MAX_TRIMINFO_CTRL_REG) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		for (i = 0; i < reg->triminfo_ctrl_count; i++) {
+			if (pdata->triminfo_reload[i]) {
+				ctrl = readl(data->base +
+						reg->triminfo_ctrl[i]);
+				ctrl &= ~(reg->triminfo_reload_mask <<
+						reg->triminfo_reload_shift);
+				ctrl |= pdata->triminfo_reload[i] <<
+						reg->triminfo_reload_shift;
+				__raw_writel(ctrl, data->base +
+						reg->triminfo_ctrl[i]);
+			}
+		}
+	}
 
 	if (pdata->cal_mode == HW_MODE)
 		goto skip_calib_data;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 1b4a644..d7674ad 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -85,8 +85,11 @@ enum soc_type {
  * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
  * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
+ * @triminfo_ctrl_count: the number of trim info controller register.
  * @triminfo_reload_shift: shift of triminfo reload enable bit in triminfo_ctrl
 	reg.
+ * @triminfo_reload_mask: mask of triminfo reload enable bit in triminfo_ctrl
+	reg.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
@@ -151,9 +154,10 @@ struct exynos_tmu_registers {
 	u32	triminfo_25_shift;
 	u32	triminfo_85_shift;
 
-	u32	triminfo_ctrl;
-	u32	triminfo_ctrl1;
+	u32	triminfo_ctrl[MAX_TRIMINFO_CTRL_REG];
+	u32	triminfo_ctrl_count;
 	u32	triminfo_reload_shift;
+	u32	triminfo_reload_mask;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
@@ -295,6 +299,7 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
+	u8 triminfo_reload[MAX_TRIMINFO_CTRL_REG];
 
 	enum calibration_type cal_type;
 	enum calibration_mode cal_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index aa8e0de..754c638 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -184,8 +184,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl_count = 1,
 	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
+	.triminfo_reload_mask = EXYNOS_TRIMINFO_RELOAD_MASK,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -252,6 +254,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 401bab7..87454f63 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -64,6 +64,9 @@
 #define EXYNOS_EMUL_CON		0x80
 
 #define EXYNOS_TRIMINFO_RELOAD_SHIFT	0
+#define EXYNOS_TRIMINFO_RELOAD_MASK	0x1
+#define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
+#define EXYNOS_TRIMINFO_RELOAD_DISABLE	0
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
-- 
1.8.0

