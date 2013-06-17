Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3FQPfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3FQPfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:35:08 -0400
Date: Mon, 17 Jun 2013 17:30:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing/kprobes: Turn trace_probe->files into
	list_head
Message-ID: <20130617153042.GA1102@redhat.com>
References: <20130616172152.GA8543@redhat.com> <51BEAAA1.20806@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEAAA1.20806@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Masami Hiramatsu wrote:
>
> (2013/06/17 2:21), Oleg Nesterov wrote:
> >
> > This needs the extra sizeof(list_head) memory for every attached
> > ftrace_event_file, hopefully not a problem in this case.
>
> I think it's no problem, because the number depends on the instances
> and it could not be so much. :)

Yes, agreed.

> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

Given that 2/3 should update the comments (or should be dropped
if you do not like it), this ones should be rediffed. And, I just
noticed typo in this patch,

> > @@ -209,29 +199,18 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
> > ...
> > +		link->file = file;
> > +		list_add_rcu(&link->list, &tp->files);

I meant list_add_tail_rcu().

I guess this doesn't matter at all, still I'd like to avoid any
visible changes in behaviour.

Otherwise we could use hlist or even single list, although this
doesn't really matter too.

I'll preserve your ack.

Oleg.

