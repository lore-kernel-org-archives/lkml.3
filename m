Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaIXHlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:41:32 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49300 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaIXHlb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 24 Sep 2014 03:41:31 -0400
Message-Id: <542291CA0200007800038085@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 24 Sep 2014 08:41:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: unwind-annotate thunk_32.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/lib/thunk_32.S |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- 3.17-rc6/arch/x86/lib/thunk_32.S
+++ 3.17-rc6-ix86-annotate-thunks/arch/x86/lib/thunk_32.S
@@ -6,22 +6,31 @@
  */
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
+	#include <asm/dwarf2.h>
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
 	.macro thunk_ra name,func
 	.globl \name
 \name:
-	pushl %eax
-	pushl %ecx
-	pushl %edx
+	CFI_STARTPROC
+	pushl_cfi %eax
+	CFI_REL_OFFSET eax, 0
+	pushl_cfi %ecx
+	CFI_REL_OFFSET ecx, 0
+	pushl_cfi %edx
+	CFI_REL_OFFSET edx, 0
 	/* Place EIP in the arg1 */
 	movl 3*4(%esp), %eax
 	call \func
-	popl %edx
-	popl %ecx
-	popl %eax
+	popl_cfi %edx
+	CFI_RESTORE edx
+	popl_cfi %ecx
+	CFI_RESTORE ecx
+	popl_cfi %eax
+	CFI_RESTORE eax
 	ret
+	CFI_ENDPROC
 	_ASM_NOKPROBE(\name)
 	.endm
 



