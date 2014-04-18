Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaDRBQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61231 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaDRBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:30 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-54-53507cafcf6b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv3 2/7] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Fri, 18 Apr 2014 10:15:23 +0900
Message-id: <1397783728-6193-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkWHd9TUCwwb/ZGhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+mc3i5J9eRosnhz+yWsyY/JLNYv2M1ywWx2YsYbRo/7uXzWLvzsmMDqIea+atYfRo
	ae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArigum5TUnMyy
	1CJ9uwSujMamhYwFa7krHnRMYm5gXMjZxcjJISFgInHoyFdmCFtM4sK99WxdjFwcQgJLGSUu
	9F5igSl6/aSdBSKxiFHiyOXVUE4Tk8S5o3OYQKrYBLQk9r+4wQZiiwgoSGzufcYKUsQs8ItZ
	4ufzZnaQhLCAj0Tf89NA3RwcLAKqEj3/9UHCvAIuEq23r0KdISfxYc8jsHJOAVeJ84+PgF0h
	BFTz8Pt0sMUSAis5JHqaT4IVsQgISHybfAhspoSArMSmA1BzJCUOrrjBMoFReAEjwypG0dSC
	5ILipPQiU73ixNzi0rx0veT83E2MwAg9/e/ZxB2M9w9YH2JMBho3kVlKNDkfGOF5JfGGxmZG
	FqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBoHCY+PS7w/byb
	K34Kf/zrbKCZkpvNO2PlrXUnTa5MWfvWft9D+X61bf8XLTF+86lOMrZ/NW/6kS0qNq9jo30l
	o1e/Ttzi4fR7jt2GQKFWJs4fW0Q3zLl6uf3wBR6N5dsTjkvPDv8WkRPaflP0xAeuSJ97Mevb
	zmfPffb/uJjKkg9TmFa+zb5dq8RSnJFoqMVcVJwIAFNqCGTmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd31NQHBBkefyVj8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6ZzaLk396GS2eHP7IajFj8ks2i/UzXrNYHJuxhNGi/e9eNou9OyczOoh6rJm3htGj
	pbmHzeP3r0mMHn9XvWD22DnrLrvHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCuKIaGG0yUhNT
	UosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgH5UUihLzCkFCgUk
	Fhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY0Ni1kLFjLXfGgYxJzA+NCzi5GTg4JAROJ
	10/aWSBsMYkL99azdTFycQgJLGKUOHJ5NQuE08Qkce7oHCaQKjYBLYn9L26wgdgiAgoSm3uf
	sYIUMQv8Ypb4+byZHSQhLOAj0ff8NFA3BweLgKpEz399kDCvgItE6+2rzBDb5CQ+7HkEVs4p
	4Cpx/vERsCuEgGoefp/OMoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ph/Jr2D
	cVWDxSFGAQ5GJR7eC1/9g4VYE8uKK3MPMUpwMCuJ8CqXBgQL8aYkVlalFuXHF5XmpBYfYkwG
	Omois5Rocj4wNeWVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A6Owp6jsuzb78w/CxOL4Hadvf7q2iCc1/vKBpVY7eP5LX3re/nO+itVFptn9S1yEHK7y7Thg
	J9Dx7/6UifohwT3HTLgOtt8NSK9PdOdXeWiwMvlO8eb3Pm5RT9fPmjNNm02n6t7J2beuZTpc
	LNry/mPD/1nHk9SrfryyWHO9pWJz/u2VRx+6xjAosRRnJBpqMRcVJwIAjlHLr0MDAAA=
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
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 932129e..aa01c42 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -18,6 +18,8 @@
 
 #include <mach/map.h>
 
+#include <plat/cpu.h>
+
 #include "smc.h"
 
 static int exynos_do_idle(void)
@@ -28,13 +30,24 @@ static int exynos_do_idle(void)
 
 static int exynos_cpu_boot(int cpu)
 {
+	/*
+	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
+	 * But, Exynos4212 has only one secondary CPU so second parameter
+	 * isn't used for informing secure firmware about CPU id.
+	 */
+	if (soc_is_exynos4212())
+		cpu = 0;
+
 	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
 	return 0;
 }
 
 static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
-	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
+	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
+
+	if (!soc_is_exynos4212())
+		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
 	return 0;
-- 
1.8.0

