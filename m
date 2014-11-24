Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKXPXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:23:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaKXPXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:23:18 -0500
Date: Mon, 24 Nov 2014 12:23:12 -0300
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
Message-ID: <20141124152312.GA13167@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141124145227.GE18625@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 24, 2014 at 11:52:27AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Nov 24, 2014 at 05:13:26PM +0900, Namhyung Kim escreveu:
> > Currently perf report on TUI doesn't print percent for first-level
> > callchain entry.  I guess it (wrongly) assumes that there's only a
> > single callchain in the first level.  This patch fixes it by handling
> > the first level callchains same as others - if it's not 100% it should
> > print the percent value.  Also it'll affect other callchains in the
> > other way around - if it's 100% (single callchain) it should not print
> > the percentage.
> > 
> > Before:
> >   -   30.95%     6.84%  abc2     abc2              [.] a
> >      - a
> 
> Thanks, with this the --stdio output matches --tui when --branch-history
> is used in 'report', will push soon.

[acme@zoo linux]$ time make -C tools/perf build-test
make: Entering directory `/home/git/linux/tools/perf'
- make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.z11aKMiurz 
- make_clean_all: cd . && make -f Makefile DESTDIR=/tmp/tmp.aylbvfzj5m
  clean all
- make_python_perf_so: cd . && make -f Makefile
  DESTDIR=/tmp/tmp.t896NZcPrJ python/perf.so
- make_debug: cd . && make -f Makefile DESTDIR=/tmp/tmp.ARnUdN0Ox5
  DEBUG=1
- make_no_libperl: cd . && make -f Makefile DESTDIR=/tmp/tmp.xG1XJ2Pjq7
  NO_LIBPERL=1
- make_no_libpython: cd . && make -f Makefile
  DESTDIR=/tmp/tmp.2k8q3ouduH NO_LIBPYTHON=1
- make_no_scripts: cd . && make -f Makefile DESTDIR=/tmp/tmp.kwu6TUzMaZ
  NO_LIBPYTHON=1 NO_LIBPERL=1
- make_no_newt: cd . && make -f Makefile DESTDIR=/tmp/tmp.Ra0cHpOVXI
  NO_NEWT=1
- make_no_slang: cd . && make -f Makefile DESTDIR=/tmp/tmp.dI5pMO80Gw
  NO_SLANG=1
- make_no_gtk2: cd . && make -f Makefile DESTDIR=/tmp/tmp.r4R7rILIq4
  NO_GTK2=1
- make_no_ui: cd . && make -f Makefile DESTDIR=/tmp/tmp.36qCtqcT3J
  NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
- make_no_demangle: cd . && make -f Makefile DESTDIR=/tmp/tmp.5PpSkaVWUl
  NO_DEMANGLE=1
cd . && make -f Makefile DESTDIR=/tmp/tmp.5PpSkaVWUl NO_DEMANGLE=1
  BUILD:   Doing 'make -j4' parallel build

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...     DWARF post unwind library: libunwind

  GEN      common-cmds.h
  FLAGS:   * new build flags or prefix
  BISON    util/pmu-bison.c
  CC       util/environment.o
  CC       util/event.o
  CC       util/evlist.o
  CC       util/evsel.o
  PERF_VERSION = 3.18.rc3.gf07177
  CC       util/exec_cmd.o
  CC       util/help.o
  CC       util/kallsyms.o
  CC       util/levenshtein.o
  CC       util/parse-options.o
  BISON    util/parse-events-bison.c
  CC       util/path.o
  CC       util/rbtree.o
  CC       util/bitmap.o
  CC       util/hweight.o
  CC       util/run-command.o
  CC       util/quote.o
  CC       util/strbuf.o
  CC       util/string.o
  CC       util/strlist.o
  CC       util/strfilter.o
  CC       util/top.o
  CC       util/usage.o
  CC       util/wrapper.o
  CC       util/sigchain.o
  CC       util/dso.o
  CC       util/symbol.o
  CC       util/symbol-elf.o
  CC       util/color.o
  CC       util/pager.o
  CC       util/header.o
  CC       util/callchain.o
  CC       util/values.o
  CC       util/debug.o
  CC       util/machine.o
  CC       util/map.o
  CC       util/pstack.o
  CC       util/session.o
  CC       util/ordered-events.o
  CC       util/comm.o
  CC       util/thread.o
  CC       util/thread_map.o
  CC       util/trace-event-parse.o
  CC       util/parse-events-bison.o
  CC       util/pmu-bison.o
  CC       util/trace-event-read.o
  CC       util/trace-event-info.o
  CC       util/trace-event-scripting.o
  CC       util/trace-event.o
  CC       util/svghelper.o
  CC       util/sort.o
  CC       util/hist.o
  CC       util/probe-event.o
  CC       util/util.o
  CC       util/xyarray.o
  CC       util/cpumap.o
  CC       util/cgroup.o
  CC       util/target.o
  CC       util/rblist.o
  CC       util/intlist.o
  CC       util/vdso.o
  CC       util/stat.o
  CC       util/record.o
  CC       util/srcline.o
  CC       util/data.o
  CC       util/tsc.o
  CC       util/cloexec.o
In file included from util/srcline.c:18:0:
/usr/include/bfd.h:6197:7: error: conflicting types for ‘bfd_demangle’
 char *bfd_demangle (bfd *, const char *, int);
       ^
In file included from util/srcline.c:11:0:
util/symbol.h:35:21: note: previous definition of ‘bfd_demangle’ was
here
 static inline char *bfd_demangle(void __maybe_unused *v,
                     ^
make[3]: *** [util/srcline.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [all] Error 2
  test: test -x ./perf
make[1]: *** [make_no_demangle] Error 1
make: *** [build-test] Error 2
make: Leaving directory `/home/git/linux/tools/perf'

real	4m21.797s
user	10m54.214s
sys	1m26.056s
[acme@zoo linux]$
