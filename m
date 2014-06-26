Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaFZLqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:46:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12566 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbaFZLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:46:11 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3e-53ac080043c3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND] ARM: EXYNOS: Do not calculate boot address twice
Date: Thu, 26 Jun 2014 13:46:03 +0200
Message-id: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7oMHGuCDT6+tLbYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbnPzTy2ixfsZrFgduj5bmHjaP
	O9f2sHlsXlLv0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBkfZ85iLnjOUdGy5R1TA+NS9i5G
	Tg4JAROJRxs2MkHYYhIX7q1n62Lk4hASWMoo0bVvOhOE08ck8ehlCwtIFZuAscTm5UvAqkQE
	djBKLL93mR3EYRaYyCSxpe0HWJWwgIfEz6vvmUFsFgFViat9h8F28Aq4Sxz7/o4ZYp+cxMlj
	k1knMHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESTF92MC4+ZnWIUYCDUYmHV2Lu
	6mAh1sSy4srcQ4wSHMxKIrwiv4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGMO95iUFx98qFrJ1
	f+L5kGXH4fczZsnYrdsizdTzMOD/2yX/Ds9P0Gqx/HzdebPiq4v98x7dNOteuPop5xTB7WI2
	cmu224UJpZzPOexy8cOpZu4X3yya/Fr/xUQxMzyOtv2tLWsVHcvim+6jNe+92q+Jrz6Wqekq
	qbO9n7WjuC93xXrJp9xVu5VYijMSDbWYi4oTAf1w82QEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b3205dea8fbf ("ARM: EXYNOS: Map SYSRAM through generic DT
bindings") introduced local variable boot_reg where boot address from
cpu_boot_reg() call is stored. Re-use it instead calling cpu_boot_reg()
again.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 1c8d31e39520..55ed2e6729c5 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -155,7 +155,7 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 				ret = PTR_ERR(boot_reg);
 				goto fail;
 			}
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, boot_reg);
 		}
 
 		call_firmware_op(cpu_boot, phys_cpu);
@@ -242,7 +242,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 
 			if (IS_ERR(boot_reg))
 				break;
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, boot_reg);
 		}
 	}
 }
-- 
1.9.1

