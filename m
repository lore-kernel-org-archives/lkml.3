Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3CKHNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:13:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25739 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3CKHNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:13:39 -0400
Message-ID: <513D8414.9040005@huawei.com>
Date: Mon, 11 Mar 2013 15:13:24 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 00/13] Improvements tracing code
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does several improvements and cleanups in tracing code
as follows short stat.

Two patches changed compilation on scsi subsystem, it should go through to
SCSI tree.

-------

zhangwei(Jovi) (13):
  tracing: teach to use pr_warn_once
  tracing: use TRACE_MAX_PRINT
  tracing: move find_event_field function into trace_events.c
  tracing: make trace_destroy_fields as static
  tracing: change unclear comments on arch_syscall_match_sym_name
  tracing: remove dump_ran check in __ftrace_dump
  tracing/kdb: remove redundant checking
  tracing: rename trace_event_mutex to trace_event_sem
  tracing: use trace_seq_init to initize seq field in trace_iterator
  tracing: deprecate tracing_is_enabled function
  tracing: export syscall_nr_to_meta function
  scsi/tracing: include correct header file
  scsi/tracing: make scsi_trace.c depend on CONFIG_EVENT_TRACING

 drivers/scsi/Makefile              |    2 +-
 drivers/scsi/scsi_trace.c          |    2 +-
 include/trace/syscall.h            |    2 ++
 kernel/trace/trace.c               |   44 +++++++++++-------------------------
 kernel/trace/trace.h               |    7 ++----
 kernel/trace/trace_events.c        |   43 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_events_filter.c |   29 +-----------------------
 kernel/trace/trace_irqsoff.c       |    2 +-
 kernel/trace/trace_kdb.c           |    8 +++----
 kernel/trace/trace_output.c        |   16 ++++++-------
 kernel/trace/trace_output.h        |    2 +-
 kernel/trace/trace_sched_wakeup.c  |    2 +-
 kernel/trace/trace_syscalls.c      |    5 ++--
 13 files changed, 73 insertions(+), 91 deletions(-)

-- 
1.7.9.7


