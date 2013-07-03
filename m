Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3GCWYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3GCWYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:24:39 -0400
Date: Thu, 4 Jul 2013 00:18:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130703221847.GA15566@redhat.com>
References: <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com> <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com> <20130703175420.GA25668@redhat.com> <1372874547.22688.111.camel@gandalf.local.home> <20130703191748.GA2884@redhat.com> <1372883643.22688.118.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372883643.22688.118.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> No, I would avoid any changes to the debugfs infrastructure.

YEs, agreed.

> OK, what about the below patch, followed by an updated version of your
> patch. I'll send that as a reply to this one.

Steven, you do understand that I can't review the changes in this area.

But at first glance, _I think_ this should work. And this is much simpler,
->open() blocks trace_remove_event_call() (you added TRACE_EVENT_FL_REF_MASK
check into the next patch).

Which tree this patch is based on? I have pulled linux-trace.git#for-next
and I do not see tracing_open_generic_file/etc in trace_events.c.

I do not understand what protects call->flags, I guess there is another
lock which I do not see in my tree?

Oleg.

