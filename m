Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaDYBRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39160 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDYBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:22 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-e8-5359b7602370
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv4 2/7] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Fri, 25 Apr 2014 10:16:07 +0900
Message-id: <1398388572-30239-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkSDdhe2SwwfSPBhZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBmNTQsZC9ZyVzzomMTcwLiQs4uRk0NCwETi55V+FghbTOLCvfVsXYxcHEIC
	Sxkl7n75ywxT1Pq8nRUiMZ1R4teXfYwQThOTxPT179lBqtgEtCT2v7jBBmKLCOhKTJl5hxXE
	ZhZoZZHo21LTxcjBISzgI3H3XgVImEVAVWLm0ldMIGFeAVeJORtLIXbJSXzY8whsIqeAm8TO
	XRAlQkAlS/94gGyVEFjJIXH3ZysrxBgBiW+TD7GA1EgIyEpsOgB1sqTEwRU3WCYwCi9gZFjF
	KJpakFxQnJReZKhXnJhbXJqXrpecn7uJERilp/89693BePuA9SHGZKBxE5mlRJPzgVGeVxJv
	aGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MIR1ZHvFL
	v/w37Vz2qe/So6MNvsxtcrJxMZ8m3VPrbyvwL1t3w+bHLV8j2czf0rm2yfuubygxsDof17s+
	QuZP+kyDK4HfkrW3mYZdmWfyYW0481zn4oLYto7pCmy/9z/2Y57Mv0HA8avzhJWti9csb946
	IXH+1KMJBb8/y7jWpK585bxoYuwOJZbijERDLeai4kQADcyk1ugCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd2E7ZHBBkdmqlr8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMaGxayFiwlrviQcck5gbGhZxdjJwc
	EgImEq3P21khbDGJC/fWs3UxcnEICUxnlPj1ZR8jhNPEJDF9/Xt2kCo2AS2J/S9usIHYIgK6
	ElNm3gHrZhZoZZHo21LTxcjBISzgI3H3XgVImEVAVWLm0ldMIGFeAVeJORtLIXbJSXzY8whs
	IqeAm8TOXRAlQkAlS/94TGDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAU8k9rB
	uLLB4hCjAAejEg/vB7XIYCHWxLLiytxDjBIczEoivMqrgEK8KYmVValF+fFFpTmpxYcYk4Fu
	msgsJZqcD0xPeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	yBi1ZDZf1eLFDxadXHLma4HAwaprH7UfL5uZO9kwxMXy/yVxrtOC76v25pp9vHrvpPm6LxcY
	bnj2JZ8TY4sx/WWw9tn/Vfe2vn7ML3E7heeCp5Go7rn0DTN/q6RH6Ts7T8sTSj7yPFXT9sb1
	5UU3rJ+zbpb10pZIeM715ID7/B1b5C4Xz177SFmJpTgj0VCLuag4EQAr00rIRQMAAA==
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

