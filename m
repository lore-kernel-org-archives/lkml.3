Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbbAWIOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:14:05 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:38080 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAWIOC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 03:14:02 -0500
Message-Id: <54C210DB02000078000588E3@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:14:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: log unhandled signals from do_trap() just like
 x86-64 does
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There not being a similar difference in page fault handling, I can't
see why 32- and 64-bit should differ in behavior here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/kernel/traps.c |    2 --
 1 file changed, 2 deletions(-)

--- 3.19-rc5/arch/x86/kernel/traps.c
+++ 3.19-rc5-ix86-show-unhandled-signals/arch/x86/kernel/traps.c
@@ -190,7 +190,6 @@ do_trap(int trapnr, int signr, char *str
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = trapnr;
 
-#ifdef CONFIG_X86_64
 	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
 	    printk_ratelimit()) {
 		pr_info("%s[%d] trap %s ip:%lx sp:%lx error:%lx",
@@ -199,7 +198,6 @@ do_trap(int trapnr, int signr, char *str
 		print_vma_addr(" in ", regs->ip);
 		pr_cont("\n");
 	}
-#endif
 
 	force_sig_info(signr, info ?: SEND_SIG_PRIV, tsk);
 }



