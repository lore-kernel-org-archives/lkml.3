Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbaDJJxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:53:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35111 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403AbaDJJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:52 -0400
X-AuditID: cbfee68f-b7f156d00000276c-d5-534664514773
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
Date: Thu, 10 Apr 2014 18:28:23 +0900
Message-id: <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSqBuY4hZssHaamMX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGW0/TvBXvCaq+LV7juMDYxXOboYOTkkBEwkmo4t
	ZYewxSQu3FvP1sXIxSEksJRRYtuz72wwRa+/v2CESExnlGjeuJYdwmlikmj+dZgRpIpNQEti
	/4sbYB0iAgESP46/A7OZBW4yShx7HwZiCwskSDybPgUsziKgKjHl/kIWEJtXwFXi5On3UNvk
	JD7seQR2EqeAm8Sn762sILYQUE3Th31g50kIrGKXODb1DDPEIAGJb5MPAQ3iAErISmw6wAwx
	R1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECAz90/+e9e9gvHvA+hBj
	MtC4icxSosn5wNjJK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2MG1cf0S2dfUVFL5wzn/PbFZ1a76bFOaW3GsvYcp9xHKp3Lc2/0nB5W4gMu/lc
	10vCkY9WeC54FqO+a/kD2YLJ8z5HL3tvtzuJv3ddmF6wzuVTFow+C9KXrHF5InOtWlJZQKZs
	10WhWbMv1D5Rfyzs4RQSPW/i1afrFRKYqqpV1P/cTz78zEtGiaU4I9FQi7moOBEABZI2DZMC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg7adfBbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi7czKjA7fH5iX1
	Hn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo+3fCfaC
	11wVr3bfYWxgvMrRxcjJISFgIvH6+wtGCFtM4sK99WxdjFwcQgLTGSWaN65lh3CamCSafx0G
	q2IT0JLY/+IGG4gtIhAg8eP4OzCbWeAmo8Sx92EgtrBAgsSz6VPA4iwCqhJT7i9kAbF5BVwl
	Tp5+zwaxTU7iw55H7CA2p4CbxKfvrawgthBQTdOHfWwTGHkXMDKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAiOrGdSOxhXNlgcYhTgYFTi4T2wzDVYiDWxrLgy9xCjBAezkgjvtWC3YCHe
	lMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB0Z9Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwst60swkRyDtx4e7uL8Fhd6zeRxrf+3771oOgKHYBmfTwoM23
	rI6kb2868CU3V/BOZ7HkkVslbc5vWkQ8JV4K5eh0rNJ23pA393KlZMTV54+i6lzbdqyw3Cle
	+S3e+I5moqdtueuWXWnyMefWiu+a/pz/yB3Wbw8uy6S+VnGqrDB5un5SKUudEktxRqKhFnNR
	cSIAjsp1v/ACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch decide proper lowpower mode of either a15 or a9 according to own ID
from Main ID register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..36d3db6 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -135,13 +135,20 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	int primary_part = 0;
 
 	/*
-	 * we're ready for shutdown now, so do it.
-	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
+	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
+	 * while Exynos5 is A15/Exynos7 is A7; check the CPU part
 	 * number by reading the Main ID register and then perform the
 	 * appropriate sequence for entering low power.
 	 */
 	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
-	if ((primary_part & 0xfff0) == 0xc0f0)
+
+	/*
+	 * Main ID register of Cortex series
+	 * - Cortex-a7  : 0x410F_C07x
+	 * - Cortex-a15 : 0x410F_C0Fx
+	 */
+	primary_part = primary_part & 0xfff0;
+	if (primary_part == 0xc0f0 || primary_part == 0xc070)
 		cpu_enter_lowpower_a15();
 	else
 		cpu_enter_lowpower_a9();
-- 
1.8.0

