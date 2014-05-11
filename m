Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaEKTr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:47:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaEKTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.10 18/48] ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption
Date: Sun, 11 May 2014 21:19:52 +0200
Message-Id: <20140511191950.598356376@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 147aece29b15051173eb1e767018135361cdba89 upstream.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/entry.S |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -589,11 +589,7 @@ ARC_ENTRY ret_from_exception
 	; Pre-{IRQ,Trap,Exception} K/U mode from pt_regs->status32
 	ld  r8, [sp, PT_status32]   ; returning to User/Kernel Mode
 
-#ifdef CONFIG_PREEMPT
 	bbit0  r8, STATUS_U_BIT, resume_kernel_mode
-#else
-	bbit0  r8, STATUS_U_BIT, restore_regs
-#endif
 
 	; Before returning to User mode check-for-and-complete any pending work
 	; such as rescheduling/signal-delivery etc.
@@ -653,10 +649,10 @@ resume_user_mode_begin:
 	b      resume_user_mode_begin	; unconditionally back to U mode ret chks
 					; for single exit point from this block
 
-#ifdef CONFIG_PREEMPT
-
 resume_kernel_mode:
 
+#ifdef CONFIG_PREEMPT
+
 	; Can't preempt if preemption disabled
 	GET_CURR_THR_INFO_FROM_SP   r10
 	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]


