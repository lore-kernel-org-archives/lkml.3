Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3FQRHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:07:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3FQRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:07:03 -0400
Date: Mon, 17 Jun 2013 19:01:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130617170142.GA19780@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Steven, we already discussed this a bit some time ago...

DECLARE_EVENT_CLASS()->perf_trace_##call() is not trivial because
of __perf_task(), but perhaps we can change other
perf_trace_buf_submit(task => NULL) callers.


And can't we factor out WARN_ONCE(size > PERF_MAX_TRACE_SIZE) ?
See 3/3. I won't argue if you dislike it.

Oleg.

 include/trace/ftrace.h          |    4 ----
 kernel/trace/trace_event_perf.c |   10 ++++++++--
 kernel/trace/trace_kprobe.c     |    6 ------
 kernel/trace/trace_syscalls.c   |   24 ++++++++----------------
 kernel/trace/trace_uprobe.c     |    2 --
 5 files changed, 16 insertions(+), 30 deletions(-)

