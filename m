Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3GCRZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab3GCRZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:25:23 -0400
Date: Wed, 3 Jul 2013 19:20:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130703172029.GA14309@redhat.com>
References: <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com> <51D38F8D.3010708@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D38F8D.3010708@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami,

I am not sure I understand. And please do not forget I am not
familiar with this code ;)

In short: do you think that the patch I sent "can't help" or
"not enough" ?

If "not enough" then I fully agree.

On 07/03, Masami Hiramatsu wrote:
>
> (2013/07/03 7:23), Oleg Nesterov wrote:
> > On 07/02, Oleg Nesterov wrote:
> >>
> >> So please ignore modules ;)
> >
> > Or lets discuss the change above.
>
> No, I think this still doesn't ensure that we can remove dynamic
> event safely. Since the event is related to several files under
> events/ dir and buffer instances, someone can just stay open the
> files while the event is removed and read/write it.

So, for example, event_enable_write() can happily play with
ftrace_event_file after unregister_trace_probe/free_trace_probe.

Did you mean this?

Sure, but this is another problem? And we already discussed it a
bit, an application can keep the file we need to remove opened.

As for event_enable_write() in particular, we can probably mark
file/call as dead somewhere in trace_remove_event_call(). But
I simply do not understand this code enough, I do not know what
else we should do.

IOW. So far _I think_ we just need the additional changes in
trace_remove_event_call() if it succeeds (with the patch I sent)
to prevent the races like above, but I didn't even try to think
about this problem.

Or I missed your point completely?

Oleg.

