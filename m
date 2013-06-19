Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab3FSSnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:43:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab3FSSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:43:28 -0400
Date: Wed, 19 Jun 2013 11:43:13 -0700
From: tip-bot for Rusty Russell <tipbot@zytor.com>
Message-ID: <tip-5a802e15308f152247433d87050d1bfbf9613483@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, tglx@linutronix.de, prasad@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, tglx@linutronix.de, prasad@linux.vnet.ibm.com
In-Reply-To: <1371357768-4968-8-git-send-email-rusty@rustcorp.com.au>
References: <1371357768-4968-8-git-send-email-rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Remove weird PTR_ERR() in do_debug
Git-Commit-ID: 5a802e15308f152247433d87050d1bfbf9613483
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:43:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a802e15308f152247433d87050d1bfbf9613483
Gitweb:     http://git.kernel.org/tip/5a802e15308f152247433d87050d1bfbf9613483
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Sun, 16 Jun 2013 14:12:47 +0930
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 15:01:36 +0200

x86: Remove weird PTR_ERR() in do_debug

62edab905 changed the argument to notify_die() from dr6 to &dr6,
but weirdly, used PTR_ERR() to cast it to a long.  Since dr6 is
on the stack, this is an abuse of PTR_ERR().  Cast to long, as
per kernel standard.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1371357768-4968-8-git-send-email-rusty@rustcorp.com.au
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a8..9340dfb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -437,7 +437,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
+	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
