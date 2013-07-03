Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3GCXQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679Ab3GCXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:16:06 -0400
Date: Thu, 4 Jul 2013 01:11:14 +0200
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
Message-ID: <20130703231114.GA18261@redhat.com>
References: <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com> <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com> <20130703175420.GA25668@redhat.com> <1372874547.22688.111.camel@gandalf.local.home> <20130703191748.GA2884@redhat.com> <1372883643.22688.118.camel@gandalf.local.home> <1372883787.22688.120.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372883787.22688.120.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> On Wed, 2013-07-03 at 16:34 -0400, Steven Rostedt wrote:
> > OK, what about the below patch, followed by an updated version of your
> > patch. I'll send that as a reply to this one.
>
> This is a modification of your patch:

Thanks.

> If you like it, please add a proper change log and SOB tag. Oh, and we
> need to still update trace_kprobes.c

and trace_uprobes.c. Please find the changelog below.


tracing: trace_remove_event_call() should fail if call/file is in use

Change trace_remove_event_call(call) to return the error if this
call is active. This is what the callers assume but can't verify
outside of the tracing locks. Both trace_kprobe.c/trace_uprobe.c
need the additional changes, unregister_trace_probe() should abort
if trace_remove_event_call() fails.

We also check TRACE_EVENT_FL_REF_MASK to ensure that nobody opened
the files we are going to remove, these means that nobody can access
the soon-to-be-freed ftrace_event_file/call via filp->private_data.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

