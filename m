Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBNEAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:00:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBNEAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:00:03 -0500
Date: Thu, 13 Feb 2014 19:59:49 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-285c00adf651c9b1d6c73d5eee482d2a617a64c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1391845930-28580-12-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-12-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage: Make trace_hardirqs_on/
 off_caller visible
Git-Commit-ID: 285c00adf651c9b1d6c73d5eee482d2a617a64c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  285c00adf651c9b1d6c73d5eee482d2a617a64c1
Gitweb:     http://git.kernel.org/tip/285c00adf651c9b1d6c73d5eee482d2a617a64c1
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:08 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:14:54 -0800

asmlinkage: Make trace_hardirqs_on/off_caller visible

These functions are called from assembler, and thus need to be
__visible.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-12-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/trace/trace_irqsoff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..887ef88 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -498,14 +498,14 @@ void trace_hardirqs_off(void)
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
-void trace_hardirqs_on_caller(unsigned long caller_addr)
+__visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
-void trace_hardirqs_off_caller(unsigned long caller_addr)
+__visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, caller_addr);
