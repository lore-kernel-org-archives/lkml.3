Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbaDXQDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:03:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:31528 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758318AbaDXQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:21 -0400
Message-Id: <20140424160232.271454710@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/8] tracing: Mulitple tracers and other updates
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: ad1438a076e275b70d1a04de1364bc483e5a81db


Fabian Frederick (1):
      tracing: Add static to local functions

Mathias Krause (1):
      ftrace: Statically initialize pm notifier block

Petr Mladek (1):
      ftrace/x86: Fix order of warning messages when ftrace modifies code

Steven Rostedt (Red Hat) (5):
      ftrace: Remove global function list and call function directly
      tracing: Move tracing_max_latency into trace_array
      tracing: Move ftrace_max_lock into trace_array
      tracing: Allow wakeup tracers to be used by instances
      tracing: Allow irq/preempt tracers to be used by instances

----
 arch/x86/kernel/ftrace.c          |   2 +-
 include/linux/ftrace.h            |  20 ++---
 kernel/trace/ftrace.c             | 158 +++++++++++---------------------------
 kernel/trace/trace.c              |  60 ++++++---------
 kernel/trace/trace.h              |  36 ++++++---
 kernel/trace/trace_functions.c    |  55 +++++--------
 kernel/trace/trace_irqsoff.c      |  71 +++++++++--------
 kernel/trace/trace_sched_wakeup.c |  68 +++++++++-------
 kernel/trace/trace_selftest.c     |  69 +++++++++--------
 9 files changed, 239 insertions(+), 300 deletions(-)
