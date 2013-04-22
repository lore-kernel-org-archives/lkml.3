Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3DVOl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:41:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51582 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab3DVOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.181789872@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [43/75] ARM: Do 15e0d9e37c (ARM: pm: let platforms select
 cpu_suspend support) properly
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit b6c7aabd923a17af993c5a5d5d7995f0b27c000a upstream.

Let's do the changes properly and fix the same problem everywhere, not
just for one case.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2: mohawk doesn't support suspend at all]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -380,7 +380,7 @@ ENTRY(cpu_arm920_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm920_suspend_size
 .equ	cpu_arm920_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm920_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -395,7 +395,7 @@ ENTRY(cpu_arm926_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm926_suspend_size
 .equ	cpu_arm926_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm926_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
--- a/arch/arm/mm/proc-sa1100.S
+++ b/arch/arm/mm/proc-sa1100.S
@@ -169,7 +169,7 @@ ENTRY(cpu_sa1100_set_pte_ext)
 
 .globl	cpu_sa1100_suspend_size
 .equ	cpu_sa1100_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_sa1100_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c3, c0, 0		@ domain ID
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -129,7 +129,7 @@ ENTRY(cpu_v6_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/mach-s3c64xx/sleep.S */
 .globl	cpu_v6_suspend_size
 .equ	cpu_v6_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v6_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ FCSE/PID
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -407,7 +407,7 @@ ENTRY(cpu_xsc3_set_pte_ext)
 
 .globl	cpu_xsc3_suspend_size
 .equ	cpu_xsc3_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xsc3_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -521,7 +521,7 @@ ENTRY(cpu_xscale_set_pte_ext)
 
 .globl	cpu_xscale_suspend_size
 .equ	cpu_xscale_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xscale_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode

