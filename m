Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbbA2DZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:25:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762069AbbA2CfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 050/139] x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs
Date: Wed, 28 Jan 2015 14:19:53 -0800
Message-Id: <1422483682-15393-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 7ddc6a2199f1da405a2fb68c40db8899b1a8cd87 upstream.

These functions can be executed on the int3 stack, so kprobes
are dangerous. Tracing is probably a bad idea, too.

Fixes: b645af2d5905 ("x86_64, traps: Rework bad_iret")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/50e33d26adca60816f3ba968875801652507d0c4.1416870125.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/traps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 574b356..c83c6af 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -369,7 +369,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -394,7 +394,7 @@ struct bad_iret_stack {
 	struct pt_regs regs;
 };
 
-asmlinkage __visible
+asmlinkage __visible notrace
 struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 {
 	/*
-- 
1.9.1

