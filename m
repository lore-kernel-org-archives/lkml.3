Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaDYBRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39132 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDYBQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:24 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f7-5359b7613dfb
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
Subject: [PATCHv4 4/7] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
Date: Fri, 25 Apr 2014 10:16:09 +0900
Message-id: <1398388572-30239-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSDdxe2Swwbv9ChZ/Jx1jt5i07gCT
	xeX92hbXvzxntZh/5ByrxecPLUDx+xNYLHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3L
	vBZ/7/xjszh1/TObxck/vYwWTw5/ZLWYMfklm8X6Ga9ZLI7NWMJo0f53L5vF3p2TGR3EPNbM
	W8Po0dLcw+bx+9ckRo+/q14we+ycdZfd4861PWwem5fUe1w50cTq0bdlFaPH501yAVxRXDYp
	qTmZZalF+nYJXBm/fl9hL3jBXfFsk0ID4xnOLkZODgkBE4mjS84wQthiEhfurWcDsYUEljJK
	/P7lDFPzdtFNli5GLqD4dEaJV3OnMEE4TUwS264tYwWpYhPQktj/4gZYt4iArsSUmXfA4swC
	rSwSfVtquhg5OIQF4iV2T9YHCbMIqEpcWnYVrIRXwFXiz8NLTBDL5CQ+7HnEDmJzCrhJ7Nz1
	igmkVQioZukfD5C1EgIrOSTa1v9jhpgjIPFt8iEWkBoJAVmJTQeYIcZIShxccYNlAqPwAkaG
	VYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBMXr637PeHYy3D1gfYkwGGjeRWUo0OR8Y43kl
	8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOhhZrV0
	ptk1XatpwWodK032GwkLFQSq3Gio6vd9Vr5/8gemlSeX/zXWqO17ulVNXOKNV+yZO0dOXrtw
	eWlInJtXJPflQx8jAxb3RSq7REl2P3XZ7+cVK8X41eDSvctWtV77FLmyo+4p/Bat6Co+9yny
	2Ixthz8YRVwp4/k/76xqSWzx/k2xZ5VYijMSDbWYi4oTASkYRcXnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd3E7ZHBBucei1v8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tADF709gsehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81r8vfOPzeLU9c9sFif/9DJaPDn8kdVixuSXbBbrZ7xmsTg2YwmjRfvfvWwWe3dOZnQQ81gz
	bw2jR0tzD5vH71+TGD3+rnrB7LFz1l12jzvX9rB5bF5S73HlRBOrR9+WVYwenzfJBXBFNTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9qqRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+PX7CnvBC+6KZ5sUGhjPcHYxcnJI
	CJhIvF10kwXCFpO4cG89WxcjF4eQwHRGiVdzpzBBOE1MEtuuLWMFqWIT0JLY/+IGG4gtIqAr
	MWXmHbA4s0Ari0TflpouRg4OYYF4id2T9UHCLAKqEpeWXQUr4RVwlfjz8BITxDI5iQ97HrGD
	2JwCbhI7d71iAmkVAqpZ+sdjAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBKeCZ
	1A7GlQ0WhxgFOBiVeHg/qEUGC7EmlhVX5h5ilOBgVhLhVV4FFOJNSaysSi3Kjy8qzUktPsSY
	DHTURGYp0eR8YHrKK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5O
	qQZGq/MF6VbK1535r0toOj8yua5w5WOcd92sK6/y69V/zvE/+cz49dEU0WZRd/mnDfcsXPl+
	rbg+N3JZ+4tdDgFzwl/4/tx8cXMId/z5ByLrprI+i/Np2Fu6NHz7x4i0w0c/+5qs4fkgaZC/
	UVhqc0rl7s8ZFnMObP0vOzWb1aFF1ZFl9sQK3gZ+JZbijERDLeai4kQAfI+4/EUDAAA=
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

