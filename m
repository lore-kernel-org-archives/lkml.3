Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858AbaDJJmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:42:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9297 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965711AbaDJJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-00-534666738538
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/27] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Thu, 10 Apr 2014 18:37:16 +0900
Message-id: <1397122658-16013-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkULc4zS3Y4N1sHovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq43FNX8J6j4saDNpYGxuXsXYycHBICJhLbDvYy
	Q9hiEhfurWfrYuTiEBJYyijReeUVK0xR941VTBCJ6YwSx55dgKpqYpKYvquHBaSKTUBLYv+L
	G2wgtohAgMSP4+/AbGaBm0Ad78O6GDk4hAV8JM6cDgYJswioSvxZ8hFsM6+Aq8TMi++glslJ
	fNjzCOw6TgE3iZmLToKNEQKq6Xl0kRlkr4TAKnaJB5+mMEIMEpD4NvkQC8h8CQFZiU0HoL6R
	lDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzECw/70v2cTdjDeO2B9iDEZ
	aNxEZinR5Hxg3OSVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2P99Nk3l3y235j4qjsq6qPWzp4LPnk9tjqy+uu0mUNWsVR+XBwiv/S99YYlJ5eJ
	u518wfiFTaBM2CvP9vFC6dUFSr1ruLYd2rA7J31uy8fD/9e6cyjvfOA9x+x44lm/uWfrWa48
	qeE/t+Vq8PRJVfN/bV+h++z+f8st+V+TpzW1KbZWTH+1ud9XiaU4I9FQi7moOBEAdE5tH5EC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3iNLdgg5n3WCyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxuWeuoL3
	HBU3HrSxNDAuZ+9i5OSQEDCR6L6xignCFpO4cG89WxcjF4eQwHRGiWPPLkA5TUwS03f1sIBU
	sQloSex/cYMNxBYRCJD4cfwdmM0scBOo431YFyMHh7CAj8SZ08EgYRYBVYk/Sz4yg9i8Aq4S
	My++Y4VYJifxYc8jsCM4BdwkZi46CTZGCKim59FF5gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBEfVM6kdjCsbLA4xCnAwKvHwHljmGizEmlhWXJl7iFGCg1lJhPdasFuwEG9K
	YmVValF+fFFpTmrxIcZkoKsmMkuJJucDIz6vJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLp
	iSWp2ampBalFMFuYODilGhizruQeZ49NPFea/V/61NtNfCo+WZ8XHHu4yi+5Xm/WV2atrsUu
	i5u/13wR41IVsBNgO6C4q39+p5jxUSMtyy3c0kF65mo3OCvX8F5bWKzDPMd+r8YT5dT5D9v5
	5lc1/UvqWDKluub6u4XeO1vjwzaV/TQKfe955aE8T+Kzp1y2H4+7WTE19imxFGckGmoxFxUn
	AgAqBtiC7gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the offset of CPU boot address and don't operate smc call
of SMC_CMD_CPU1BOOT command for Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 91a911d..8350007 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -30,10 +30,13 @@ static int exynos_do_idle(void)
 
 static int exynos_cpu_boot(int cpu)
 {
-	if (soc_is_exynos4212())
+	if (soc_is_exynos3250())
+		goto out;
+	else if (soc_is_exynos4212())
 		exynos_smc(SMC_CMD_CPU1BOOT, 0, 0, 0);
 	else
 		exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
+out:
 	return 0;
 }
 
@@ -41,7 +44,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 {
 	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
 
-	if (soc_is_exynos4212())
+	if (soc_is_exynos4212() || soc_is_exynos3250())
 		goto out;
 	else
 		boot_reg += 4*cpu;
-- 
1.8.0

