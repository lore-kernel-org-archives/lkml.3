Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaDOCCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:02:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60076 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaDOB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:54 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-98-534c9299c8cb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Tue, 15 Apr 2014 10:59:47 +0900
Message-id: <1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQHfmJJ9gg6cnuSz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M1Bo8ks2i/UzXrNYHJuxhNFi787JjA5CHmvmrWH0aGnuYfP4/WsSo8ffVS+YPe5c
	28PmsXlJvceVE02sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJWx90poQStfxdSP7YwNjHe5
	uxg5OSQETCQuvT7PBmGLSVy4tx7I5uIQEljKKNHdcp8VpujzruPsEIlFjBLN528yQzhNTBL3
	H7UygVSxCWhJ7H9xA2yUiICCxObeZ6wgRcwCa5klLk5qBEsIC3hIPJo9lR3EZhFQlZj/sh+s
	mVfAVeLpsRlQ6+QkPux5BFbDKeAmsff+X2YQWwioZv3+2UwgQyUEWjkkOqZMhxokIPFt8iGW
	LkYOoISsxKYDzBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwMg7
	/e/ZxB2M9w9YH2JMBho3kVlKNDkfGLl5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cDIYLTzAsPhmU9O84q6r+P1aXj8WvqjaUWZHb8Ox8PDzSvn
	/r3rO5N30v6522s45k+c62gxy2w+969FDNtbz/Qfv9YhpHz4mvS/v7stOhzZZ+n9EjaYvVov
	5IiU6RO15xk2b7V3Poh4+awzYlvxOhsnvZhFj2/yuPft4uNe/XWi/Y6dMsonP23sUWIpzkg0
	1GIuKk4EAEjfp9rSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd2Zk3yCDabPZrL4O+kYu8WkdQeY
	LC7v17a4/uU5q8X8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy9
	84/N4tT1z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeayZt4bRo6W5h83j969JjB5/V71g9rhz
	bQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QP0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjL1XQgta+SqmfmxnbGC8y93FyMkhIWAi8XnXcXYIW0ziwr31bF2MXBxCAosYJZrP
	32SGcJqYJO4/amUCqWIT0JLY/+IGG4gtIqAgsbn3GStIEbPAWmaJi5MawRLCAh4Sj2ZPBRvL
	IqAqMf9lP1gzr4CrxNNjM1gh1slJfNjzCKyGU8BNYu/9v8wgthBQzfr9s5kmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREc18+kdzCuarA4xCjAwajEwzvhnXewEGtiWXFl7iFG
	CQ5mJRHe18k+wUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0w5eSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKQWM+VsMfZ2nGV4+L238JTbZv0T14DaDFVXa
	wVpHK3VX3Q5LXZne8ck532VB8dteE7GHv69P51ils5V/+h49vyNzC6YWpD7gSZZOWxCimcD+
	+s8qf84Fmx+9lLRZZ7DO8d/a25I3v6zRtV/JPi/M9eM3bp95zrcfZzTXBezWfVZjzHLfJT1w
	6aQdSizFGYmGWsxFxYkAKjiM2y8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add memory mapping for PMU (Power Management Unit) which is used
for power control of Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Arnd Bergmann suggested that need proper driver instead of static memory mapping.
As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
for memory mapping for SYSRAM.
[1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
[2] https://lkml.org/lkml/2014/4/10/161

So, I'm going to re-implement following patch related to static memory mapping
after merged Sachin Kamat patch[1].
  ARM: EXYNOS: Add IO mapping for PMU of Exynos3250

 arch/arm/mach-exynos/exynos.c           | 5 +++++
 arch/arm/mach-exynos/include/mach/map.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index c7c9472..8f6f73d 100644
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

