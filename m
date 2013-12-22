Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3LVDLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 22:11:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21591 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772Ab3LVDLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 22:11:49 -0500
Message-Id: <20131222030759.339128630@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 21 Dec 2013 22:07:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/2] tracing: Fixes to event_triggers patches found by Fengguang's test bot
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom,

This is the changes I made to fix the reports that Fengguang's kbuild test bot
found. I folded in your change that fixes the bug with -ENODEV used in kernel.h.

Paul,

I've Cc'd you because the second patch is fixing up RCU notation. The filter
is protect by rcu_sched, and the first hunk of the patch is performed
within a rcu_read_lock_sched(), and the second hunk is done on the write
side. The tmp variable holds the old value, the value is updated, and
then the new value gets updated. I emailed you so that you can verify
that this all works.

Thanks!

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftrace/core

Head SHA1: 05741e383228a79eeec83644181255d2171f9f7c


Steven Rostedt (Red Hat) (2):
      tracing: Add generic tracing_lseek() function
      tracing: Fix rcu handling of event_trigger_data filter field

----
 include/linux/ftrace.h              |  2 --
 kernel/trace/ftrace.c               | 25 ++++++-------------------
 kernel/trace/trace.c                | 14 +++++++++-----
 kernel/trace/trace.h                |  4 +++-
 kernel/trace/trace_events_trigger.c | 10 ++++++----
 kernel/trace/trace_stack.c          |  2 +-
 6 files changed, 25 insertions(+), 32 deletions(-)
