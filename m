Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaICDKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:10:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39035 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaICDJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:08 -0400
X-AuditID: cbfee68f-f797f6d000001173-ea-540686519c32
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv6 1/2] thermal: exynos: Add support for many TRIMINFO_CTRL
 registers
Date: Wed, 03 Sep 2014 12:09:02 +0900
Message-id: <1409713743-6124-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
References: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkSDeojS3EYP1CRouGqyEWG2esZ7W4
	+/wwo8X1L89ZLdbs/8lkMf/KNVaL3gVX2SzONr1ht9j0GMi9vGsOm8Xn3iOMFjPO72OyePKw
	j82B12PnrLvsHov3vGTy2Lyk3qNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXRc2kB
	a8EGvYr2731sDYxz1bsYOTkkBEwkJu2/ygphi0lcuLeerYuRi0NIYCmjxKf+HUwwRbtXXwKz
	hQSmM0r0bw2DKGpikrjWv5sdJMEmoCWx/8UNNhBbRMBTYu7CFiaQImaBPUwS77qfMoMkhAXC
	JO7+O8fYxcjBwSKgKvGpQQDE5BVwkXi8LQBil5zEhz2PwEZyCrhKXFnwhQVir4vEl93TWEFG
	SgicYpe4dvUh2C4WAQGJb5MPsYDMkRCQldh0gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJRe
	ZKxXnJhbXJqXrpecn7uJERgnp/8969/BePeA9SFGAQ5GJR7eBQFsIUKsiWXFlbmHGE2BNkxk
	lhJNzgdGY15JvKGxmZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhiTsquzEzPlxOK0zMQZgp/wqy799qbU7WK/96mMTYeLGPhk976x/r+OmTd07UX5aLUY1hPl
	lcK3rq+8LfiiYpJPntf+awE38urnTblhKK/+t/eY4Py+iNyV+85N+n007s+51h7rV09v6gr5
	tXry6zjmzY6ecdqvLfzDnjmnlQtOdolLqT8vz1BiKc5INNRiLipOBAAMrIJOjgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9jQd3ANrYQgw/XTCwaroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTxfwr11gtehdcZbM42/SG3WLTYyD38q45bBafe48wWsw4v4/J4snD
	PjYHXo+ds+6yeyze85LJY/OSeo++LasYPY7f2M7k8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QoUoKZYk5pUChgMTiYiV9O0wTQkPc
	dC1gGiN0fUOC4HqMDNBAwhrGjJ5LC1gLNuhVtH/vY2tgnKvexcjJISFgIrF79SUmCFtM4sK9
	9WwgtpDAdEaJ/q1hXYxcQHYTk8S1/t3sIAk2AS2J/S9ugBWJCHhKzF3YwgRSxCywh0niXfdT
	ZpCEsECYxN1/5xi7GDk4WARUJT41CICYvAIuEo+3BUDskpP4sOcR2EhOAVeJKwu+sEDsdZH4
	snsa6wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgqPwmdQOxpUNFocYBTgYlXh4
	FwSwhQixJpYVV+YeYpTgYFYS4fVNBArxpiRWVqUW5ccXleakFh9iNAW6aSKzlGhyPjBB5JXE
	GxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYFRoe9bmsNT6bbO+28nk
	RXp2QS1lXDLLvb16fDwZu985LNZ4fb45WM5YfePz35vi2aS3Ldvxac5nGz5pzZL/eWJzAgs+
	ngyeWqV/LvX0tYBUo2ezL7x6r61dMiNwUUrv0cVGLnP/Sz2Z9GL10yOLgw0tgxw/TVjzPf36
	HLsd0yPM5va6rty5epsSS3FGoqEWc1FxIgCQUSgS2AIAAA==
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
 drivers/thermal/samsung/exynos_tmu.c            | 15 ++++++++++++---
 drivers/thermal/samsung/exynos_tmu.h            |  7 +++++--
 drivers/thermal/samsung/exynos_tmu_data.c       |  4 +++-
 drivers/thermal/samsung/exynos_tmu_data.h       |  1 +
 5 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index cd44719..158f5aa 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -27,6 +27,7 @@
 #define SENSOR_NAME_LEN	16
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
+#define MAX_TRIMINFO_CTRL_REG	2
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 35437df..092ab69 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -127,7 +127,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int status, trim_info = 0, con;
+	unsigned int status, trim_info = 0, con, ctrl;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
 	int ret = 0, threshold_code, i;
 
@@ -144,8 +144,17 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
-		__raw_writel(1, data->base + reg->triminfo_ctrl);
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+		for (i = 0; i < reg->triminfo_ctrl_count; i++) {
+			if (pdata->triminfo_reload[i]) {
+				ctrl = readl(data->base +
+						reg->triminfo_ctrl[i]);
+				ctrl |= pdata->triminfo_reload[i];
+				writel(ctrl, data->base +
+						reg->triminfo_ctrl[i]);
+			}
+		}
+	}
 
 	/* Save trimming info in order to perform calibration */
 	if (data->soc == SOC_ARCH_EXYNOS5440) {
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d503f35..f67203b 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -78,6 +78,7 @@ enum soc_type {
  * slightly across different exynos SOC's.
  * @triminfo_data: register containing 2 pont trimming data
  * @triminfo_ctrl: trim info controller register.
+ * @triminfo_ctrl_count: the number of trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
@@ -112,8 +113,8 @@ enum soc_type {
 struct exynos_tmu_registers {
 	u32	triminfo_data;
 
-	u32	triminfo_ctrl;
-	u32	triminfo_ctrl1;
+	u32	triminfo_ctrl[MAX_TRIMINFO_CTRL_REG];
+	u32	triminfo_ctrl_count;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
@@ -200,6 +201,7 @@ struct exynos_tmu_registers {
  * @second_point_trim: temp value of the second point trimming
  * @default_temp_offset: default temperature offset in case of no trimming
  * @test_mux; information if SoC supports test MUX
+ * @triminfo_reload: reload value to read TRIMINFO register
  * @cal_type: calibration type for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
@@ -230,6 +232,7 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
+	u8 triminfo_reload[MAX_TRIMINFO_CTRL_REG];
 
 	enum calibration_type cal_type;
 	enum soc_type type;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 177ada5..362a1e1 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -169,7 +169,8 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
@@ -231,6 +232,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index ac03b76..6b47a17 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -51,6 +51,7 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
+#define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
-- 
1.8.0

