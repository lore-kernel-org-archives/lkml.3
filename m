Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3EIFqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:46:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42603 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3EIFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:46:51 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-89-518b384880c2
Subject: [PATCH 00/11] tracing: bugfix and kprobe-based dynamic event updates
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:05 +0900
Message-ID: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of updating kprobe-based dynamic event for
supporting soft-disabling mode and multiple buffers.
This also has some bugfixes of ftrace which I found
including an important deadlock fix.

I think uprobe-based events can also support multi-buffer
and soft-disabling as I did in this series.

---

Masami Hiramatsu (11):
      [BUGFIX] tracing: Return 0 if event_enable_func succeeded
      [BUGFIX] ftrace, kprobes: Fix a deadlock on ftrace_regex_lock
      ftrace: Cleanup regex_lock and ftrace_lock around hash updating
      [BUGFIX] tracing/kprobes: Fix to increment return event probe hit-count
      tracing: Indicate enabled soft-mode in enable file
      [BUGFIX] tracing: Modify soft-mode only if no other referrer
      [TRIVIAL] tracing/kprobes: Use bool for retprobe checker
      tracing/kprobes: Increment probe hit-count even if it is used by perf
      tracing/kprobes: Pass trace_probe directly from dispatcher
      tracing/kprobes: Support ftrace_event_file base multibuffer
      tracing/kprobes: Support soft-mode disabling


 include/linux/ftrace.h       |    1 
 include/linux/ftrace_event.h |    1 
 kernel/kprobes.c             |    1 
 kernel/trace/ftrace.c        |   82 +++++++-----
 kernel/trace/trace_events.c  |   19 ++-
 kernel/trace/trace_kprobe.c  |  289 ++++++++++++++++++++++++++++++++++--------
 6 files changed, 305 insertions(+), 88 deletions(-)

-- 
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
IT Management Research Dept. and Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
