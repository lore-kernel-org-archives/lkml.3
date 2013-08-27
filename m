Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3H0BUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:20:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3H0BHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 06/74] ARC: gdbserver breakage in Big-Endian configuration #2
Date: Mon, 26 Aug 2013 18:08:04 -0700
Message-Id: <20130827010425.907890475@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

[Based on mainline commit 352c1d95e3220d0: "ARC: stop using
pt_regs->orig_r8"]

Stop using orig_r8 as it could get clobbered by ST in trap_with_param,
and further it is semantically not needed either.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/syscall.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/syscall.h
+++ b/arch/arc/include/asm/syscall.h
@@ -18,7 +18,7 @@ static inline long
 syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
 	if (user_mode(regs) && in_syscall(regs))
-		return regs->orig_r8;
+		return regs->r8;
 	else
 		return -1;
 }
@@ -26,8 +26,7 @@ syscall_get_nr(struct task_struct *task,
 static inline void
 syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
-	/* XXX: I can't fathom how pt_regs->r8 will be clobbered ? */
-	regs->r8 = regs->orig_r8;
+	regs->r0 = regs->orig_r0;
 }
 
 static inline long


