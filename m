Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaDRBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53758 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaDRBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:30 -0400
X-AuditID: cbfee68f-b7f156d00000276c-9a-53507cb0cc0b
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
Subject: [PATCHv3 3/7] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Fri, 18 Apr 2014 10:15:24 +0900
Message-id: <1397783728-6193-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkQHdDTUCwwecVwhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+mc3i5J9eRosnhz+yWsyY/JLNYv2M1ywWx2YsYbRo/7uXzWLvzsmMDqIea+atYfRo
	ae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArigum5TUnMyy
	1CJ9uwSujMvrlrIW3OWu6N2/ibWB8SRnFyMnh4SAicTys8/ZIWwxiQv31rN1MXJxCAksZZS4
	tuMaK0zRr13bWCASixgl/tw9xQrhNDFJnDs6hwmkik1AS2L/ixtsILaIgILE5t5nYEXMAr+Y
	JX4+bwbbISzgIzHvwiFGEJtFQFWidcF8sDivgIvEz/0TmSDWyUl82PMILM4p4Cpx/vERFhBb
	CKjm4ffpLBA1Szkkel/VQ8wRkPg2+RBQnAMoLiux6QAzRImkxMEVN1gmMAovYGRYxSiaWpBc
	UJyUXmSsV5yYW1yal66XnJ+7iREYoaf/PevfwXj3gPUhxmSgcROZpUST84ERnlcSb2hsZmRh
	amJqbGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGWMXmn4n0tTV7ER
	ZYy1qQ6vTl85pbrgzVMHn92Sr71Vt93QM2f+YMR93Ujc+/WufKGe6ZP5HExPqx5cuFz/ZXbT
	teg3Od/8rO2m3lx6Q3HLR7XcWenpr7MVlZ9EhnqnXuNP9eWQ3BL6/evmKAaGWVyfnc2WNyf1
	JdYVqRsssGa9daPf4n2xEktxRqKhFnNRcSIA9ZGy6+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd0NNQHBBrcvcVn8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6ZzaLk396GS2eHP7IajFj8ks2i/UzXrNYHJuxhNGi/e9eNou9OyczOoh6rJm3htGj
	pbmHzeP3r0mMHn9XvWD22DnrLrvHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCuKIaGG0yUhNT
	UosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgH5UUihLzCkFCgUk
	Fhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZcXreUteAud0Xv/k2sDYwnObsYOTkkBEwk
	fu3axgJhi0lcuLeerYuRi0NIYBGjxJ+7p1ghnCYmiXNH5zCBVLEJaEnsf3GDDcQWEVCQ2Nz7
	DKyIWeAXs8TP583sIAlhAR+JeRcOMYLYLAKqEq0L5oPFeQVcJH7un8gEsU5O4sOeR2BxTgFX
	ifOPj4CdIQRU8/D7dJYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQngGfSOxhX
	NVgcYhTgYFTi4b3w1T9YiDWxrLgy9xCjBAezkgivcmlAsBBvSmJlVWpRfnxRaU5q8SHGZKCr
	JjJLiSbnA5NTXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	ltTpCX9i/XC5+5bMfXdZ0cVrVx7P5N7oJOu+UGHrJf0i/duiGxRLAs4ucypSfsv5OLx23a8J
	L6o32PxivCWaYCFXZnp1taZlZliRSHm15OuwoPuBcw0K3j1hy2qd1b7h/cKO+UyPhVgWT37+
	V2vP7S1f3LduuOJVdumArx2rEavzx8uaF6N3KbEUZyQaajEXFScCAIZCu7JEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the offset of CPU boot address and don't need to send smc call
of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
WFE in secure mode.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index aa01c42..386d01d 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -31,11 +31,17 @@ static int exynos_do_idle(void)
 static int exynos_cpu_boot(int cpu)
 {
 	/*
+	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
+	 * because Exynos3250 removes WFE in secure mode.
+	 */
+	if (soc_is_exynos3250())
+		return 0;
+	/*
 	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
 	 * But, Exynos4212 has only one secondary CPU so second parameter
 	 * isn't used for informing secure firmware about CPU id.
 	 */
-	if (soc_is_exynos4212())
+	else if (soc_is_exynos4212())
 		cpu = 0;
 
 	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
@@ -46,7 +52,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
 	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
 
-	if (!soc_is_exynos4212())
+	if (!soc_is_exynos4212() && !soc_is_exynos3250())
 		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
-- 
1.8.0

