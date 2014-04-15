Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaDOCBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:01:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28228 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaDOB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:57 -0400
X-AuditID: cbfee68f-b7f156d00000276c-1b-534c929c1031
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 6/8] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
Date: Tue, 15 Apr 2014 10:59:50 +0900
Message-id: <1397527192-21988-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkQHfOJJ9gg/1NwhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+GSg0+SWbxfoZr1ksjs1Ywmixd+dkRgchjzXz1jB6tDT3sHn8/jWJ0ePvqhfMHneu
	7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC+CM4rJJSc3JLEst0rdL4Mp4MYu14B1XxenvHawNjI84
	uhg5OSQETCS2v93LDGGLSVy4t54NxBYSWMoosXGJCUzNu49vgOJcQPFFjBJbb01ghXCamCTe
	f33DClLFJqAlsf/FDbBuEQEFic29z8CKmAXWMktcnNQIlODgEBaIl9jRATaVRUBV4t3k/2Cb
	eQVcJVbefs8CsU1O4sOeR+wgNqeAm8Te+3+ZIS5ylVi/fzYTyEwJgVYOib+vGtkhBglIfJt8
	iAVkvoSArMSmA1DfSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgVF3
	+t+z/h2Mdw9YH2JMBho3kVlKNDkfGLV5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoFx9bwrjql1MzZxllf/faCoxGk+S8KC1ebSbYVTWqp5NVLv
	l7y4IFMzRz8xrjjyu/Gpr0+Cnutd9fPq+yeZlKvnynbHdK/7/N2zooxWf1lqqZ64dVXxrXn7
	33RJngk1WfWkevd245XBUo9E7pusCqo/l5X85O/M/h3zFYqK7c/usvgjNNNQzUpJiaU4I9FQ
	i7moOBEAQr/GUtACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd05k3yCDc4+4LL4O+kYu8WkdQeY
	LC7v17a4/uU5q8X8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy9
	84/N4tT1z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeayZt4bRo6W5h83j969JjB5/V71g9rhz
	bQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QP0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjBezWAvecVWc/t7B2sD4iKOLkZNDQsBE4t3HN2wQtpjEhXvrgWwuDiGBRYwSW29N
	YIVwmpgk3n99wwpSxSagJbH/xQ2wDhEBBYnNvc/AipgF1jJLXJzUCJTg4BAWiJfY0WECUsMi
	oCrxbvJ/ZhCbV8BVYuXt9ywQ2+QkPux5xA5icwq4Sey9/xesRgioZv3+2UwTGHkXMDKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAiO6mdSOxhXNlgcYhTgYFTi4fWY4BMsxJpYVlyZe4hR
	goNZSYT3dTJQiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVEk/OBCSevJN7Q2MTMyNLI3NDCyNic
	NGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjtX9W+aK8+n+mi53EqT/yrzt5XH1VOlDRm
	Sane3nL+ucGkhJ/ac7uFpu3s7cidqlxit1Ft1cLKpcznG8t2M9u8yn8uad2jZb3uEUvtkvdz
	Dz2/X7NPbut6HvZn2WwLhLy4mHf28yy8eXXBlnNft/Wl999SNLDY9YStzvW3afeiBQfZ8rzN
	C+2VWIozEg21mIuKEwGT9Q1yLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch decide proper lowpower mode of either a15 or a9 according to own ID
from Main ID register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..99e54e0 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -135,16 +135,22 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	int primary_part = 0;
 
 	/*
-	 * we're ready for shutdown now, so do it.
-	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
+	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
+	 * while Exynos5 is A15/Exynos3 is A7; check the CPU part
 	 * number by reading the Main ID register and then perform the
 	 * appropriate sequence for entering low power.
 	 */
-	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
-	if ((primary_part & 0xfff0) == 0xc0f0)
+	primary_part = read_cpuid_part_number();
+
+	switch (primary_part) {
+	case ARM_CPU_PART_CORTEX_A7:
+	case ARM_CPU_PART_CORTEX_A15:
 		cpu_enter_lowpower_a15();
-	else
+		break;
+	default:
 		cpu_enter_lowpower_a9();
+		break;
+	}
 
 	platform_do_lowpower(cpu, &spurious);
 
-- 
1.8.0

