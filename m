Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaB0Ptf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22937 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753383AbaB0Pt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:27 -0500
Message-Id: <20140227154616.703252665@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 27 Feb 2014 10:46:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFA][PATCH 0/5] tracing: Ftrace error sync fix and tracepoint warn on failure
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of changes I plan on pushing for this release and
to stable. Feel free to ack (or nack, but I hope you don't ;-).

I pushed this up into my git repo as well, but it may change depending
on comments.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace/urgent

Head SHA1: dd44790df744e71674558ae7ceb9dde3ed6f419c


Petr Mladek (1):
      ftrace/x86: One more missing sync after fixup of function modification failure

Steven Rostedt (Red Hat) (4):
      ftrace/x86: Run a sync after fixup on failure
      tracing: Do not add event files for modules that fail tracepoints
      tracepoint: Do not waste memory on mods with no tracepoints
      tracepoint: Warn and notify if tracepoints are not loaded due to module taint

----
 arch/x86/kernel/ftrace.c    |  7 ++++---
 include/linux/tracepoint.h  |  6 ++++++
 kernel/trace/trace_events.c |  4 ++++
 kernel/tracepoint.c         | 17 ++++++++++++++++-
 4 files changed, 30 insertions(+), 4 deletions(-)
