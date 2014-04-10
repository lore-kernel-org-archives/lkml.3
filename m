Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbaDJJiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:38:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37075 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965709AbaDJJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:52 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-ae-5346666f007e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/27] ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of
 Exynos3250
Date: Thu, 10 Apr 2014 18:37:13 +0900
Message-id: <1397122658-16013-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWDc/zS3Y4MVyPYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpYsvAIc8FJvopnzYsZGxjX8HQxcnJICJhI/N91
	hhnCFpO4cG89WxcjF4eQwFJGid1nJzPCFH1c3MgOkZjOKPH36AVmCKeJSWLx4kdsIFVsAloS
	+1/cALNFBAIkfhx/B2YzC9xklDj2PqyLkYNDWCBC4s3/IpAwi4CqxMZX58BKeAVcJc7eboZa
	JifxYc8jdhCbU8BNYuaik2A1QkA1PY8ugu2VEFjFLvF+xQxmiEECEt8mH2IBmS8hICux6QDU
	N5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmDgn/73bOIOxvsHrA8x
	JgONm8gsJZqcD4ycvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg5Hh9b3HMmfqf0pd6Dso3BpQ+Ke+/u2FJ3OOllyqDH+3aN/lUkfXyfNmC1wt2
	n5dom3o7+sGX2wyec+sO73a/7TZ1aXPoplm+i1ieaK6Kz2dK2vwq+0FD9s0TTFsT9AQ5dvDW
	fTW7l9ZYGmf8grfg0d60yZwforSUsgxLo4wNGlfe/FS3yL5toxJLcUaioRZzUXEiADBzCSuS	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd38NLdgg21r1Syuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxpKFR5gL
	TvJVPGtezNjAuIani5GTQ0LAROLj4kZ2CFtM4sK99WxdjFwcQgLTGSX+Hr3ADOE0MUksXvyI
	DaSKTUBLYv+LG2C2iECAxI/j78BsZoGbjBLH3od1MXJwCAtESLz5XwQSZhFQldj46hxYCa+A
	q8TZ282MEMvkJD7seQS2mFPATWLmopNgNUJANT2PLjJPYORdwMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4rp5J72Bc1WBxiFGAg1GJh/fAMtdgIdbEsuLK3EOMEhzMSiK814LdgoV4
	UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5HxjzeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAmDXlKaPP5NmPBG9pCyndCnxY/1Is7l9NUvu3sx3Jjyam+1+X
	nPw8J+TNiWP3uft+R626b351geMUkdOZp83MPZ5eLY9q4nF8pvDO8sLUtQUBK+/uFXthZlKq
	W9QgtW7Dvn3G51Kcy/+0uYVEV/fOO/P7k+PSlK55wdXdAoE++6xOXC6ezCq8TomlOCPRUIu5
	qDgRABcPEmXvAgAA
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

