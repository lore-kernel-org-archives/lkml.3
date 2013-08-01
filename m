Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3HANQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3HANQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:16:37 -0400
Date: Thu, 1 Aug 2013 15:10:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
	event files are open
Message-ID: <20130801131053.GA8703@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375310548.5418.21.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Steven Rostedt wrote:
>
> On Wed, 2013-07-31 at 22:40 +0200, Oleg Nesterov wrote:
> >
> > This should be fine. Either event_remove() path takes event_mutex
> > first and then ->write() fails, or ftrace_event_enable_disable()
> > actually disables this even successfully.
>
> Actually I meant while in unregister_trace_probe(), it gets by the
> trace_probe_is_enabled() part first, then the write succeeds (as the
> event_mutex isn't taken till unregister_probe_event()). The the
> unregister_probe_event fails,

Yes sure. In this case evrything is clear. But this looks as if
unregister_probe_event() should not fail. IOW, this looks as if
the bug was introduce by the previous "trace_remove_event_call()
should fail if call/file is in use" change.

Oleg.

