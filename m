Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074AbaGPOUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:20:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14350 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383AbaGPOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:20:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-04-53c68a293923
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] ARM: EXYNOS: Remove unneeded __ref annotation for cpu_die
 function
Date: Wed, 16 Jul 2014 16:20:16 +0200
Message-id: <1405520417-15027-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
References: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7qaXceCDe5cY7HYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DK2D95EUvBV9aKn9sOMjUw/mbpYuTgkBAwkZjUGtDF
	yAlkiklcuLeerYuRi0NIYCmjxNSvx1ghnD4mifWN91lBqtgEjCU2L18CViUisINRYvm9y+wg
	CWaB54wST7+Hg9jCApESNy9OBouzCKhK7N1+F8zmFXCXeNZ+lhVinZzEyWOTwWxOAQ+J6+f/
	MYLYQkA1HU372Scw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJkX3YwLj5mdYhR
	gINRiYeXYfbRYCHWxLLiytxDjBIczEoivA7+x4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MBpf
	0b2q/qDK1VzOyyay6Kj8uvP3tLZaKN3l+hx+bvnt9y+2zTqhmD69V0BYzmD6uUkWYlnNt8Ln
	hv++uz2a7cqcfRt5MjibPuv8+KZl/Hdxf6xxZEvQrjUPb1vemxpSnKUjpTbvK1eL15d7Hxhn
	fXJyLl6fsPajyAppC5M7X3Ifz7xllmrcsUKJpTgj0VCLuag4EQCb6lzgEAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ref annotation for exynos_cpu_die() is not needed because the
function does not reference any __init/__exit symbol or call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index b0679b6d5161..6a0de7591f73 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -306,7 +306,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
  *
  * Called with IRQs disabled
  */
-static void __ref exynos_cpu_die(unsigned int cpu)
+static void exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
-- 
1.9.1

