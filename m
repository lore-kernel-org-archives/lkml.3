Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3GBVp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3GBVp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:45:57 -0400
Date: Tue, 2 Jul 2013 23:41:09 +0200
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
Message-ID: <20130702214109.GA25633@redhat.com>
References: <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com> <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702213808.GA24757@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Oleg Nesterov wrote:
>
> On 07/02, Steven Rostedt wrote:
> >
> > I'm actually worried about this change.
>
> Me too.
>
> But again. Any reason trace_remove_event_call() should succeed if
> this this ftrace_event_call is active?

And note that kprobes/uprobes are the only users of trace_remove_event_call(),
and both need the same semantics: kill it only if it is not active.

Oleg.

