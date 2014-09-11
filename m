Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaIKOtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:49:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22696 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752400AbaIKOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:10 -0400
Message-Id: <20140911144744.907770249@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/9] ftrace: 3.18 queue
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is my current queue for 3.18. The main update is a rewrite of the
trampoline accounting to get rid of the large memory usage needed
when having a trampoline for all functions (the current method creates
a descriptor for each function). The new way uses the current logic
of the hash tables, where an empty hash can mean all functions and
also the use of the notrace hash for all but a few functions.

OFF TOPIC:

As some of you may know, I've recently been having chronic pain
in my upper back, shoulder and down the arm. This has not let up, although
the narcotic drugs and steroids I've been prescribed has helped a lot.
Technically, I'm not suppose to be using a computer at all. But I couldn't
help myself and spent a few minutes here and there working on getting
these patches to pass all my tests. Note that I usually paid for that
work with an hour or so of more pain down the arm. There is a good chance
I will be having spinal surgery in the near future to remove the problem
cervical discs and have those vertebra fused. Hopefully, I will be back
to 100% shortly afterward. But until then, I will still be on hiatus from
the community again. But hopefully not for too long.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: fb5a613b4f310d6d520daf295547ab35b0ac58a3


Andreea-Cristina Bernat (1):
      kernel: trace_syscalls: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Dave Hansen (1):
      tracing: generate RCU warnings even when tracepoints are disabled

Steven Rostedt (Red Hat) (7):
      ftrace: Add separate function for non recursive callbacks
      ftrace: Add helper function ftrace_ops_get_func()
      ftrace: Set callback to ftrace_stub when no ops are registered
      ftrace: Remove freeing of old_hash from ftrace_hash_move()
      ftrace: Grab any ops for a rec for enabled_functions output
      ftrace: Annotate the ops operation on update
      ftrace: Replace tramp_hash with old_*_hash to save space

----
 include/linux/ftrace.h        |  10 +-
 include/linux/tracepoint.h    |  11 ++
 kernel/trace/ftrace.c         | 401 ++++++++++++++++++++++++------------------
 kernel/trace/trace_syscalls.c |   4 +-
 4 files changed, 248 insertions(+), 178 deletions(-)
