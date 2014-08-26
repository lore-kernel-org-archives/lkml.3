Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaHZBb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:31:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaHZBbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:31:19 -0400
X-AuditID: cbfee68e-f79536d000000fd1-a7-53fbe36407c2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv5 3/4] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Tue, 26 Aug 2014 10:31:04 +0900
Message-id: <1409016665-3824-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWDfl8e9gg742HouGqyEWG2esZ7W4
	+/wwo8X1L89ZLdbs/8lkMf/KNVaL3gVX2SzONr1ht9j0GMi9vGsOm8Xn3iOMFjPO72OyePKw
	j82B12PnrLvsHov3vGTy2Lyk3qNvyypGj+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXx8fEP
	loJeiYovi46zNDD+Feli5OSQEDCReLviFhuELSZx4d56IJuLQ0hgKaPEpCcdTDBF37dcYYdI
	TGeU2N9whBXCaWKS2DZ5GTtIFZuAlsT+FzfARokIeErMXdjCBFLELLCHSeJd91NmkISwQLTE
	h+ZTYEUsAqoS+1ZNArN5BVwkdv68A7VOTuLDnkdgQzkFXCX+TzkD1isEVNM17xcjRM0xdolj
	C6Qh5ghIfJt8iKWLkQMoLiux6QAzRImkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1ya
	l66XnJ+7iREYK6f/PevbwXjzgPUhRgEORiUe3hvxv4OFWBPLiitzDzGaAm2YyCwlmpwPjMi8
	knhDYzMjC1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYXd9oLGk5
	Lr+v5fOET/xiq/at+eVVx/NCrPzzqaAfgcpLr1l8flNxoWLHP//ulPUr7oYEW0586h6Zo2/d
	L9c1kyN01ZzbL8J03RS/KRmL8bzPcDY++envlsCLibHaG5Rd/rGqBzNqXOu53eJbPvWzegPz
	sYdz2xglTHd5bMgvit54l3nqrdRPSizFGYmGWsxFxYkAOHt3iZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd2Ux7+DDdatY7ZouBpisXHGelaL
	u88PM1pc//Kc1WLN/p9MFvOvXGO16F1wlc3ibNMbdotNj4Hcy7vmsFl87j3CaDHj/D4miycP
	+9gceD12zrrL7rF4z0smj81L6j36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCWsYMz4+/sFS0CtR8WXRcZYGxr8iXYycHBICJhLft1xhh7DFJC7c
	W8/WxcjFISQwnVFif8MRVginiUli2+RlYFVsAloS+1/cYAOxRQQ8JeYubGECKWIW2MMk8a77
	KTNIQlggWuJD8ymwIhYBVYl9qyaB2bwCLhI7f95hglgnJ/FhzyOwoZwCrhL/p5wB6xUCquma
	94txAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsfhMegfjqgaLQ4wCHIxKPLw3
	4n8HC7EmlhVX5h5ilOBgVhLhZXgIFOJNSaysSi3Kjy8qzUktPsRoCnTVRGYp0eR8YJrIK4k3
	NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXA6DS9NVKqrcj6fZDG1aJV
	H45cm+JYpfctjWXDocsV+/akx9ww4CrSUzKKeywbviGea8Ls24qHtTeVPZ2Ys811t6H4Q7Hb
	l669Syyztreyn336JIvFbvGaq53KHTzptuZLX2+dPak+SUVgCs9Fu++6O/+4P5C53vJncZr1
	lXvvDGsEBZfarf8cpMRSnJFoqMVcVJwIAGoVzwHbAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for TRIM_RELOAD feature at Exynos3250. The TMu of
Exynos3250 has two TRIMINFO_CON register and must need to set RELOAD bit
before reading TRIMINFO register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c | 9 +++++++--
 drivers/thermal/samsung/exynos_tmu_data.h | 7 +++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 0a13f2b..8aeca00 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -95,6 +95,9 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
+	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
+	.triminfo_ctrl_count = 2,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -161,7 +164,9 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
-	.features = (TMU_SUPPORT_EMULATION | \
+	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
+	.triminfo_reload[1] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -184,7 +189,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 05728f8..95a4404 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -57,8 +57,11 @@
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
 #define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
 
-/* Exynos5250 and Exynos4412 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON	0x14
+/*  Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
+/* Exynos5250 ,Exynos4412 and Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
 #define EXYNOS_THD_TEMP_RISE		0x50
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
-- 
1.8.0

