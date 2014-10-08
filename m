Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaJHIKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:10:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaJHIKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:10:18 -0400
Date: Wed, 8 Oct 2014 01:10:04 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-82ef36449d311a29b20f82fdce0de856057fa691@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <542291CA0200007800038085@mail.emea.novell.com>
References: <542291CA0200007800038085@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unwind-annotate thunk_32.S
Git-Commit-ID: 82ef36449d311a29b20f82fdce0de856057fa691
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

Commit-ID:  82ef36449d311a29b20f82fdce0de856057fa691
Gitweb:     http://git.kernel.org/tip/82ef36449d311a29b20f82fdce0de856057fa691
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 24 Sep 2014 08:41:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 10:05:50 +0200

x86: Unwind-annotate thunk_32.S

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/542291CA0200007800038085@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/thunk_32.S | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index e9acf5f..5f72e53 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -11,9 +11,13 @@
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
@@ -21,10 +25,14 @@
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
 
