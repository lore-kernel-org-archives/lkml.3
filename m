Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3JWCRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:17:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19936 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3JWCRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:17:41 -0400
X-Spam-Score: -100.8
Message-ID: <52673186.4050806@asianux.com>
Date: Wed, 23 Oct 2013 10:16:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        noamc@ezchip.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: remove '__init' for first_lines_of_secondary()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first_lines_of_secondary() is a '__init' function, but it may be called
by __cpu_up() by _cpu_up() by cpu_up() which is a normal export symbol
function. So recommend to remove '__init'.

The related warning (with allmodconfig):

    MODPOST vmlinux.o
  WARNING: vmlinux.o(.text+0x315c): Section mismatch in reference from the function __cpu_up() to the function .init.text:first_lines_of_secondary()
  The function __cpu_up() references
  the function __init first_lines_of_secondary().
  This is often because __cpu_up lacks a __init
  annotation or the annotation of first_lines_of_secondary is wrong.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/smp.h |    2 +-
 arch/arc/kernel/head.S     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/smp.h b/arch/arc/include/asm/smp.h
index c4fb211..eefc29f 100644
--- a/arch/arc/include/asm/smp.h
+++ b/arch/arc/include/asm/smp.h
@@ -30,7 +30,7 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
  * APIs provided by arch SMP code to rest of arch code
  */
 extern void __init smp_init_cpus(void);
-extern void __init first_lines_of_secondary(void);
+extern void first_lines_of_secondary(void);
 extern const char *arc_platform_smp_cpuinfo(void);
 
 /*
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 0f944f0..2c878e9 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -95,7 +95,7 @@ stext:
 ;----------------------------------------------------------------
 ;     First lines of code run by secondary before jumping to 'C'
 ;----------------------------------------------------------------
-	.section .init.text, "ax",@progbits
+	.section .text, "ax",@progbits
 	.type first_lines_of_secondary, @function
 	.globl first_lines_of_secondary
 
-- 
1.7.7.6
