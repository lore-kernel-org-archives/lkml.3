Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab3GRDAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:00:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3GRDAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:00:49 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jG05uceuGy4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5uFaiv9cfuIA:10 a=6v_T3jgY7QRrQ-TIX1kA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374116446.6458.203.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 23:00:46 -0400
In-Reply-To: <20130617170142.GA19780@redhat.com>
References: <20130617170142.GA19780@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

These have been discussed, and they mostly live in the tracing
directory, but are perf related. Can you give me your Acked-by on them.

Thanks,

-- Steve


On Mon, 2013-06-17 at 19:01 +0200, Oleg Nesterov wrote:
> Hello.
> 
> Steven, we already discussed this a bit some time ago...
> 
> DECLARE_EVENT_CLASS()->perf_trace_##call() is not trivial because
> of __perf_task(), but perhaps we can change other
> perf_trace_buf_submit(task => NULL) callers.
> 
> 
> And can't we factor out WARN_ONCE(size > PERF_MAX_TRACE_SIZE) ?
> See 3/3. I won't argue if you dislike it.
> 
> Oleg.
> 
>  include/trace/ftrace.h          |    4 ----
>  kernel/trace/trace_event_perf.c |   10 ++++++++--
>  kernel/trace/trace_kprobe.c     |    6 ------
>  kernel/trace/trace_syscalls.c   |   24 ++++++++----------------
>  kernel/trace/trace_uprobe.c     |    2 --
>  5 files changed, 16 insertions(+), 30 deletions(-)


