Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965843AbaDJJmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:42:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18692 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965712AbaDJJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-de-53466670c464
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Thu, 10 Apr 2014 18:37:14 +0900
Message-id: <1397122658-16013-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkULcgzS3YYOd9FYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYPeUGa8EGror5jxsYGxgvcnQxcnJICJhIvNn8
	iAXCFpO4cG89WxcjF4eQwFJGiQkX+9lgiv7dusUEkZjOKHF3/WUop4lJ4tj+d0wgVWwCWhL7
	X9wA6xARCJD4cfwdmM0scJNR4tj7MBBbWMBD4tqseYxdjBwcLAKqEtea+EDCvAKuEks/XWOC
	WCYn8WHPI3YQm1PATWLmopNgY4SAanoeXWQG2SshsIpd4sLn22BnswgISHybfIgFZKaEgKzE
	pgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAwD/979mEHYz3
	DlgfYkwGGjeRWUo0OR8YOXkl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFi4qfDFP3ePS4+/H7NN4OWc9y5p8vcb3xwFJjA9En0dueLcsk0yjyY+
	Kplyy2nKse5Dp8WMXzx9b8TtsufG8sy+jaoqp47nZXP6baj2/6N77LaIQZONeU1RW5aP6dq4
	wpWdKowHZpq/UGr0cVZj8LI4GJlxzfDddrnpjI2X93NevPhHVIbjSp0SS3FGoqEWc1FxIgBx
	rWaRkgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2CNLdggxcHZSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxuwpN1gL
	NnBVzH/cwNjAeJGji5GTQ0LAROLfrVtMELaYxIV769m6GLk4hASmM0rcXX+ZCcJpYpI4tv8d
	WBWbgJbE/hc32EBsEYEAiR/H34HZzAI3GSWOvQ8DsYUFPCSuzZrH2MXIwcEioCpxrYkPJMwr
	4Cqx9NM1qGVyEh/2PGIHsTkF3CRmLjoJNkYIqKbn0UXmCYy8CxgZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEx9UzqR2MKxssDjEKcDAq8fAeWOYaLMSaWFZcmXuIUYKDWUmE91qwW7AQ
	b0piZVVqUX58UWlOavEhxmSgoyYyS4km5wNjPq8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGP1O3fmQc69GM6/LZYr9gv9H3E/P3p4d4LZm42QLf4477tJM
	kx9M9AstKwso+PA/YMqMrT8Pni1lmSD7Jnf6I85dsjnMxq3zDRO38Tukefk0zDG1MP5d+/dy
	ZeXiqSbXzA0XKG+R3LjtE5NRxz3XDSt3dgpslDCJ9gh7q5atVqK1qKlN+2InixJLcUaioRZz
	UXEiAD7bA53vAgAA
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

