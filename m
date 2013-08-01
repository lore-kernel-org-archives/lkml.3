Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3HANzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab3HANzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:55:16 -0400
Date: Thu, 1 Aug 2013 15:49:43 +0200
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
Message-ID: <20130801134943.GA10452@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home> <1375322866.5418.46.camel@gandalf.local.home> <1375325414.5418.50.camel@gandalf.local.home> <20130801133455.GB8703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801133455.GB8703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Oleg Nesterov wrote:
>
> And just in case. I believe that the patch is fine.
>
> Just one off-topic note,

Forgot to mention,

> > @@ -632,7 +635,9 @@ static int release_all_trace_probes(void)
> >  	/* TODO: Use batch unregistration */
> >  	while (!list_empty(&probe_list)) {
> >  		tp = list_entry(probe_list.next, struct trace_probe, list);
> > -		unregister_trace_probe(tp);
> > +		ret = unregister_trace_probe(tp);
> > +		if (ret)
> > +			goto end;
> >  		free_trace_probe(tp);
> >  	}
>
> This obviously breaks all-or-nothing semantics (I mean, this breaks
> the intent, the current code is buggy).
>
> I think we can't avoid this, and I hope this is fine. But then perhaps
> we should simply remove the "list_for_each_entry" check above?

And, of course, turn this "while (!list_empty())" into list_for_each_safe().

But again, this is almost off-topic and we can do this later.

Oleg.

