Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3FPEq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:58 -0400
Received: from ozlabs.org ([203.10.76.45]:48694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab3FPEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
        "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH 8/9] x86: remove weird PTR_ERR() in do_debug
Date: Sun, 16 Jun 2013 14:12:47 +0930
Message-Id: <1371357768-4968-8-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

62edab905 changed the argument to notify_die() from dr6 to &dr6, but weirdly,
used PTR_ERR() to cast it to a long.  Since dr6 is on the stack, this is
an abuse of PTR_ERR().  Cast to long, as per kernel standard.

Cc: x86@kernel.org
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
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
 
-- 
1.8.1.2

