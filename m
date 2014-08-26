Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbaHZBbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:31:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaHZBbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:31:17 -0400
X-AuditID: cbfee68e-f79536d000000fd1-9f-53fbe363ff9c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv5 2/4] thermal: exynos: Add support for many TRIMINFO_CTRL
 registers
Date: Tue, 26 Aug 2014 10:31:03 +0900
Message-id: <1409016665-3824-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRDf58e9gg31tMhYNV0MsNs5Yz2px
	9/lhRovrX56zWqzZ/5PJYv6Va6wWvQuuslmcbXrDbrHpMZB7edccNovPvUcYLWac38dk8eRh
	H5sDr8fOWXfZPRbvecnksXlJvUffllWMHsdvbGfy+LxJLoAtissmJTUnsyy1SN8ugStj6SqN
	guU6FbtOTWNuYDyl2sXIySEhYCLxq2sfG4QtJnHh3nogm4tDSGApo8TsE/uYYIrmbG5lhEhM
	Z5Q4+3grVFUTk8S2ycvYQarYBLQk9r+4ATZKRMBTYu7CFiaQImaBPUwS77qfMoMkhAXCJKbM
	PAhWxCKgKnH591awFbwCLhJPbi6GWicn8WHPI7ChnAKuEv+nnAHrFQKq6Zr3C+wMCYFj7BLd
	u5ZADRKQ+Db5EEsXIwdQQlZi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGRXnFibnFp
	Xrpecn7uJkZgrJz+96xvB+PNA9aHGAU4GJV4eG/E/w4WYk0sK67MPcRoCrRhIrOUaHI+MCLz
	SuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXHzA2OPK
	RNZf6ZFzJ70tzK2ycDLOZ2cp1T8/J+7s0avVM9Y/r5lh17/ZNfP/MY5zsdfc5Bp/GDdmcSpY
	TBd7t9vsvP/Li49XiQZNNP0eke/LGPnCaM0Dvs7ylVu0C46vuTqhcvupxaf3nfqXPVvO631A
	/KzwFelPHz+9EfourdpPo2qpkanXQSWW4oxEQy3mouJEALsS8GiQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jQd3kx7+DDZ7dEbJouBpisXHGelaL
	u88PM1pc//Kc1WLN/p9MFvOvXGO16F1wlc3ibNMbdotNj4Hcy7vmsFl87j3CaDHj/D4miycP
	+9gceD12zrrL7rF4z0smj81L6j36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCWsYM5au0ihYrlOx69Q05gbGU6pdjJwcEgImEnM2tzJC2GISF+6t
	Z+ti5OIQEpjOKHH28VYop4lJYtvkZewgVWwCWhL7X9xgA7FFBDwl5i5sYQIpYhbYwyTxrvsp
	M0hCWCBMYsrMg2BFLAKqEpd/b2UCsXkFXCSe3FzMBLFOTuLDnkdgQzkFXCX+TzkD1isEVNM1
	7xfjBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/GZ1A7GlQ0WhxgFOBiVeHhv
	xP8OFmJNLCuuzD3EKMHBrCTCy/AQKMSbklhZlVqUH19UmpNafIjRFOiqicxSosn5wCSRVxJv
	aGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQimj4mDU6qBkeOtofDbh08Pz9BrnHsq
	Pn1OlMryd90d87Nt0m74sM4p3Ppty7nmQ7HuNTdWN63mnW0jWjftgu68popfLokze+zzu7Wv
	CWxxKmQQzv3PYLS/Jlurc8ar9ev/z5Ga7lMQfMnZ+KxhWNdJJj+fyzeSdob4Tn+j9qOQQana
	7eGmhfx8R2YeuTE3W4mlOCPRUIu5qDgRAH+P47PaAgAA
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
 drivers/thermal/samsung/exynos_tmu.h            |  9 ++++-----
 drivers/thermal/samsung/exynos_tmu_data.c       |  5 +++--
 drivers/thermal/samsung/exynos_tmu_data.h       |  2 +-
 5 files changed, 21 insertions(+), 11 deletions(-)

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
index acbff14..64c702a 100644
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
 
@@ -164,8 +164,17 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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
 
 	if (pdata->cal_mode == HW_MODE)
 		goto skip_calib_data;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 1b4a644..e051540 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -85,8 +85,7 @@ enum soc_type {
  * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
  * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
- * @triminfo_reload_shift: shift of triminfo reload enable bit in triminfo_ctrl
-	reg.
+ * @triminfo_ctrl_count: the number of trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
@@ -151,9 +150,8 @@ struct exynos_tmu_registers {
 	u32	triminfo_25_shift;
 	u32	triminfo_85_shift;
 
-	u32	triminfo_ctrl;
-	u32	triminfo_ctrl1;
-	u32	triminfo_reload_shift;
+	u32	triminfo_ctrl[MAX_TRIMINFO_CTRL_REG];
+	u32	triminfo_ctrl_count;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
@@ -295,6 +293,7 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
+	u8 triminfo_reload[MAX_TRIMINFO_CTRL_REG];
 
 	enum calibration_type cal_type;
 	enum calibration_mode cal_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 8c0ada2..0a13f2b 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -184,8 +184,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
-	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -252,6 +252,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index f0979e5..05728f8 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -63,7 +63,7 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
-#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
+#define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
-- 
1.8.0

