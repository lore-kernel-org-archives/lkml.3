Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaDOCBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:01:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaDOB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:57 -0400
X-AuditID: cbfee68e-b7f566d000002344-6d-534c929b394f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 5/8] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Tue, 15 Apr 2014 10:59:49 +0900
Message-id: <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQHf2JJ9ggwsThSz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M1Bo8ks2i/UzXrNYHJuxhNFi787JjA5CHmvmrWH0aGnuYfP4/WsSo8ffVS+YPe5c
	28PmsXlJvceVE02sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJWx+uwBloK1XBXfpj9hbmDc
	wdHFyMkhIWAiMav/FxOELSZx4d56NhBbSGApo8T5k7EwNYe3vgGKcwHFFzFKPG6+zg7hNDFJ
	fL5+mQWkik1AS2L/ixtg3SICChKbe5+xghQxC6xllrg4qREsISzgI7F85xJWEJtFQFXiUucv
	ZhCbV8BVYsGRtewQ6+QkPux5BGZzCrhJ7L3/lxniJFeJ9ftnM4EMlRBo5ZC48nkp1CABiW+T
	DwFdwQGUkJXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREY
	eaf/PevbwXjzgPUhxmSgcROZpUST84GRm1cSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGGVsM3//PP3uzcrO5tBd6w/HnTULnWiacELsvu3c3/J2
	bdNCuO8XhF+5bbFdRjJgn8Ram6n6RxfPOKehvYklYkpfUMuJGWGW8+WnvfLvfVlxRmBuUG5J
	CfMFU40pHZdvOc+3cgl/VTRhZ+icthlOCyyvZl6eu31P3G2mH6lbdQ1k75l8mfD5grgSS3FG
	oqEWc1FxIgC9RLrt0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3Zk3yCDSat4LD4O+kYu8WkdQeY
	LC7v17a4/uU5q8X8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy9
	84/N4tT1z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeayZt4bRo6W5h83j969JjB5/V71g9rhz
	bQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QP0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjNVnD7AUrOWq+Db9CXMD4w6OLkZODgkBE4nDW9+wQdhiEhfurQeyuTiEBBYxSjxu
	vs4O4TQxSXy+fpkFpIpNQEti/4sbYB0iAgoSm3ufsYIUMQusZZa4OKkRLCEs4COxfOcSVhCb
	RUBV4lLnL2YQm1fAVWLBkbXsEOvkJD7seQRmcwq4Sey9/xesRgioZv3+2UwTGHkXMDKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7GdSOxhXNlgcYhTgYFTi4fWY4BMsxJpYVlyZe4hR
	goNZSYT3dTJQiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVEk/OBSSevJN7Q2MTMyNLI3NDCyNic
	NGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgDPi6wnFQSddMjknmTs239R8E5ag++CWWU
	m7alSHz5YBwQXLH1nv9Npp9MTVfb71SumhF4MzZ3i/j22xNW6nayTtzf1RG6p3jrLOuN6utk
	FqVY/g8u/Lq4xtLXpPTa131Nrhw7t2jtemb46da8ZmuehtuisQFbnmr1++y/1rSeVSv8dSzD
	nr9KLMUZiYZazEXFiQBDi4zGMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the offset of CPU boot address and don't operate smc call
of SMC_CMD_CPU1BOOT command for Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index aa01c42..6205d4f 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -30,13 +30,16 @@ static int exynos_do_idle(void)
 
 static int exynos_cpu_boot(int cpu)
 {
+	if (soc_is_exynos3250()) {
+		return 0;
 	/*
 	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
 	 * But, Exynos4212 has only one secondary CPU so second parameter
 	 * isn't used for informing secure firmware about CPU id.
 	 */
-	if (soc_is_exynos4212())
+	} else if (soc_is_exynos4212()) {
 		cpu = 0;
+	}
 
 	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
 	return 0;
@@ -46,7 +49,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
 	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
 
-	if (!soc_is_exynos4212())
+	if (!soc_is_exynos4212() && !soc_is_exynos3250())
 		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
-- 
1.8.0

