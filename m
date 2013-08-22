Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3HVWhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:37:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3HVWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:37:25 -0400
Subject: Patch "ARC: gdbserver breakage in Big-Endian configuration #2" has been added to the 3.10-stable tree
To: Vineet.Gupta1@synopsys.com, Anton.Kolesov@synopsys.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        noamc@ezchip.com, stable@vger.kernel.org, vgupta@synopsys.com
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 22 Aug 2013 15:37:24 -0700
In-Reply-To: <1376986091-30241-3-git-send-email-vgupta@synopsys.com>
Message-ID: <13772110442973@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ARC: gdbserver breakage in Big-Endian configuration #2

to the 3.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arc-gdbserver-breakage-in-big-endian-configuration-2.patch
and it can be found in the queue-3.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From Vineet.Gupta1@synopsys.com  Thu Aug 22 15:33:34 2013
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Date: Tue, 20 Aug 2013 13:38:11 +0530
Subject: ARC: gdbserver breakage in Big-Endian configuration #2
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <noamc@ezchip.com>, <Anton.Kolesov@synopsys.com>, <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Message-ID: <1376986091-30241-3-git-send-email-vgupta@synopsys.com>

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


Patches currently in stable-queue which might be from Vineet.Gupta1@synopsys.com are

queue-3.10/arc-gdbserver-breakage-in-big-endian-configuration-1.patch
queue-3.10/arc-gdbserver-breakage-in-big-endian-configuration-2.patch
