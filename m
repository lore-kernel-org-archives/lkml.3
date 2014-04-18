Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaDRBQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:16:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaDRBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:15:30 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-d6-53507cb075fa
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
Subject: [PATCHv3 4/7] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
Date: Fri, 18 Apr 2014 10:15:25 +0900
Message-id: <1397783728-6193-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
References: <1397783728-6193-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkSHdDTUCwwcMX5hZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+mc3i5J9eRosnhz+yWsyY/JLNYv2M1ywWx2YsYbRo/7uXzWLvzsmMDqIea+atYfRo
	ae5h8/j9axKjx99VL5g9ds66y+5x59oeNo/NS+o9rpxoYvXo27KK0ePzJrkArigum5TUnMyy
	1CJ9uwSujF+/r7AXvOCueLZJoYHxDGcXIyeHhICJxJFbD5ggbDGJC/fWs3UxcnEICSxllNhy
	rZEdpujX1eXMEIlFjBLHTl5ghHCamCT6jyxmA6liE9CS2P/iBpgtIqAgsbn3GStIEbPAL2aJ
	n8+bwUYJC8RL7Dz0E6yIRUBV4t6Bl2A2r4CLxPazn6DukJP4sOcRWD2ngKvE+cdHWEBsIaCa
	h9+ns4AMlRBYyiFxd/ZZZohBAhLfJh8CSnAAJWQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGKphYk
	FxQnpRcZ6hUn5haX5qXrJefnbmIERujpf896dzDePmB9iDEZaNxEZinR5HxghOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Pd+hnmgulFSxZf
	cb21yet5bvBfn7K5pSunS+lvUMmbG3er5Ku5VFyRuQWn9ZLNee36DbWZZiWaz1mrvq2PLtC+
	PmGN1IubSX1Z68pK3Y3nnql6surbgxuf59y4+PjsIw8nZaaomVscq7jYF71jDq+e5sjyN3pe
	Ww5b8btXn3bd0ttWG/Jk7zQlluKMREMt5qLiRABdnoBt5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd0NNQHBBr8v6Vn8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6ZzaLk396GS2eHP7IajFj8ks2i/UzXrNYHJuxhNGi/e9eNou9OyczOoh6rJm3htGj
	pbmHzeP3r0mMHn9XvWD22DnrLrvHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCuKIaGG0yUhNT
	UosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgH5UUihLzCkFCgUk
	Fhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb8+n2FveAFd8WzTQoNjGc4uxg5OSQETCR+
	XV3ODGGLSVy4t56ti5GLQ0hgEaPEsZMXGCGcJiaJ/iOL2UCq2AS0JPa/uAFmiwgoSGzufcYK
	UsQs8ItZ4ufzZnaQhLBAvMTOQz/BilgEVCXuHXgJZvMKuEhsP/uJCWKdnMSHPY/A6jkFXCXO
	Pz7CAmILAdU8/D6dZQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH/THoH46oG
	i0OMAhyMSjy8F776BwuxJpYVV+YeYpTgYFYS4VUuDQgW4k1JrKxKLcqPLyrNSS0+xJgMdNVE
	ZinR5HxgasoriTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbe
	cofmEpWMyT12XHeEQvMm75j7sX/RNl1bk7d+Sd5tthFHHG7EuCV/qdqw4ZBc38Xle36+ftVj
	YqDhdP1P+Lf/SyStA7d/MT3DoWx3o3qTneCOVZxrxWdxJd+94Pz21rSgNyH7LRbnHjt2eOK9
	r9zdyh6+DVVT5kpYWt9Zeso+6wLzouyJ67OUWIozEg21mIuKEwEUh051QwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch decide proper lowpower mode of either a15 or a9 according to own ID
from Main ID register.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zynigier <marc.zyngier@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..acf3119 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -135,16 +135,21 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	int primary_part = 0;
 
 	/*
-	 * we're ready for shutdown now, so do it.
-	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
-	 * number by reading the Main ID register and then perform the
-	 * appropriate sequence for entering low power.
+	 * Prepare the CPU for shutting down. The required sequence of
+	 * operations depends on core type. CPUID part number can be used to
+	 * determine the right way.
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

