Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965836AbaDJJlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:41:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37075 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965710AbaDJJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:57 -0400
X-AuditID: cbfee68e-b7f566d000002344-43-53466671b1b0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/27] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Thu, 10 Apr 2014 18:37:15 +0900
Message-id: <1397122658-16013-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQLcwzS3Y4M8iBYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYdrmRtWAiV8XMS9oNjMs4uhg5OSQETCQO39jJ
	CGGLSVy4t56ti5GLQ0hgKaPE1EUTGWGK/i3ewQJiCwlMZ5SY+KYEoqiJSeJA5yWwBJuAlsT+
	FzfYQGwRgQCJH8ffgdnMAjcZJY69D+ti5OAQFvCROPZAGCTMIqAqcWLJEXYQm1fAVWL7qbvs
	ELvkJD7seQRmcwq4ScxcdJINYq+rRM+ji8wgeyUElrFLvHvUyQwxSEDi2+RDLCDzJQRkJTYd
	YIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBAb96X/P+nYw3jxg
	fYgxGWjcRGYp0eR8YNTklcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGzK1/3e0Lpht9q+bPCrPl9ns9d8u11GvXv81zUo4SWPFVbMK0bX/rmn4l
	nVXMue9jmhbLlfXowcJQ/28yzDq/s5f7bP/MwnKVQXzZPGf/VWfF5+2YsuCn4Y/DRjZfWc4E
	W0b+ujnlDdOh9MUB/Bcv9d7Zdshg2ZyvP2bXKR6ep6ejyuq05eXSH0osxRmJhlrMRcWJAF5s
	eMiQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd3CNLdgg593xS2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrTLjawF
	E7kqZl7SbmBcxtHFyMkhIWAi8W/xDhYIW0ziwr31bCC2kMB0RomJb0q6GLmA7CYmiQOdl8CK
	2AS0JPa/uAFWJCIQIPHj+Dswm1ngJqPEsfdhXYwcHMICPhLHHgiDhFkEVCVOLDnCDmLzCrhK
	bD91lx1il5zEhz2PwGxOATeJmYtOQu11leh5dJF5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBMfVMegfjqgaLQ4wCHIxKPLwHlrkGC7EmlhVX5h5ilOBgVhLhvRbsFizEm5JY
	WZValB9fVJqTWnyIMRnoqonMUqLJ+cB4zyuJNzQ2MTOyNDI3tDAyNidNWEmc92CrdaCQQHpi
	SWp2ampBahHMFiYOTqkGxqBlmkVtZn7p07fv3vnf94GXitdyNpmsuqNOP4R8kyND/Y3/+f1v
	KbY0v2dwMGV63obPB3/7x3/cL1qeyxkq/St5teM1TYcLvodYLnp7+lrEVTHGRxrELNM2+ylz
	4/hd57MFc6ZdnCQll/TLZefRd4Y6ZazvDxSanNTT6p45f9OveKkAVsMfSizFGYmGWsxFxYkA
	7f8MEO0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

This patch fix the offset of CPU boot address and change parameter of smc call
of SMC_CMD_CPU1BOOT command for Exynos4212.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 932129e..91a911d 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -18,6 +18,8 @@
 
 #include <mach/map.h>
 
+#include <plat/cpu.h>
+
 #include "smc.h"
 
 static int exynos_do_idle(void)
@@ -28,14 +30,22 @@ static int exynos_do_idle(void)
 
 static int exynos_cpu_boot(int cpu)
 {
-	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
+	if (soc_is_exynos4212())
+		exynos_smc(SMC_CMD_CPU1BOOT, 0, 0, 0);
+	else
+		exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
 	return 0;
 }
 
 static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
-	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
+	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
 
+	if (soc_is_exynos4212())
+		goto out;
+	else
+		boot_reg += 4*cpu;
+out:
 	__raw_writel(boot_addr, boot_reg);
 	return 0;
 }
-- 
1.8.0

