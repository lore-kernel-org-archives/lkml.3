Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3GXP3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:29:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3GXP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:18 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=NeICv2Dj2zQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Tv5UlD91rIwA:10 a=VwQbUJbxAAAA:8 a=W-kwB9Lbg8HZOQOAn74A:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130724152706.535638468@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Jul 2013 11:27:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 0/9] tracing: A few more fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg is working on fixing a very tight race between opening a event file
and deleting that event at the same time (both must be done as root).

I also found a bug while testing Oleg's patches which has to do with
a race with kprobes using the function tracer.

There's also a deadlock fix that was introduced with the previous fixes.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 592795bd4c750beccb3babba856960880e621d42


Oleg Nesterov (7):
      tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()
      tracing: Change tracing_pipe_fops() to rely on tracing_get_cpu()
      tracing: Change tracing_buffers_fops to rely on tracing_get_cpu()
      tracing: Change tracing_stats_fops to rely on tracing_get_cpu()
      tracing: Change tracing_entries_fops to rely on tracing_get_cpu()
      tracing: Change tracing_fops/snapshot_fops to rely on tracing_get_cpu()
      tracing: Kill trace_cpu struct/members

Steven Rostedt (Red Hat) (2):
      ftrace: Add check for NULL regs if ops has SAVE_REGS set
      tracing: Remove locking trace_types_lock from tracing_reset_all_online_cpus()

----
 kernel/trace/ftrace.c |   18 ++++-
 kernel/trace/trace.c  |  197 ++++++++++++++++++++-----------------------------
 kernel/trace/trace.h  |    8 --
 3 files changed, 95 insertions(+), 128 deletions(-)
