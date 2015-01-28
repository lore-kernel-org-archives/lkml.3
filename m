Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbbA1BmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:42:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbbA1Bik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.14 30/77] x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs
Date: Tue, 27 Jan 2015 17:27:08 -0800
Message-Id: <20150128012746.875152126@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.10:
 - Use __kprobes instead of NOKPROBE_SYMBOL()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -365,7 +365,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage notrace __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -390,7 +390,7 @@ struct bad_iret_stack {
 	struct pt_regs regs;
 };
 
-asmlinkage __visible
+asmlinkage __visible notrace __kprobes
 struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
 {
 	/*


