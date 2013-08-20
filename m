Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3HTII5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:08:57 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:59817 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3HTIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:08:54 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <noamc@ezchip.com>,
        <Anton.Kolesov@synopsys.com>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/2] ARC: gdbserver breakage in Big-Endian configuration #2
Date: Tue, 20 Aug 2013 13:38:11 +0530
Message-ID: <1376986091-30241-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376986091-30241-1-git-send-email-vgupta@synopsys.com>
References: <20130820062901.GA3758@kroah.com>
 <1376986091-30241-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Based on mainline commit 352c1d95e3220d0: "ARC: stop using
pt_regs->orig_r8"]

Stop using orig_r8 as it could get clobbered by ST in trap_with_param,
and further it is semantically not needed either.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/syscall.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arc/include/asm/syscall.h b/arch/arc/include/asm/syscall.h
index 33ab304..29de098 100644
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
@@ -26,8 +26,7 @@ syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 static inline void
 syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
-	/* XXX: I can't fathom how pt_regs->r8 will be clobbered ? */
-	regs->r8 = regs->orig_r8;
+	regs->r0 = regs->orig_r0;
 }
 
 static inline long
-- 
1.8.1.2

