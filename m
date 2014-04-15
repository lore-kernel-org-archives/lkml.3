Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaDOCAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:00:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaDOB7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:55 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-c3-534c92999f6e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 4/8] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Tue, 15 Apr 2014 10:59:48 +0900
Message-id: <1397527192-21988-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkRHfWJJ9gg7ZFLBZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLewWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei793
	/rFZnLr+GSg0+SWbxfoZr1ksjs1Ywmixd+dkRgchjzXz1jB6tDT3sHn8/jWJ0ePvqhfMHneu
	7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC+CM4rJJSc3JLEst0rdL4MpobFrIWLCWu+JBxyTmBsaF
	nF2MHBwSAiYSmzpzuxg5gUwxiQv31rOB2EICSxklVl1whIibSEz5e4K9i5ELKL6IUWLaqVvM
	EE4Tk8TpfUvYQarYBLQk9r+4AdYtIqAgsbn3GStIEbPAWmaJi5Ma2UC2CQv4SEycxANSwyKg
	KvH/2FomkDCvgKvE/PkuEMvkJD7seQQ2klPATWLv/b/MEAe5SqzfP5sJZKSEQCeHxParS1kh
	5ghIfJt8iAXiGVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5
	mxiBMXf637PeHYy3D1gfYkwGGjeRWUo0OR8Ys3kl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoS
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCiU+i5Z90uPgff7o/NnpeUmmk1hYXqp2T6rtiV8
	/ymWjxOkXpnpNegxnGGflLx1g2T16U9LHP7UHQ1h//4+dqP5SQ/XOzsj7SJuFUT2m3zidvi1
	77cbe4zE7VVeMx6KVpU59PKJaLR4Cr14evrK09zwJ5e2dn29tDTh+68y2+1u7Dus1C/FHlVi
	Kc5INNRiLipOBAD75coYzwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd2Zk3yCDXbcMLP4O+kYu8WkdQeY
	LC7v17a4/uU5q8X8I+dYLT5/aGG36F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWvy9
	84/N4tT1z0ChyS/ZLNbPeM1icWzGEkaLvTsnMzoIeayZt4bRo6W5h83j969JjB5/V71g9rhz
	bQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QP0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjMamhYwFa7krHnRMYm5gXMjZxcjJISFgIjHl7wl2CFtM4sK99WxdjFwcQgKLGCWm
	nbrFDOE0MUmc3rcErIpNQEti/4sbbCC2iICCxObeZ6wgRcwCa5klLk5qBEpwcAgL+EhMnMQD
	UsMioCrx/9haJpAwr4CrxPz5LhDL5CQ+7HkENpJTwE1i7/2/zCC2EFDJ+v2zmSYw8i5gZFjF
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzVz6R2MK5ssDjEKMDBqMTD6zHBJ1iINbGsuDL3
	EKMEB7OSCO/rZKAQb0piZVVqUX58UWlOavEhxmSgoyYyS4km5wMTTl5JvKGxiZmRpZG5oYWR
	sTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MOarfzCd/pL/sM3sc6Zp9Y3PZn2KtlG2
	2nvJq4TlnOGDBoUAsd+TGd48+3Cw8sZE9q2KKwL/rZFteXVgyf0Jm5v/z7whLr3n8LXSDTPn
	B1v2mgYfvTRzy/4JO3b+kfhq/arepVhl78mqq+IO68xedTq9mPDhl+nSy9HiD9SvpIotvbvr
	+POObaEMSizFGYmGWsxFxYkAJfz2fS4DAAA=
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

