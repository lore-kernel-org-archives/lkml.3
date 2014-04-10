Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520AbaDJJ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:29:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64883 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935023AbaDJJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:29:13 -0400
X-AuditID: cbfee690-b7f266d00000287c-f2-53466451e292
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/27] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
Date: Thu, 10 Apr 2014 18:28:21 +0900
Message-id: <1397122124-15690-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkRDcwxS3YoG2OoMX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVMu9zIWjCRq2LmJe0GxmUcXYycHBICJhLb3/9l
	g7DFJC7cWw9kc3EICSxllJg/+QwrTNGHS4/ZIRLTGSVWzV8NVdXEJNH86zAjSBWbgJbE/hc3
	wEaJCARI/Dj+DsxmFrjJKHHsfVgXIweHsICPxLEHwiBhFgFViWVHuphAbF4BV4njDRehlslJ
	fNjziB3E5hRwk/j0vRUsLgRU0/RhH9heCYFl7BI7TxxlhxgkIPFt8iEWkPkSArISmw4wQ8yR
	lDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzECw/70v2cTdjDeO2B9iDEZ
	aNxEZinR5Hxg3OSVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6PQ3fPTwy0cPdMnmDwI8eZM6viZUvaSx973zirTyweNe9+5W6z9lbY1Jqpm57G7
	th+qnga9lvjGv2Azq3/Y7NCSad1yC9UtvFZadUqt7v34PduaK3hOlBMbx8vjJeKTN+j9eWru
	+ojF7FfXlwzHh08u5QfOSpzTq27GGPMrxrFSsOtxHfv0D0osxRmJhlrMRcWJACTFjTKRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg8t97BbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi7czKjA7fH5iX1
	Hn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9rlRtaC
	iVwVMy9pNzAu4+hi5OSQEDCR+HDpMTuELSZx4d56ti5GLg4hgemMEqvmr4Zympgkmn8dZgSp
	YhPQktj/4gYbiC0iECDx4/g7MJtZ4CajxLH3YV2MHBzCAj4Sxx4Ig4RZBFQllh3pYgKxeQVc
	JY43XGSFWCYn8WHPI7DFnAJuEp++t4LFhYBqmj7sY5vAyLuAkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnBUPZPawbiyweIQowAHoxIP74FlrsFCrIllxZW5hxglOJiVRHivBbsFC/Gm
	JFZWpRblxxeV5qQWH2JMBrpqIrOUaHI+MOLzSuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoGRhUniL6tOwtn9sxQ/r3Pjv9TjHnlcL8xqVt7T7X+6PhWcc3zt
	LP+2yG52Nl+q7tRtSWkhhXIuYQ+sVpc4NC1prNvjpbQ5q0qk9q9fkccXKzWFJqnF0nJb7uUb
	fPpT8fNetxqbQuEUxhNhGfkqkpL8Dn0NSe7fk93O2jIlPWmKm1O0r16/SImlOCPRUIu5qDgR
	AD1gKcXuAgAA
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

