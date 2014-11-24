Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaKXPZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:25:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:50034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKXPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:25:45 -0500
Date: Mon, 24 Nov 2014 12:25:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: probe + report for following branch history. was Re: [PATCH 1/2]
 perf hists browser: Print overhead percent value for first-level callchain
Message-ID: <20141124152541.GB13167@kernel.org>
References: <20141124145227.GE18625@kernel.org>
 <20141124152312.GA13167@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141124152312.GA13167@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 24, 2014 at 12:23:12PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Nov 24, 2014 at 11:52:27AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Nov 24, 2014 at 05:13:26PM +0900, Namhyung Kim escreveu:
> > > Currently perf report on TUI doesn't print percent for first-level
> > > callchain entry.  I guess it (wrongly) assumes that there's only a
> > > single callchain in the first level.  This patch fixes it by handling
> > > the first level callchains same as others - if it's not 100% it should
> > > print the percent value.  Also it'll affect other callchains in the
> > > other way around - if it's 100% (single callchain) it should not print
> > > the percentage.
> > > 
> > > Before:
> > >   -   30.95%     6.84%  abc2     abc2              [.] a
> > >      - a
> > 
> > Thanks, with this the --stdio output matches --tui when --branch-history
> > is used in 'report', will push soon.
> 
> [acme@zoo linux]$ time make -C tools/perf build-test
> make: Entering directory `/home/git/linux/tools/perf'
> - make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.z11aKMiurz 

Right to the point:

[acme@zoo linux]$ make -C tools/perf NO_DEMANGLE=1 util/srcline.o
make: Entering directory `/home/git/linux/tools/perf'
  BUILD:   Doing 'make -j4' parallel build
  CC       util/srcline.o
In file included from util/srcline.c:18:0:
/usr/include/bfd.h:6197:7: error: conflicting types for ‘bfd_demangle’
 char *bfd_demangle (bfd *, const char *, int);
       ^
In file included from util/srcline.c:11:0:
util/symbol.h:35:21: note: previous definition of ‘bfd_demangle’ was
here
 static inline char *bfd_demangle(void __maybe_unused *v,
                     ^
make[1]: *** [util/srcline.o] Error 1
make: *** [util/srcline.o] Error 2
make: Leaving directory `/home/git/linux/tools/perf'
[acme@zoo linux]$ 
