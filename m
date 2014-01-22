Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaAVOTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:19:11 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11871 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaAVOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:19:06 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-42-52dfd35948ba
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: EXYNOS: cpuidle: Fix build error of no type of module_init
Date: Wed, 22 Jan 2014 15:18:57 +0100
Message-id: <1390400337-22850-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/xa7qRl+8HGdy/JWuxccZ6VovXLwwt
	ehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8DhweLc09bB6bl9R79G1ZxejxeZNcAEsU
	l01Kak5mWWqRvl0CV8ata8fYCjbyVXRta2VpYDzD08XIySEhYCLReOgjM4QtJnHh3no2EFtI
	YCmjxNSrWiA2r4CgxI/J91i6GDk4mAXkJY5cygYJMwuoS0yatwiolQuovI9JYtWNTWBz2ASM
	JTYvX8IGkhAR2MEosfzeZXYQh1lgGqPEkb59rCBVwgIBEs9utjOB2CwCqhIHH29ghdjmLnH2
	+Rc2kG0SAgoScybZTGDkm4XkjlkId8xCcscCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCHB+mUH4+JjVocYBTgYlXh4A3fdCxJiTSwrrsw9xCjBwawkwuux6n6QEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsYGiWOva68lbvilxl284vv2Z807lod4P3p8rYpBLPmK9D5/xjmR8uWsp7TE
	VsTbKx8Oe6dsl3X10ONjbxd55U/Z0JPaK6TymHPXCYNSe6ZPB/dsfJfps+BdsFnZjvX+94VZ
	LLoXFXyx85u96XnabY/QkEVH2xgXndso3y249OrvU0f9fBK0k+8qsRRnJBpqMRcVJwIAW2qH
	MzQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include to fix build error:
arch/arm/mach-exynos/cpuidle.c:256:1: warning: data definition has no type or storage class [enabled by default]
arch/arm/mach-exynos/cpuidle.c:256:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
arch/arm/mach-exynos/cpuidle.c:256:1: warning: parameter names (without types) in function declaration [enabled by default]
arch/arm/mach-exynos/cpuidle.c:256:1: warning: data definition has no type or storage class [enabled by default]
arch/arm/mach-exynos/cpuidle.c:256:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
arch/arm/mach-exynos/cpuidle.c:256:1: warning: parameter names (without types) in function declaration [enabled by default]
arch/arm/mach-exynos/cpuidle.c:256:1: warning: ‘exynos_cpuidle_driver_init’ defined but not used [-Wunused-function]
cc1: some warnings being treated as errors
make[1]: *** [arch/arm/mach-exynos/cpuidle.o] Error 1

Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
and was introduced by commit 35baa3369d1c (ARM: EXYNOS: convert cpuidle
driver to be a platform driver).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/cpuidle.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index f57cb91f02aa..53dc1e705b2f 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <linux/time.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 
 #include <asm/proc-fns.h>
-- 
1.7.9.5

