Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3BDRVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab3BDRVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:21:23 -0500
Date: Mon, 4 Feb 2013 18:20:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes/tracing: Kill uprobe_trace_consumer, embed
	uprobe_consumer into trace_uprobe
Message-ID: <20130204172010.GA30749@redhat.com>
References: <20130131191752.GA30410@redhat.com> <20130131191829.GA30454@redhat.com> <20130204165945.GB4246@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204165945.GB4246@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:29]:
>
> > trace_uprobe->consumer and "struct uprobe_trace_consumer" add the
> > unnecessary indirection and complicate the code for no reason.
> >
> > This patch simply embeds uprobe_consumer into "struct trace_uprobe",
> > all other changes only fix the compilation errors.
>
> I know this patch doesnt change the current behaviour.

Yes, and it makes the code simpler.

> We dont handle two concurrent perf record sessions for the same user
> space probe. Since both sessons share the same trace_uprobe and hence
> share the same consumer.

We do? I am testing the patches I am going to send, and I specially
tried to verify that 2 concurent sessions with different/same filtering
constraints work fine.

Or I misunderstood what you meant...

> Initially I had thought of having a chain in
> uprobe_trace_consumer. However we dont get have enough information at
> the probe_event_disable() time to detect which consumer to delete Hence
> I dropped the idea of having a list of consumers attached to the
> trace_uprobe.

You know, until recently I knew absolutely nothing about kernel/events/
and kernel/trace/. Not that I really understand this code now, I can
be easily wrong.

But so far I think that a chain of multiple consumers makes no sense.
Each consumer->handler() will use the same call->perf_events list, this
will only complicate the code for no reason.

> However with allowing prefiltering, we need to have ability to
> distinguish consumers.

Certainly not. Please see the patches I am going to send.

Oleg.

