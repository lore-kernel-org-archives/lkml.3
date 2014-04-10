Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777AbaDJJiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:38:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9297 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965717AbaDJJh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:58 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-11-53466673c2d3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
Date: Thu, 10 Apr 2014 18:37:17 +0900
Message-id: <1397122658-16013-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkRLc4zS3Y4MB0K4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mpo+3eCveA1V8Wr3XcYGxivcnQxcnJICJhI/F1y
	kwXCFpO4cG89WxcjF4eQwFJGiUUfG9hhig58WguVmM4ocWfTQTaQhJBAE5PEzw4zEJtNQEti
	/4sbYHERgQCJH8ffgdnMAjcZJY69DwOxhQUSJJ5NnwIWZxFQlWjavgdsM6+Aq8S5T0uglslJ
	fNjzCMzmFHCTmLnoJNQuV4meRxeZQY6QEFjGLtH27iErxCABiW+TDwEN4gBKyEpsOsAMMUdS
	4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM/NP/nvXuYLx9wPoQYzLQ
	uInMUqLJ+cDIySuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxlzR6P+9WwvEC3MbwzYmOhhdej3h/rdnGisfPUzLieB7Ilmenlw9c8flucZchmlL
	thosesM1se2pAf9t5c8Rs7YzvK/Iasv3t+YNEb38fju/YaHVJ9uQiNb/U0Lv9uluW8B7aRbH
	2c4PImJnLYT+qfS2X93u/YnlrSFnwvm9D+9e1rn8qOriRCWW4oxEQy3mouJEAE86YISSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd3iNLdggw97jCyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRtu/E+wF
	r7kqXu2+w9jAeJWji5GTQ0LAROLAp7VsELaYxIV764FsLg4hgemMEnc2HQRLCAk0MUn87DAD
	sdkEtCT2v7gBFhcRCJD4cfwdmM0scJNR4tj7MBBbWCBB4tn0KWBxFgFViabte1hAbF4BV4lz
	n5awQyyTk/iw5xGYzSngJjFz0UmoXa4SPY8uMk9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIziunkntYFzZYHGIUYCDUYmH98Ay12Ah1sSy4srcQ4wSHMxKIrzXgt2ChXhTEiur
	Uovy44tKc1KLDzEmA101kVlKNDkfGPN5JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cDo/cr8kLuygc9hvrL9qn1Hm2omlr6omb9rO+s8/3/br7EmiE0v5rNf
	8a/Lq2mmEmddTeIdmYynbW3SD3W3+5w+3/W95UXuQpXA14++hNxP2BPgERMbmNBktzTBbW6o
	7OTj6y+FuJ5p0jVZclqQM2W/xIv3gYy3LaoilNwncd2K2mDNLXXXoEGJpTgj0VCLuag4EQDS
	LdV37wIAAA==
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

