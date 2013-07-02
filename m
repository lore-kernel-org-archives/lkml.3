Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3GBUY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:24:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3GBUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pK5H9oCbJukA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rHLL_R5lWt0A:10 a=ldSvwjvxFzZqoJGUs7EA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202216.623562799@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/14] tracing: updates and fixes for 3.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches mostly consists of fixes for 3.10. I'm posting this
and putting it into linux-next for a few days before asking Linus to pull.

I'll probably add a few more patches to linux-next as well, as there's
a few more bugs that have been discovered lately.

-- Steve

Alexander Z Lam (2):
      tracing: Make trace_marker use the correct per-instance buffer
      tracing: Protect ftrace_trace_arrays list in trace_events.c

Oleg Nesterov (4):
      tracing/kprobes: Avoid perf_trace_buf_*() if ->perf_events is empty
      tracing/kprobes: Kill probe_enable_lock
      tracing/kprobes: Turn trace_probe->files into list_head
      tracing/kprobes: Don't pass addr=ip to perf_trace_buf_submit()

Steven Rostedt (1):
      tracing: Failed to create system directory

Steven Rostedt (Red Hat) (4):
      tracing: Use flag buffer_disabled for irqsoff tracer
      ftrace: Do not run selftest if command line parameter is set
      tracing: Add trace_array_get/put() to handle instance refs better
      tracing: Get trace_array ref counts when accessing trace files

Tom Zanussi (3):
      tracing: Simplify code for showing of soft disabled flag
      tracing: Add missing syscall_metadata comment
      tracing: Fix disabling of soft disable

----
 include/trace/syscall.h       |    1 +
 kernel/trace/ftrace.c         |    5 +
 kernel/trace/trace.c          |  310 +++++++++++++++++++++++++++++++++--------
 kernel/trace/trace.h          |    3 +
 kernel/trace/trace_events.c   |   76 +++++++---
 kernel/trace/trace_irqsoff.c  |    4 +-
 kernel/trace/trace_kprobe.c   |  187 ++++++++-----------------
 kernel/trace/trace_selftest.c |   18 ++-
 8 files changed, 396 insertions(+), 208 deletions(-)
