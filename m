Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963Ab3IDOho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:37:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934883Ab3IDOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:31 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=osw9kZqH3KoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QJ8-8LDrUTQA:10 a=VwQbUJbxAAAA:8 a=fsaxb7B6YrDdBVN_DMUA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143552.456506259@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:35:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 00/18] ftrace/rcu: Handle unsafe RCU functions and ftrace callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest patches to be queued for 3.12.

A little late, but as Dave Jones has been stumbling over this for a
while, I thought it would be good to get it in now. It's not that
complex to resolve any issues that may pop up.

I'll keep it in linux-next for a while to make sure it really is clean.

Note, the checker will stumble over a few functions in irq and scheduler
code if enabled. This is because those patches have not received Acks
from Thomas Gleixner and Peter Zijlstra. When I get those acks, I'll
add the changes to silent those too.

Thanks to Paul McKenney for reviewing the patches.

Enjoy,

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 7fb3a66134ed5a40448131cf4195823d22f70aa3


Alexander Z Lam (1)
      tracing: Make tracing_cpumask available for all instances

Steven Rostedt (Red Hat) (17)
      ftrace: Fix a slight race in modifying what function callback gets traced
      ftrace/rcu: Do not trace debug_lockdep_rcu_enabled()
      ftrace: Add hash list to save RCU unsafe functions
      ftrace: Do not set ftrace records for unsafe RCU when not allowed
      ftrace: Set ftrace internal function tracing RCU safe
      ftrace: Add test for ops against unsafe RCU functions in callback
      ftrace: Do not display non safe RCU functions in available_filter_functions
      ftrace: Add rcu_unsafe_filter_functions file
      ftrace: Add selftest to check if RCU unsafe functions are filtered properly
      ftrace: Create a RCU unsafe checker
      ftrace: Add infrastructure to stop RCU unsafe checker from checking
      ftrace: Disable RCU unsafe checker when function graph is enabled
      ftrace: Disable the RCU unsafe checker when irqsoff is enabled
      ftrace/lockdep: Have the RCU lockdep splat show what function triggered
      ftrace/rcu: Mark functions that are RCU unsafe
      ftrace/cpuidle/x86: Mark functions that are RCU unsafe
      ftrace: Print a message when the rcu checker is disabled

----
 b/arch/x86/kernel/process.c             |    2 
 b/drivers/cpuidle/cpuidle.c             |    2 
 b/include/asm-generic/vmlinux.lds.h     |   10 +
 b/include/linux/ftrace.h                |   38 +++++
 b/kernel/cpu/idle.c                     |    2 
 b/kernel/lockdep.c                      |    2 
 b/kernel/rcupdate.c                     |    2 
 b/kernel/rcutiny.c                      |    1 
 b/kernel/rcutree.c                      |    7 +
 b/kernel/trace/Kconfig                  |   22 +++
 b/kernel/trace/ftrace.c                 |   17 ++
 b/kernel/trace/trace.c                  |   37 ++---
 b/kernel/trace/trace.h                  |    1 
 b/kernel/trace/trace_functions.c        |   48 ++++++-
 b/kernel/trace/trace_irqsoff.c          |   16 ++
 b/kernel/trace/trace_selftest.c         |   94 +++++++++++++
 b/kernel/trace/trace_selftest_dynamic.c |    7 +
 include/linux/ftrace.h                  |    8 +
 kernel/trace/ftrace.c                   |  218 +++++++++++++++++++++++++++++---
 kernel/trace/trace.h                    |   17 ++
 kernel/trace/trace_functions.c          |   40 +++++
 21 files changed, 551 insertions(+), 40 deletions(-)
