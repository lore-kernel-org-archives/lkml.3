Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936580Ab3DJD13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:27:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28123 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936462Ab3DJD10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:27:26 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH v3 00/12] event tracing expose change and bugfix/cleanup
Date: Wed, 10 Apr 2013 11:26:21 +0800
Message-ID: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Hi steven,

I have reworked this patchset again with minor change.
[v2 -> v3:
-   change trace_descripte_t defintion in patch 3
-   new patch "export ftrace_events"
-   remove patch "export syscall metadata"
    (syscall tracing are use same event_trace_ops backend as normal event tracepoint,
     so there's no need to export anything of syscall)
-   remove private data field in ftrace_event_file struct (also not needed)
]

This patchset contain:
1) event tracing expose work (v3)
   new implementation is based on multi-instances buffer work,
   it also integrate syscall tracing code to use same event backend store mechanism.
   The change include patch 1-6(patch 2 also fix a long-term minor bug)

2) some cleanup
   This include patch 7-11.

3) patch 12 fix libtraceevent warning

Note that these patches is based on latest linux-trace git tree:
(on top of multi-instances buffer implementation)

    git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
    tip/perf/core

All patches pass basic testing.


Note that ktap code already make use of this event tracing export work,
If you are interesting, you can check ktap code in below link to see
how this export work is implemented by external modules.
	https://github.com/ktap/ktap/blob/master/library/trace.c

And even more, you can try it. :)

Thanks very much

zhangwei(Jovi) (12):
  tracing: move trace_array definition into include/linux/trace_array.h
  tracing: fix irqs-off tag display in syscall tracing
  tracing: expose event tracing infrastructure
  tracing: export ftrace_events
  tracing: switch syscall tracing to use event_trace_ops backend
  tracing: expose structure ftrace_event_field
  tracing: remove TRACE_EVENT_TYPE enum definition
  tracing: remove obsolete macro guard _TRACE_PROFILE_INIT
  tracing: remove ftrace(...) function
  tracing: use per trace_array clock_id instead of global
    trace_clock_id
  tracing: guard tracing_selftest_disabled by
    CONFIG_FTRACE_STARTUP_TEST
  libtraceevent: add libtraceevent prefix in warning message

 include/linux/ftrace_event.h       |   32 ++++++++
 include/linux/trace_array.h        |  118 +++++++++++++++++++++++++++++
 include/trace/ftrace.h             |   71 ++++++------------
 kernel/trace/trace.c               |   27 +++----
 kernel/trace/trace.h               |  144 +-----------------------------------
 kernel/trace/trace_events.c        |   55 ++++++++++++++
 kernel/trace/trace_syscalls.c      |   36 ++++-----
 tools/lib/traceevent/event-parse.c |    2 +-
 8 files changed, 257 insertions(+), 228 deletions(-)
 create mode 100644 include/linux/trace_array.h

-- 
1.7.9.7


