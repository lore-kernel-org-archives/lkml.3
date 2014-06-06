Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaFFRVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:21:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30858 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752646AbaFFRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:06 -0400
Message-Id: <20140606163034.516780857@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/6] tracing: Hopefully the last updates for 3.16 merge window
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should be the last of the patches I need for merging.
There's one feature which is to be able to increase the saved cmdlines
such that it is possible not to lose any.

Other fixes were memory not cleaned up properly on boot up if there
was a failed allocation, and other clean ups.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 4abbf33c8c68515f812e97ba0d36d3ee480fd78f


Steven Rostedt (Red Hat) (3)
      tracing: Convert stddev into u64 in tracepoint benchmark
      tracing: Only calculate stats of tracepoint benchmarks for 2^32 times
      tracing: Fix leak of ring buffer data when new instances creation fails

Yoshihiro YUNOMAE (3)
      tracing: Introduce saved_cmdlines_size file
      tracing: Return error if ftrace_trace_arrays list is empty
      tracing/kprobes: Avoid self tests if tracing is disabled on boot up

----
 trace.c           |  200 ++++++++++++++++++++++++++++++++++++++++++++++--------
 trace.h           |    3 
 trace_benchmark.c |   39 ++++++++--
 trace_events.c    |   13 +++
 trace_kprobe.c    |    3 
 5 files changed, 224 insertions(+), 34 deletions(-)
