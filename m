Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaKFWly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaKFWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Allen Pais <allen.pais@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/162] sparc64: correctly recognise M6 and M7 cpu type
Date: Thu,  6 Nov 2014 14:35:05 -0800
Message-Id: <1415313426-9622-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pais <allen.pais@oracle.com>

[ Upstream commit cadbb58039f7cab1def9c931012ab04c953a6997 ]

The following patch adds support for correctly
recognising M6 and M7 cpu type.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/spitfire.h |  2 ++
 arch/sparc/kernel/cpu.c           | 12 ++++++++++++
 arch/sparc/kernel/head_64.S       | 12 ++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/sparc/include/asm/spitfire.h b/arch/sparc/include/asm/spitfire.h
index 6b67e50..69424d4 100644
--- a/arch/sparc/include/asm/spitfire.h
+++ b/arch/sparc/include/asm/spitfire.h
@@ -45,6 +45,8 @@
 #define SUN4V_CHIP_NIAGARA3	0x03
 #define SUN4V_CHIP_NIAGARA4	0x04
 #define SUN4V_CHIP_NIAGARA5	0x05
+#define SUN4V_CHIP_SPARC_M6	0x06
+#define SUN4V_CHIP_SPARC_M7	0x07
 #define SUN4V_CHIP_SPARC64X	0x8a
 #define SUN4V_CHIP_UNKNOWN	0xff
 
diff --git a/arch/sparc/kernel/cpu.c b/arch/sparc/kernel/cpu.c
index 5c51258..52e10de 100644
--- a/arch/sparc/kernel/cpu.c
+++ b/arch/sparc/kernel/cpu.c
@@ -493,6 +493,18 @@ static void __init sun4v_cpu_probe(void)
 		sparc_pmu_type = "niagara5";
 		break;
 
+	case SUN4V_CHIP_SPARC_M6:
+		sparc_cpu_type = "SPARC-M6";
+		sparc_fpu_type = "SPARC-M6 integrated FPU";
+		sparc_pmu_type = "sparc-m6";
+		break;
+
+	case SUN4V_CHIP_SPARC_M7:
+		sparc_cpu_type = "SPARC-M7";
+		sparc_fpu_type = "SPARC-M7 integrated FPU";
+		sparc_pmu_type = "sparc-m7";
+		break;
+
 	case SUN4V_CHIP_SPARC64X:
 		sparc_cpu_type = "SPARC64-X";
 		sparc_fpu_type = "SPARC64-X integrated FPU";
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 452f04f..4fdeb80 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -427,6 +427,12 @@ sun4v_chip_type:
 	cmp	%g2, '5'
 	be,pt	%xcc, 5f
 	 mov	SUN4V_CHIP_NIAGARA5, %g4
+	cmp	%g2, '6'
+	be,pt	%xcc, 5f
+	 mov	SUN4V_CHIP_SPARC_M6, %g4
+	cmp	%g2, '7'
+	be,pt	%xcc, 5f
+	 mov	SUN4V_CHIP_SPARC_M7, %g4
 	ba,pt	%xcc, 49f
 	 nop
 
@@ -585,6 +591,12 @@ niagara_tlb_fixup:
 	cmp	%g1, SUN4V_CHIP_NIAGARA5
 	be,pt	%xcc, niagara4_patch
 	 nop
+	cmp	%g1, SUN4V_CHIP_SPARC_M6
+	be,pt	%xcc, niagara4_patch
+	 nop
+	cmp	%g1, SUN4V_CHIP_SPARC_M7
+	be,pt	%xcc, niagara4_patch
+	 nop
 
 	call	generic_patch_copyops
 	 nop
-- 
1.9.1

