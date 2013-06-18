Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab3FRQaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab3FRQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:30:42 -0400
Date: Tue, 18 Jun 2013 18:24:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130618162447.GA5877@redhat.com>
References: <20130617170142.GA19780@redhat.com> <20130617201818.GA12349@redhat.com> <1371504473.18733.27.camel@gandalf.local.home> <20130618144635.GB26920@redhat.com> <1371570100.18733.30.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371570100.18733.30.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Steven Rostedt wrote:
>
> On Tue, 2013-06-18 at 16:46 +0200, Oleg Nesterov wrote:
> >
> > Perhaps you are trying to say that this patch needs more work...
> >
> > Just because it can't be compiled? Pedant.
>
> No, just because when I first looked at it, I didn't think it would,

And your intuition was correct.

It can't be compiled if you also change TRACE_EVENT(sched_stat_runtime)
to use TP_perf_arg(__count, runtime). Hopefully this can be fixed by

	- TRACE_EVENT(...)
	+ DECLARE_EVENT_CLASS(...)
	+ DEFINE_EVENT(...)

Oleg.

