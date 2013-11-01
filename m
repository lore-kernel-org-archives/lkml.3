Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3KAPUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3KAPUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:20:47 -0400
Date: Fri, 1 Nov 2013 16:20:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/4] perf tools: Add call-graph option support into
 .perfconfig
Message-ID: <20131101152000.GB5671@krava.brq.redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
 <1382797536-32303-4-git-send-email-jolsa@redhat.com>
 <87bo2995o1.fsf@sejong.aot.lge.com>
 <20131029101821.GA1093@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029101821.GA1093@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:18:21AM +0100, Jiri Olsa wrote:
> On Mon, Oct 28, 2013 at 05:10:54PM +0900, Namhyung Kim wrote:
> > On Sat, 26 Oct 2013 16:25:35 +0200, Jiri Olsa wrote:
> > > Adding call-graph option support into .perfconfig file,
> > > so it's now possible use call-graph option like:
> > >
> > >   [top]
> > >         call-graph = fp
> > >
> > >   [record]
> > >         call-graph = dwarf,8192
> > >
> > > Above options ONLY setup the unwind method. To enable
> > > perf record/top to actually use it the command line
> > > option -g/-G must be specified.
> > >
> > > The --call-graph option overloads .perfconfig setup.
> > >
> > > Assuming above configuration:
> > >
> > >   $ perf record -g ls
> > >   - enables dwarf unwind with user stack size dump 8192 bytes
> > >
> > >   $ perf top -G
> > >   - enables frame pointer unwind
> > >
> > >   $ perf record --call-graph=fp ls
> > >   - enables frame pointer unwind
> > >
> > >   $ perf top --call-graph=dwarf,4096 ls
> > >   - enables dwarf unwind with user stack size dump 4096 bytes
> > >
> > [SNIP]
> > > --- a/tools/perf/builtin-record.c
> > > +++ b/tools/perf/builtin-record.c
> > > @@ -750,6 +750,8 @@ int record_parse_callchain_opt(const struct option *opt,
> > >  	struct perf_record_opts *opts = opt->value;
> > >  	int ret;
> > >  
> > > +	opts->call_graph_enabled = !unset;
> > > +
> > 
> > Why not just using symbol_conf.use_callchain?
> > 
> 
> right, this way we'd be in sync with top

hum, on the other hand using symbol_conf.use_callchain within
utils/evsel.c adds symbol object dependency to python code
which I'm not sure is something we want ;-)

I'll keep it as it is in v2

jirka
