Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3KKQWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:22:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KKQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:22:33 -0500
Date: Mon, 11 Nov 2013 08:22:10 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-a4f61dec55c1bdebb84ba77212ebf98f7247736c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de
In-Reply-To: <20131111082955.GB12405@gmail.com>
References: <20131111082955.GB12405@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86, trace:
  Change user|kernel_page_fault to page_fault_user|kernel
Git-Commit-ID: a4f61dec55c1bdebb84ba77212ebf98f7247736c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 08:22:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4f61dec55c1bdebb84ba77212ebf98f7247736c
Gitweb:     http://git.kernel.org/tip/a4f61dec55c1bdebb84ba77212ebf98f7247736c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 11 Nov 2013 08:15:40 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 11 Nov 2013 08:15:40 -0800

x86, trace: Change user|kernel_page_fault to page_fault_user|kernel

Tracepoints are named hierachially, and it makes more sense to keep a
general flow of information level from general to specific from left
to right, i.e.

	x86_exceptions.page_fault_user|kernel

rather than

	x86_exceptions.user|kernel_page_fault

Suggested-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20131111082955.GB12405@gmail.com
---
 arch/x86/include/asm/trace/exceptions.h | 4 ++--
 arch/x86/mm/fault.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
index 86540c0..2fbc66c 100644
--- a/arch/x86/include/asm/trace/exceptions.h
+++ b/arch/x86/include/asm/trace/exceptions.h
@@ -40,8 +40,8 @@ DEFINE_EVENT_FN(x86_exceptions, name,				\
 	trace_irq_vector_regfunc,				\
 	trace_irq_vector_unregfunc);
 
-DEFINE_PAGE_FAULT_EVENT(user_page_fault);
-DEFINE_PAGE_FAULT_EVENT(kernel_page_fault);
+DEFINE_PAGE_FAULT_EVENT(page_fault_user);
+DEFINE_PAGE_FAULT_EVENT(page_fault_kernel);
 
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f2730cbc..e532230 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1239,9 +1239,9 @@ static void trace_page_fault_entries(struct pt_regs *regs,
 				     unsigned long error_code)
 {
 	if (user_mode(regs))
-		trace_user_page_fault(read_cr2(), regs, error_code);
+		trace_page_fault_user(read_cr2(), regs, error_code);
 	else
-		trace_kernel_page_fault(read_cr2(), regs, error_code);
+		trace_page_fault_kernel(read_cr2(), regs, error_code);
 }
 
 dotraplinkage void __kprobes
