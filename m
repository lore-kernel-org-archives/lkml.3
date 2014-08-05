Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaHEKn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:43:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52552 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaHEKnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:43:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-be-53e0b5658bcc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 2/3] ARM: EXYNOS: Remove unneeded __ref annotation for
 cpu_die function
Date: Tue, 05 Aug 2014 12:43:44 +0200
Message-id: <1407235425-13937-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1407235425-13937-1-git-send-email-k.kozlowski@samsung.com>
References: <1407235425-13937-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xq7qpWx8EG5w4r2qxccZ6VovXLwwt
	ehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FmuP3GW3WD/jNYsDl0dLcw+bx+Yl9R59
	W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV0bRnJ3NBE3tFy5ZbLA2MH1i7GDk5JARMJA43LmCH
	sMUkLtxbz9bFyMUhJLCUUeLi5TeMEE4fk8S7w3/YQKrYBIwlNi9fAlYlIrCDUWL5vctg7cwC
	zxklnn4PB7GFBWIkmr7OYwKxWQRUJZZ9/wi2jlfAXeLh239Q6+QkTh6bDBbnFPCQWNB0Dywu
	BFTTuOE18wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLsyw7GxcesDjEKcDAq
	8fAanL4bLMSaWFZcmXuIUYKDWUmEV2LNg2Ah3pTEyqrUovz4otKc1OJDjEwcnFINjFoJp++G
	OwfvCXA78kG85W6Fybsqh7C9ju+s8jzup/2++Xje/Li+nND4X5NCIjIOPuh8965gp6Hv8t/3
	9iyft7/IRZo/vb1uj8qslBPavzxiT+/sl7wpe1FHUaVoV9FjObELRmxr3DP4HzGY6xbuVy91
	yFgc07ttwm3j8lC5icfSl++aKnjjgBJLcUaioRZzUXEiACVAtsURAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ref annotation for exynos_cpu_die() is not needed because the
function does not reference any __init/__exit symbol or call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes since v4:
1. Rebase on linux-next-20140804.
2. Add Reviewed-by Tomasz Figa.
---
 arch/arm/mach-exynos/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index a809f76c8160..83b20a38a598 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -373,7 +373,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
  *
  * Called with IRQs disabled
  */
-static void __ref exynos_cpu_die(unsigned int cpu)
+static void exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
-- 
1.9.1

