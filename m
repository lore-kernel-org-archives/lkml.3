Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaKTPbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:31:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:33117 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932143AbaKTP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:18 -0500
Message-Id: <20141120152120.168868031@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 00/15] tracing/seq-buf/printk: New seq-buf utility from trace_seq for printk in NMI
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a separate branch for this change (although it's still going into
my for-next branch which ends up in linux-next. But that branch is made
up of multiple branches).

I'm hoping that it makes it into 3.19, but I'll give that choice to Linus.
This is based off of a point of my ftrace/core branch which is my normal
branch. But this one is separate because it may not be accepted. I'll just
have to wait and see. New work for tracing will not be based on this branch.

Although Linus may not accept it, I still want it in linux-next for further
testing.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: a9edc88093287183ac934be44f295f183b2c62dd


Steven Rostedt (Red Hat) (15):
      tracing: Create seq_buf layer in trace_seq
      tracing: Convert seq_buf_path() to be like seq_path()
      tracing: Convert seq_buf fields to be like seq_file fields
      tracing: Add a seq_buf_clear() helper and clear len and readpos in init
      seq_buf: Create seq_buf_used() to find out how much was written
      tracing: Clean up tracing_fill_pipe_page()
      tracing: Use trace_seq_used() and seq_buf_used() instead of len
      tracing: Add paranoid size check in trace_printk_seq()
      seq_buf: Add seq_buf_can_fit() helper function
      tracing: Have seq_buf use full buffer
      tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
      seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c        |  91 ++++++++-
 include/linux/percpu.h               |   3 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              | 136 +++++++++++++
 include/linux/trace_seq.h            |  30 ++-
 kernel/printk/printk.c               |  38 +++-
 kernel/trace/trace.c                 |  65 +++++--
 kernel/trace/trace_events.c          |   9 +-
 kernel/trace/trace_functions_graph.c |  11 +-
 kernel/trace/trace_seq.c             | 177 ++++++++---------
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 359 +++++++++++++++++++++++++++++++++++
 12 files changed, 779 insertions(+), 144 deletions(-)
