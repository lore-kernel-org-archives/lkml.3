Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaLVOyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:54:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:52464 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaLVOyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:54:02 -0500
Date: Mon, 22 Dec 2014 11:53:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Message-ID: <20141222145358.GC7644@kernel.org>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145013.GB7644@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141222145013.GB7644@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 11:50:13AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Sat, Dec 20, 2014 at 01:51:05PM +0100, Rickard Strandqvist escreveu:
> > Removes some functions that are not used anywhere:
> > color_parse_mem() color_parse()
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> 
> Thanks, applied.

Take that back, can you please check this:

[acme@ssdandy linux]$ am /wb/1.patch 
Applying: tools: perf: util: color.c: Remove some unused functions
[perf/core b419f879f2a0] perf tools: Remove some unused functions from color.c
 Author: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
 2 files changed, 92 deletions(-)
[acme@ssdandy linux]$ time make -C tools/perf build-test
make: Entering directory `/home/acme/git/linux/tools/perf'
- make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.4b0BVUu9ff 
cd . && make -f Makefile DESTDIR=/tmp/tmp.4b0BVUu9ff
  BUILD:   Doing 'make -j8' parallel build
config/Makefile:390: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR

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
...                     libunwind: [ OFF ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...     DWARF post unwind library: libdw

  GEN      common-cmds.h
  FLAGS:   * new build flags or prefix
  CC       bench/mem-memcpy-x86-64-asm.o
  CC       bench/mem-memset-x86-64-asm.o
  CC       bench/mem-memcpy.o
  CC       bench/futex-hash.o
  CC       bench/futex-wake.o
  CC       bench/futex-requeue.o
  CC       builtin-diff.o
  CC       builtin-evlist.o
  CC       builtin-sched.o
  CC       builtin-buildid-list.o
  CC       builtin-buildid-cache.o
  CC       builtin-list.o
  CC       builtin-record.o
  CC       builtin-report.o
  CC       builtin-stat.o
  CC       builtin-top.o
  CC       builtin-script.o
  CC       builtin-probe.o
  CC       builtin-kmem.o
  CC       builtin-lock.o
  CC       builtin-kvm.o
  CC       builtin-inject.o
  CC       tests/builtin-test.o
  CC       builtin-mem.o
  CC       builtin-trace.o
  CC       bench/numa.o
  CC       util/abspath.o
  CC       util/alias.o
  CC       util/annotate.o
  CC       util/build-id.o
  CC       util/config.o
  CC       util/ctype.o
  CC       util/db-export.o
  BISON    util/pmu-bison.c
  CC       util/environment.o
  CC       util/event.o
  CC       util/evlist.o
  CC       util/evsel.o
  CC       util/exec_cmd.o
  CC       util/find_next_bit.o
  PERF_VERSION = 3.18.gb419f8
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
util/color.c:8:12: error: ‘parse_color’ defined but not used [-Werror=unused-function]
 static int parse_color(const char *name, int len)
            ^
util/color.c:28:12: error: ‘parse_attr’ defined but not used [-Werror=unused-function]
 static int parse_attr(const char *name, int len)
            ^
cc1: all warnings being treated as errors
make[3]: *** [util/color.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [all] Error 2
  test: test -x ./perf
make[1]: *** [make_pure] Error 1
make: *** [build-test] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m6.359s
user	0m16.198s
sys	0m2.000s
[acme@ssdandy linux]$
