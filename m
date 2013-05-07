Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab3EGE2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:28:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3EGE0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:26:00 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ivOjn_Gv3FMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EPFvfYCz1DQA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=0AWPF2qeU-xyIF9p1esA:9 a=jeBq3FmKZ4MA:10 a=HEOv9xTZUOywZFQr:21 a=Zav5JBlrvi9NyppZ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035850.947586356@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [060/126] ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend
 support) properly
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0060-ARM-Do-15e0d9e37c-ARM-pm-let-platforms-select-cpu_su.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit b6c7aabd923a17af993c5a5d5d7995f0b27c000a ]

Let's do the changes properly and fix the same problem everywhere, not
just for one case.

Cc: <stable@vger.kernel.org> # kernels containing 15e0d9e37c or equivalent
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mm/proc-arm920.S |    2 +-
 arch/arm/mm/proc-arm926.S |    2 +-
 arch/arm/mm/proc-mohawk.S |    2 +-
 arch/arm/mm/proc-sa1100.S |    2 +-
 arch/arm/mm/proc-v6.S     |    2 +-
 arch/arm/mm/proc-xsc3.S   |    2 +-
 arch/arm/mm/proc-xscale.S |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index 1a8c138..2a5691a 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -384,7 +384,7 @@ ENTRY(cpu_arm920_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm920_suspend_size
 .equ	cpu_arm920_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm920_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index c31e62c..5e174e4 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -399,7 +399,7 @@ ENTRY(cpu_arm926_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm926_suspend_size
 .equ	cpu_arm926_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm926_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index fbb2124..3fbb2c2 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -347,7 +347,7 @@ ENTRY(cpu_mohawk_set_pte_ext)
 
 .globl	cpu_mohawk_suspend_size
 .equ	cpu_mohawk_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_mohawk_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
diff --git a/arch/arm/mm/proc-sa1100.S b/arch/arm/mm/proc-sa1100.S
index 3aa0da1..d92dfd0 100644
--- a/arch/arm/mm/proc-sa1100.S
+++ b/arch/arm/mm/proc-sa1100.S
@@ -172,7 +172,7 @@ ENTRY(cpu_sa1100_set_pte_ext)
 
 .globl	cpu_sa1100_suspend_size
 .equ	cpu_sa1100_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_sa1100_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c3, c0, 0		@ domain ID
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 86b8b48..d9b9f8b 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -138,7 +138,7 @@ ENTRY(cpu_v6_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/mach-s3c64xx/sleep.S */
 .globl	cpu_v6_suspend_size
 .equ	cpu_v6_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v6_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ FCSE/PID
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index b0d5786..a2d1e86 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -410,7 +410,7 @@ ENTRY(cpu_xsc3_set_pte_ext)
 
 .globl	cpu_xsc3_suspend_size
 .equ	cpu_xsc3_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xsc3_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 4ffebaa..9882153 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -524,7 +524,7 @@ ENTRY(cpu_xscale_set_pte_ext)
 
 .globl	cpu_xscale_suspend_size
 .equ	cpu_xscale_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xscale_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
-- 
1.7.10.4


