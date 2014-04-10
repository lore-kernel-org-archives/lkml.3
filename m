Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060AbaDJJ2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:28:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35111 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaDJJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-cf-53466450916f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/27] ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of
 Exynos3250
Date: Thu, 10 Apr 2014 18:28:19 +0900
Message-id: <1397122124-15690-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQDcwxS3Y4PpvRovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpYsvAIc8FJvopnzYsZGxjX8HQxcnJICJhIbNxw
	nxnCFpO4cG89WxcjF4eQwFJGie7JU9lgilpPf2UFsYUEpjNKzDsmBFHUxCTR/OswI0iCTUBL
	Yv+LG2ANIgIBEj+OvwOzmQVuMkocex/WxcjBISwQIfHmfxFImEVAVWLLiQlgrbwCrhJH13Ww
	Q+ySk/iw5xGYzSngJvHpeyvUXleJpg/7oO5ZxS7xb3UYxBwBiW+TD7GAjJcQkJXYdADqF0mJ
	gytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzDoT/971r+D8e4B60OMyUDj
	JjJLiSbnA6MmryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUw9ou8YlBkVpvNz52V6WXDlzfrOfuF7WF9nRP32F6WuSyzo17oRdjpH2d/MN8Tdt/r
	ZWP78p36ouRF04xjPnq9F1J4r/C0QcfefMssmZXJRsrfP5qrGzJI7mmt2ar0ybDzRz2TzM8l
	tsnSkRsieU+uDp/rUGXKwLisMLVVPPrGrtzajb4/mTcrsRRnJBpqMRcVJwIA5ZLfJpACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd2AFLdggwMzzSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxpKFR5gL
	TvJVPGtezNjAuIani5GTQ0LARKL19FdWCFtM4sK99WwgtpDAdEaJeceEuhi5gOwmJonmX4cZ
	QRJsAloS+1/cACsSEQiQ+HH8HZjNLHCTUeLY+7AuRg4OYYEIiTf/i0DCLAKqEltOTABr5RVw
	lTi6roMdYpecxIc9j8BsTgE3iU/fW1kh9rpKNH3YxzaBkXcBI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOCoeia9g3FVg8UhRgEORiUe3gPLXIOFWBPLiitzDzFKcDArifBeC3YLFuJN
	SaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YMTnlcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAPjFLkTPL8uBTo66sXLC4ROsxe2CHiuvnbSZN8kpxuZHkbWnO23
	QgzPC816IrUhU/XhrLXVicZHV4ZmHpJjvXIueD/riuPqMikPO1TK87P4fXxm3Pp1bcrKA70P
	5zzwu5G+5LW2X8fUA+8me4l4v3D/5J7QW66RmK1SxZPf5uby/U28XnHSvm9KLMUZiYZazEXF
	iQDdP0lx7gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-secure SYSRAM is used for secondary CPU bring-up. This patch add
IO mapping for non-scure SYSRAM.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c           | 12 ++++++++++++
 arch/arm/mach-exynos/include/mach/map.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b134868..cad3bfd 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -35,6 +35,15 @@
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
 
+static struct map_desc exynos3250_iodesc[] __initdata = {
+	{
+		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
+		.pfn		= __phys_to_pfn(EXYNOS3_PA_SYSRAM_NS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+};
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -275,6 +284,9 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
  */
 static void __init exynos_map_io(void)
 {
+	if (soc_is_exynos3250())
+		iotable_init(exynos3250_iodesc, ARRAY_SIZE(exynos3250_iodesc));
+
 	if (soc_is_exynos4())
 		iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 7b046b5..a53981b 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -26,6 +26,7 @@
 #define EXYNOS4_PA_SYSRAM0		0x02025000
 #define EXYNOS4_PA_SYSRAM1		0x02020000
 #define EXYNOS5_PA_SYSRAM		0x02020000
+#define EXYNOS3_PA_SYSRAM_NS		0x0205F000
 #define EXYNOS4210_PA_SYSRAM_NS		0x0203F000
 #define EXYNOS4x12_PA_SYSRAM_NS		0x0204F000
 #define EXYNOS5250_PA_SYSRAM_NS		0x0204F000
-- 
1.8.0

