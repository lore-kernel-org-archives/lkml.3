Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060AbaLMEWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:22:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6342 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069AbaLMEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:22:18 -0500
Message-Id: <20141213042144.599602592@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 12 Dec 2014 23:21:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: Fixes old and new
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Here's two fixes:

1) Discovered by Fengguang Wu's tests. I changed the parameters to
   the function graph x86 prepare_ftrace_return() call but forgot
   to update the call from entry_32 (i386 version). This patch corrects
   that.

2) I was tracing some code and found that the sched_switch tracepoint
   was showing tasks in the INTERRUPTIBLE state as RUNNING. This was
   due to the updates to convert preempt_count into a per_cpu variable.
   The tracepoint logic was made to use the task's saved_preempt_count
   which could hold a stale "PREEMPT_ACTIVE", instead of using the
   current preempt_count() call.

Please pull the latest trace-fixes-v3.18 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.18

Tag SHA1: acbe5cd526bb9de84fe73d68f8d7bfcbde8ab9f4
Head SHA1: aee4e5f3d3abb7a2239dd02f6d8fb173413fd02f


Steven Rostedt (Red Hat) (2):
      ftrace/x86: Update i386 call to prepare_ftrace_return()
      tracing/sched: Check preempt_count() for current when reading task->state

----
 arch/x86/kernel/entry_32.S   | 6 +++---
 include/trace/events/sched.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
