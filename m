Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3EJJSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3EJJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:18:07 -0400
Date: Fri, 10 May 2013 11:16:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/9] perf tools: Set maximum precise value for event 'p'
 modifier
Message-ID: <20130510091605.GE1040@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <1368106344-23383-6-git-send-email-jolsa@redhat.com>
 <8738tv7g7u.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738tv7g7u.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:53:41AM +0900, Namhyung Kim wrote:
> On Thu,  9 May 2013 15:32:20 +0200, Jiri Olsa wrote:
> > If single 'p' modifier is specified for event, set the
> > system precise value for perf_events_attr::precise_ip.
> >
> > If more than a single 'p' is specified keep the intended
> > value.
> 
> So there's no way to set precise=1 on a system suppports precise=2 using
> this syntax, right? (I don't know whether it makes any sense though.)

right, I abused the single 'p' to get whatever is in sysfs,
which AFAICS should be always the intention..

> 
> >
> > If precise is not supported by system, warning is disaplyed.
> 
> s/disaplyed/displayed/

ok

> 
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  tools/perf/util/parse-events.c | 40 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 38 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 2e3ef10..6be4599 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -533,6 +533,26 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
> >  	return add_event(list, idx, &attr, NULL);
> >  }
> >  
> > +static int precise_default(void)
> > +{
> > +	int precise = perf_precise__get();
> > +	static int warned;
> > +
> > +	/*
> > +	 * Precise info not supported by by this kernel,
> 
> s/by by/by/ :)

ok

> 
> 
> > +	 * set 1 as the precise value.
> > +	 */
> > +	if (precise == -1)
> > +		precise = 1;
> > +
> > +	/* PEBS is not supported here, display warning. */
> > +	if (precise == 0 && !warned++)
> > +		pr_warning("warning: no precise support, "
> > +			   "using non-precise event(s)\n");
> 
> Please put the message on a single line.

ok

thanks,
jirka
