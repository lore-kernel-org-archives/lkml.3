Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3C0JuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:50:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45955 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3C0JuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:50:04 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 00/14] event tracing expose change and bugfix/cleanup
Date: Wed, 27 Mar 2013 17:48:42 +0800
Message-ID: <1364377737-10540-2-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Hi steven,

This patchset contain:
1) event tracing expose work (v2)
   this expose work rewrited compare with v1, new implementation
   is based on multi-instances buffer work, it also integrate syscall
   tracing code to use same event backend store mechanism.
   The change include patch 1-7(patch 2 also fix a long-term minor bug)

2) some cleanup
   This include patch 8-12.

3) patch 13 fix libtraceevent warning

4) patch 14 fix a regression bug of perf function tracing
   This patch also need send to stable tree.

Note that these patches is based on latest linux-trace git tree:
(on top of multi-instances buffer implementation)

    git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
    tip/perf/core

All patches pass basic testing.

zhangwei(Jovi) (14):
  tracing: move trace_array definition into include/linux/trace_array.h
  tracing: fix irqs-off tag display in syscall tracing
  tracing: expose event tracing infrastructure
  tracing: add private data field into struct ftrace_event_file
  tracing: switch syscall tracing to use event_trace_ops backend
  tracing: export syscall metadata
  tracing: expose structure ftrace_event_field
  tracing: remove TRACE_EVENT_TYPE enum definition
  tracing: remove obsolete macro guard _TRACE_PROFILE_INIT
  tracing: remove ftrace(...) function
  tracing: use per trace_array clock_id instead of global
    trace_clock_id
  tracing: guard tracing_selftest_disabled by
    CONFIG_FTRACE_STARTUP_TEST
  libtraceevent: add libtraceevent prefix in warning message
  tracing: fix regression of perf function tracing

 include/linux/ftrace_event.h       |   38 ++++++++++
 include/linux/trace_array.h        |  118 +++++++++++++++++++++++++++++
 include/trace/ftrace.h             |   71 ++++++------------
 include/trace/syscall.h            |    1 +
 kernel/trace/ftrace.c              |    7 +-
 kernel/trace/trace.c               |   27 +++----
 kernel/trace/trace.h               |  143 +-----------------------------------
 kernel/trace/trace_events.c        |   55 ++++++++++++++
 kernel/trace/trace_syscalls.c      |   51 ++++++-------
 tools/lib/traceevent/event-parse.c |    2 +-
 10 files changed, 277 insertions(+), 236 deletions(-)
 create mode 100644 include/linux/trace_array.h

-- 
1.7.9.7


