Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3JHIrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:47:45 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62905 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3JHIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:47:34 -0400
Date: Tue, 8 Oct 2013 10:47:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 44/50] tools/perf/build: Collapse the test-all.c testcase
Message-ID: <20131008084730.GC3295@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-45-git-send-email-mingo@kernel.org>
 <20131007222505.GG2900@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007222505.GG2900@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Oct 07, 2013 at 01:56:37PM +0200, Ingo Molnar wrote:
> 
> SNIP
> 
> > diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
> > index 6a5fd96..5b33bcf 100644
> > --- a/tools/perf/config/feature-checks/test-backtrace.c
> > +++ b/tools/perf/config/feature-checks/test-backtrace.c
> > @@ -9,8 +9,6 @@ int main(void)
> >  	entries = backtrace(backtrace_fns, 10);
> >  	backtrace_symbols_fd(backtrace_fns, entries, 1);
> >  
> > -	printf("backtrace entries: %d\n", entries);
> > - 
> >  	return 0;
> 
> belongs to previous patch?

Yes.

> 
> >  }
> >  
> > diff --git a/tools/perf/config/feature-checks/test-libunwind.c b/tools/perf/config/feature-checks/test-libunwind.c
> > index 088fc59..43b9369 100644
> > --- a/tools/perf/config/feature-checks/test-libunwind.c
> > +++ b/tools/perf/config/feature-checks/test-libunwind.c
> > @@ -18,9 +18,10 @@ int main(void)
> >  
> >  	addr_space = unw_create_addr_space(&accessors, 0);
> >  	if (addr_space)
> > -		return;
> > +		return 0;
> >  
> >  	unw_init_remote(NULL, addr_space, NULL);
> >  	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
> > +
> 
> ditto

Thanks, fixed.

	Ingo
