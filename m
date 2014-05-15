Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaEOIvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:51:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39903 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaEOIu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:50:59 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-2b-53747fef5fd1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH on kgene/for-next] ARM: EXYNOS: Do not calculate boot address
 twice
Date: Thu, 15 May 2014 10:50:59 +0200
Message-id: <1400143859-21457-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xq7rv60uCDb7PNrZ4/cLQonfBVTaL
	TY+vsVpc3jWHzWLG+X1MFrcv81qc/NPLaLF+xmsWBw6PluYeNo871/aweWxeUu/Rt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGf2TTzAXPOeoODNnBWsD41L2LkYODgkBE4np92K6GDmBTDGJ
	C/fWs3UxcnEICSxllJi17CkzSEJIoI9J4sBtBxCbTcBYYvPyJWBFIgI7GCWW37vMDpJgFqiV
	OLvzFCOILSwQKnH5CkQzi4CqxNOmOYwgy3gF3CUerpKFWCYncfLYZNYJjNwLGBlWMYqmliYX
	FCel5xrqFSfmFpfmpesl5+duYoSEyZcdjIuPWR1iFOBgVOLh7dhfHCzEmlhWXJl7iFGCg1lJ
	hNexuiRYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6OuR96dVafXzNsXI5u2L77pKVN686envt+s
	5K/VvXr87LSZOu/T0sVOZd/i1j19ajG1jkndZmFdS45Ez/HZPz5YG5h8zXhuYmpreNZmgcdq
	145JXg9YHSUl7y4+bVXZUDA9yXmObGpw6OnnUy22HQljXlJV+Zpz8dQjEjEnwgt6zz1Y8Opq
	zk0lluKMREMt5qLiRADCJaTi8QEAAA==
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
index 51cdabee10e5..c64bfc68ff9a 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -180,7 +180,7 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 				ret = PTR_ERR(boot_reg);
 				goto fail;
 			}
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, boot_reg);
 		}
 
 		call_firmware_op(cpu_boot, phys_cpu);
@@ -267,7 +267,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 
 			if (IS_ERR(boot_reg))
 				break;
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, boot_reg);
 		}
 	}
 }
-- 
1.9.1

