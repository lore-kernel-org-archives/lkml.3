Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbaDJJ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:29:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64883 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934952AbaDJJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:29:12 -0400
X-AuditID: cbfee68f-b7f156d00000276c-d4-534664517315
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/27] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Thu, 10 Apr 2014 18:28:22 +0900
Message-id: <1397122124-15690-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkQDcwxS3YYOsTPovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq43FNX8J6j4saDNpYGxuXsXYycHBICJhLv5k9k
	g7DFJC7cWw9kc3EICSxllJh65yIrTNHbNz3sEInpjBKzzl1jhXCamCSafx1mBKliE9CS2P/i
	BtgoEYEAiR/H34HZzAI3GSWOvQ/rYuTgEBbwkThzOhgkzCKgKjH//E4mEJtXwFVi24bLUFfI
	SXzY8wjsOk4BN4lP31vBjhACqmn6sA/sOgmBVewSk3sesEMMEpD4NvkQC8h8CQFZiU0HmCHm
	SEocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgWF/+t+z/h2Mdw9YH2JM
	Bho3kVlKNDkfGDd5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoHR2i1Qwmjjyvryqmn+LVt0Am5t4Z53Z9Yv6cein0tvqTzQmrRjgbfAMV4Bm5Tc
	/6JrayZri1VlqKmVCRz9V7DniHtm+I2Og1vtLlSaeujILmRr7Ftyxvjw28URl09evXbL6sMs
	nRZByVRxxpUT57bm87kuKf3vGTMp5HeT2uTaid8/mnLM3m6oxFKckWioxVxUnAgAkH/VvJEC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg0Vv2C2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42wSU2PT4GqvF5V1z2CxmnN/HZDFj8ks2i/UzXrNY7N05mdGB22PzknqP
	vi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMATpISaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxuaeu4D1H
	xY0HbSwNjMvZuxg5OSQETCTevumBssUkLtxbz9bFyMUhJDCdUWLWuWusEE4Tk0Tzr8OMIFVs
	AloS+1/cYAOxRQQCJH4cfwdmMwvcZJQ49j6si5GDQ1jAR+LM6WCQMIuAqsT88zuZQGxeAVeJ
	bRsus0Esk5P4sOcR2GJOATeJT99bWUFsIaCapg/72CYw8i5gZFjFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERxVz6R3MK5qsDjEKMDBqMTDe2CZa7AQa2JZcWXuIUYJDmYlEd5rwW7BQrwp
	iZVVqUX58UWlOanFhxiTga6ayCwlmpwPjPi8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamDkXB1+SMXpRM+1V++lV66eeHt1+ErHkzw71h7dLrzYebllQnvT
	P8uJc/ZMe9Md911rq2Z+wkuhJrdPzfEBvGt43pU+/tnL4FJk5eRi/nH1f5GTlY8tOK1yneeG
	nXb8FzGtji3G76wOh6euXp+VUcluJYZlLTXLJ0xcL3B2zjrdPXuf1XL/WyetxFKckWioxVxU
	nAgAOOk3+O4CAAA=
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

