Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3KYJqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:46:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab3KYJqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:46:42 -0500
Date: Mon, 25 Nov 2013 10:46:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 04/22] tools lib traceevent: Add jbd2 plugin
Message-ID: <20131125094618.GC3161@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-5-git-send-email-jolsa@redhat.com>
 <1385130477.1747.33.camel@leonhard>
 <20131123035221.73f67ab7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123035221.73f67ab7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 03:52:21AM -0500, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:27:57 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > [SNIP]
> > > +#define MINORBITS	20
> > > +#define MINORMASK	((1U << MINORBITS) - 1)
> > > +
> > > +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
> > > +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
> > > +
> > > +unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
> > > +					    unsigned long long *args)
> > 
> > Isn't it better to make these functions static?
> 
> Yeah, but that was my mistake. Lets keep the fix separate from the
> backport though. Thanks!

ok

> 
> > 
> > 
> > > +{
> > > +	unsigned int dev = args[0];
> > > +
> > > +	trace_seq_printf(s, "%d:%d", MAJOR(dev), MINOR(dev));

SNIP

> 
>     jbd2: remove jbd2_dev_to_name() from jbd2 tracepoints
>     
>     Using function calls in TP_printk causes perf heartburn, so print the
>     MAJOR/MINOR device numbers instead.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

yep, it's rather old change (v3.1-rc1) but I thought
we want to keep that for backward compatibility

and it's small piece of code anyway.. ;-)

> 
> 
> 
> > 
> > 
> > > +				       "jbd2_dev_to_name",
> > > +				       PEVENT_FUNC_ARG_INT,
> > > +				       PEVENT_FUNC_ARG_VOID);
> > > +
> > > +	pevent_register_print_function(pevent,
> > > +				       process_jiffies_to_msecs,
> > > +				       PEVENT_FUNC_ARG_LONG,
> > > +				       "jiffies_to_msecs",
> > > +				       PEVENT_FUNC_ARG_LONG,
> > > +				       PEVENT_FUNC_ARG_VOID);
> > > +	return 0;
> > > +}
> > 
> > Shouldn't it unregister these functions when unloaded?
> 
> Probably ;-)

will add,


thanks,
jirka
