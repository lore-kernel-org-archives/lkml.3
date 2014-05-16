Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaEPJaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:30:03 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51379 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522AbaEPJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:30:00 -0400
Message-ID: <1400232598.20342.16.camel@x220>
Subject: [PATCH] ARM: remove ARM710 specific assembler code
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 11:29:58 +0200
In-Reply-To: <4305975.PvMXZQ020k@wuerfel>
References: <1364507176.1345.45.camel@x61.thuisdomein>
	 <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220>
	 <4305975.PvMXZQ020k@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 09:29:58.0796 (UTC) FILETIME=[67C924C0:01CF70E9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for ARM710 CPUs was removed in v3.5. But a few lines of ARM710
specific assembler code were left in the tree. Remove these too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This minor cleanup was suggested by Arnd. This patch is mostly
guesswork, as I already told Arnd, since I have never touched ARM
assembler before (as far as I can remember). Untested too! And this does
need testing.

 arch/arm/mm/proc-arm720.S | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm/mm/proc-arm720.S b/arch/arm/mm/proc-arm720.S
index d42c37f9f5bc..6699f91a6a0f 100644
--- a/arch/arm/mm/proc-arm720.S
+++ b/arch/arm/mm/proc-arm720.S
@@ -116,34 +116,6 @@ ENTRY(cpu_arm720_reset)
 ENDPROC(cpu_arm720_reset)
 		.popsection
 
-	.type	__arm710_setup, #function
-__arm710_setup:
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c7, 0		@ invalidate caches
-#ifdef CONFIG_MMU
-	mcr	p15, 0, r0, c8, c7, 0		@ flush TLB (v4)
-#endif
-	mrc	p15, 0, r0, c1, c0		@ get control register
-	ldr	r5, arm710_cr1_clear
-	bic	r0, r0, r5
-	ldr	r5, arm710_cr1_set
-	orr	r0, r0, r5
-	mov	pc, lr				@ __ret (head.S)
-	.size	__arm710_setup, . - __arm710_setup
-
-	/*
-	 *  R
-	 * .RVI ZFRS BLDP WCAM
-	 * .... 0001 ..11 1101
-	 * 
-	 */
-	.type	arm710_cr1_clear, #object
-	.type	arm710_cr1_set, #object
-arm710_cr1_clear:
-	.word	0x0f3f
-arm710_cr1_set:
-	.word	0x013d
-
 	.type	__arm720_setup, #function
 __arm720_setup:
 	mov	r0, #0
@@ -177,7 +149,6 @@ arm720_crval:
 
 	string	cpu_arch_name, "armv4t"
 	string	cpu_elf_name, "v4"
-	string	cpu_arm710_name, "ARM710T"
 	string	cpu_arm720_name, "ARM720T"
 
 		.align
@@ -215,5 +186,4 @@ __\name\()_proc_info:
 		.size	__\name\()_proc_info, . - __\name\()_proc_info
 .endm
 
-	arm720_proc_info arm710, 0x41807100, 0xffffff00, cpu_arm710_name, __arm710_setup
 	arm720_proc_info arm720, 0x41807200, 0xffffff00, cpu_arm720_name, __arm720_setup
-- 
1.9.0

