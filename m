Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150AbaDJJ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:29:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45458 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934899AbaDJJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:55 -0400
X-AuditID: cbfee690-b7f266d00000287c-ef-534664513a8f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Thu, 10 Apr 2014 18:28:20 +0900
Message-id: <1397122124-15690-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWDcwxS3Y4N1KDovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYPeUGa8EGror5jxsYGxgvcnQxcnBICJhINH5V
	62LkBDLFJC7cW8/WxcjFISSwlFHi5NRZ7BAJE4m7/7eyQiSmM0pM/HGcBcJpYpJo/nWYEaSK
	TUBLYv+LG2wgtohAgMSP4+/AbGaBm4wSx96HgdjCAh4S12bNA6tnEVCVmH7lAQvIFbwCrhL7
	W8MglslJfNjzCGwxp4CbxKfvrawgthBQSdOHfWDXSQisYpf4v3A9O8QcAYlvkw+xQHwjK7Hp
	ADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzDsT/97NmEH470D
	1ocYk4HGTWSWEk3OB8ZNXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwtresKPRyFp0qWH4lStfjsnLJvIqd5Z3C3TudTzy0/ucp+enRj6b9ahJM
	c1JSTDTVJ5t/cWHk4Xjw2/NkvvS0BRJTxZ5NmMYsy/rszrICwechF9YmyD7fJ/tpApPl2ys/
	py2oXXZYuJWTV+Hq3+LkFxcrdJe1bK0SUpjhPin8i/37qeqcfK4tSizFGYmGWsxFxYkAu7Sq
	gpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg2W2Fte/PGe1+Pyhhd1i
	0v0JLBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLG5JdsFutnvGax2LtzMqMDt8fmJfUe
	fVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj9pQbrAUb
	uCrmP25gbGC8yNHFyMkhIWAicff/VlYIW0ziwr31bF2MXBxCAtMZJSb+OM4C4TQxSTT/OswI
	UsUmoCWx/8UNNhBbRCBA4sfxd2A2s8BNRolj78NAbGEBD4lrs+aB1bMIqEpMv/IAaBAHB6+A
	q8T+1jCIZXISH/Y8YgexOQXcJD59bwU7QgiopOnDPrYJjLwLGBlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgRH1TPpHYyrGiwOMQpwMCrx8B5Y5hosxJpYVlyZe4hRgoNZSYT3WrBbsBBv
	SmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnAyM+ryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYxZLiem4e0551WVH2mzNP0cNlM/UtBXW+vIo+udLvu5//hUJL
	STZ3WbbdM87cP5YbrX/9GM++SUIzOmaqa64zdOBlszJVSyhKmRn14nueTpJ/kOqV3LTEOzPD
	hZPvHLvv/rtU7S1LFbPYkRu1/idvfvrjJ912ff3G2hkCoQ2PT6Tdc36fO7NIiaU4I9FQi7mo
	OBEANNTxXO4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add memory mapping for PMU (Power Management Unit) which is used
for power control of Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c           | 5 +++++
 arch/arm/mach-exynos/include/mach/map.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index cad3bfd..628e4b1 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -41,6 +41,11 @@ static struct map_desc exynos3250_iodesc[] __initdata = {
 		.pfn		= __phys_to_pfn(EXYNOS3_PA_SYSRAM_NS),
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
+	}, {
+		.virtual	= (unsigned long)S5P_VA_PMU,
+		.pfn		= __phys_to_pfn(EXYNOS3_PA_PMU),
+		.length		= SZ_64K,
+		.type		= MT_DEVICE,
 	},
 };
 
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index a53981b..4aea694 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -36,6 +36,7 @@
 #define EXYNOS4_PA_SYSCON		0x10010000
 #define EXYNOS5_PA_SYSCON		0x10050100
 
+#define EXYNOS3_PA_PMU			0x10020000
 #define EXYNOS4_PA_PMU			0x10020000
 #define EXYNOS5_PA_PMU			0x10040000
 
-- 
1.8.0

