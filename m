Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3KVPya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:54:30 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58853 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab3KVPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:54:29 -0500
Date: Fri, 22 Nov 2013 16:54:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122155425.GA15836@gmail.com>
References: <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
 <20131122153910.GA15636@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122153910.GA15636@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > cmdline is parse-options.c.
> > 
> > IOW, that's splitting it into too granulary pieces with 1-2 
> > compilation units ber library.
> 
> I see no problem with that - it's basically like util/*.c is, just 
> between tools.

I.e.:

comet:~/tip/tools/perf> ls util/*.h
util/annotate.h   util/data.h       util/fs.h           util/parse-events-bison.h  util/probe-event.h   util/sort.h       util/thread.h       util/values.h
util/build-id.h   util/debug.h      util/header.h       util/parse-events-flex.h   util/probe-finder.h  util/stat.h       util/thread_map.h   util/vdso.h
util/cache.h      util/dso.h        util/help.h         util/parse-events.h        util/pstack.h        util/strbuf.h     util/tool.h         util/xyarray.h
util/callchain.h  util/dwarf-aux.h  util/hist.h         util/parse-options.h       util/quote.h         util/strfilter.h  util/top.h
util/cgroup.h     util/event.h      util/intlist.h      util/perf_regs.h           util/rblist.h        util/strlist.h    util/trace-event.h
util/color.h      util/evlist.h     util/levenshtein.h  util/pmu-bison.h           util/run-command.h   util/svghelper.h  util/types.h
util/comm.h       util/evsel.h      util/machine.h      util/pmu-flex.h            util/session.h       util/symbol.h     util/unwind.h
util/cpumap.h     util/exec_cmd.h   util/map.h          util/pmu.h                 util/sigchain.h      util/target.h     util/util.h

That is pretty healty granularity IMO.

Do we want a separate directory for each one? I don't see a big 
problem with doing that, but it could be kept in tools/lib/util/ or 
tools/lib/core/ as well, _as long as they are not lumped together and 
as long as the individual .h files are kept_.

That also means that these bits shouldn't really be librarized in the 
classical sense into a single .a and linked into whatever tool uses 
it, but should be used individually as singular targets with clean .h 
interfaces to utilize them topically.

That also means that utilities won't run into any dependency problems, 
and the build will be faster as well as it all will be a single 
dependency graph within a single make session.

Thanks,

	Ingo
