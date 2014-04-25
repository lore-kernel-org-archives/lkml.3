Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaDYBQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:16:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaDYBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:18 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-63-5359b76191b3
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
Subject: [PATCHv4 3/7] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Fri, 25 Apr 2014 10:16:08 +0900
Message-id: <1398388572-30239-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkQDdxe2SwwfFp3BZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBmX1y1lLbjLXdG7fxNrA+NJzi5GTg4JAROJCSuamCFsMYkL99azdTFycQgJ
	LGWUeLp1LhNM0aSNTVCJ6YwSM1ruMYIkhASamCR2zmMBsdkEtCT2v7jBBmKLCOhKTJl5hxXE
	ZhZoZZHo21IDYgsL+EgsfvwVbBuLgKrE+tYj7CA2r4CrxMKbDxghlslJfNjzCCzOKeAmsXPX
	K6AjOIB2uUos/eMBcoOEwFoOic6WjSwQcwQkvk0+xAJSIyEgK7HpANQzkhIHV9xgmcAovICR
	YRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYJye/vdswg7GewesDzEmA42byCwlmpwPjPO8
	knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamB0eyFX
	4XNSfr3Ux7viVpv8dBfu3FkccKfJ77O35qMZNp/VTuv6nrDf1uqa4HB0b98c1wW2PNpfDpxo
	W/qxRnTnxr7p3Flf5mhYL1k95eq0/r0PlyyaEqT19IPINQlJ44qFrBVpJ2YtqvvepqkzO+ma
	3CuvIyLa82uX/5z39vRUHicuOSVn2yhrJZbijERDLeai4kQA7HmPZekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3E7ZHBBg+2Mln8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuLxuKWvBXe6K3v2bWBsYT3J2MXJy
	SAiYSEza2MQGYYtJXLi3Hsjm4hASmM4oMaPlHiNIQkigiUli5zwWEJtNQEti/4sbYA0iAroS
	U2beYQWxmQVaWST6ttSA2MICPhKLH39lBrFZBFQl1rceYQexeQVcJRbefMAIsUxO4sOeR2Bx
	TgE3iZ27XjF1MXIA7XKVWPrHYwIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwUng
	mdQOxpUNFocYBTgYlXh4P6hFBguxJpYVV+YeYpTgYFYS4VVeBRTiTUmsrEotyo8vKs1JLT7E
	mAx01ERmKdHkfGCCyiuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGxsJfrHeU73cYnDNpFj+6ykB70ep1bUpmvzUWuixl39Uv91TM5s1SqR+XjixUaGst/vlE
	8dts2YJ5O1Lzd/+JXSxtJrRun3Gr+rROzsdJbpt/3/jzq2hT15HcD7fyF1bs+PZW+8McflGG
	tc1vNF4rnTXdJlG/qDhq4eJeppX/dXR/cMyf3Rbw5bcSS3FGoqEWc1FxIgC9cGzVRgMAAA==
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

