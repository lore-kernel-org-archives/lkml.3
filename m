Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaJHKdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:33:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbaJHKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:33:43 -0400
Date: Wed, 8 Oct 2014 03:33:23 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-f74954f01ec9bb2004bcc24f247d1f26f1063ad2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <542291CA0200007800038085@mail.emea.novell.com>
References: <542291CA0200007800038085@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unwind-annotate thunk_32.S
Git-Commit-ID: f74954f01ec9bb2004bcc24f247d1f26f1063ad2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f74954f01ec9bb2004bcc24f247d1f26f1063ad2
Gitweb:     http://git.kernel.org/tip/f74954f01ec9bb2004bcc24f247d1f26f1063ad2
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 24 Sep 2014 08:41:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 12:31:45 +0200

x86: Unwind-annotate thunk_32.S

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/542291CA0200007800038085@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/thunk_32.S | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index e9acf5f..e28cdaf 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -6,14 +6,19 @@
  */
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
+	#include <asm/dwarf2.h>
 
 	/* put return address in eax (arg1) */
 	.macro THUNK name, func, put_ret_addr_in_eax=0
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
 
 	.if \put_ret_addr_in_eax
 	/* Place EIP in the arg1 */
@@ -21,10 +26,14 @@
 	.endif
 
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
 
