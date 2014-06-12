Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaFLMez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:34:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:47227 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbaFLMev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:34:51 -0400
Date: Thu, 12 Jun 2014 09:34:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] tools:perf: move tools/perf/util to tools/lib/perf_util
Message-ID: <20140612123432.GA2608@kernel.org>
References: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 12, 2014 at 10:26:42AM +0200, Jean Pihet escreveu:
> This is a first move of the perf code into a set of libraries, which
> allow the implementation of other external tools.
> 
> The first users of the perf libraries would be:
> - perf itself,
> - the RAS daemon.
> 
> The commit includes:
> - the move of the code from util to lib/perf_util,
> - creation of Makefile in perf_util,
> - update of Makefile.perf to build a library for perf_util,
> - fix of the include paths, eg. "../perf.h" to <perf.h>, "util/hist.h" to
>   <hist.h>

Can't you just go moving what you actually use? Or do you really plan to
use all that?

Otherwise I don't see why you can't just link it directly from
tools/perf/util/, i.e. its just a name.

- Arnaldo
 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> 
> ---
> Tested: basic build and run test of perf on x86.
> 
> Not tested yet:
> - dynamic library (.so),
> - all combinations of flags (NO_LIB*),
> - scripting.
> ---
>  tools/lib/perf_util/Makefile                       | 426 +++++++++++++++++++++
>  .../{perf/util => lib/perf_util}/PERF-VERSION-GEN  |   0
>  tools/{perf/util => lib/perf_util}/abspath.c       |   0
>  tools/{perf/util => lib/perf_util}/alias.c         |   0
>  tools/{perf/util => lib/perf_util}/annotate.c      |   0
>  tools/{perf/util => lib/perf_util}/annotate.h      |   0
>  tools/{perf/util => lib/perf_util}/bitmap.c        |   0
>  tools/{perf/util => lib/perf_util}/build-id.c      |   0
>  tools/{perf/util => lib/perf_util}/build-id.h      |   0
>  tools/{perf/util => lib/perf_util}/cache.h         |   4 +-
>  tools/{perf/util => lib/perf_util}/callchain.c     |   0
>  tools/{perf/util => lib/perf_util}/callchain.h     |   2 +-
>  tools/{perf/util => lib/perf_util}/cgroup.c        |   2 +-
>  tools/{perf/util => lib/perf_util}/cgroup.h        |   0
>  tools/{perf/util => lib/perf_util}/color.c         |   0
>  tools/{perf/util => lib/perf_util}/color.h         |   0
>  tools/{perf/util => lib/perf_util}/comm.c          |   0
>  tools/{perf/util => lib/perf_util}/comm.h          |   2 +-
>  tools/{perf/util => lib/perf_util}/config.c        |   2 +-
>  tools/{perf/util => lib/perf_util}/cpumap.c        |   2 +-
>  tools/{perf/util => lib/perf_util}/cpumap.h        |   2 +-
>  tools/{perf/util => lib/perf_util}/ctype.c         |   0
>  tools/{perf/util => lib/perf_util}/data.c          |   0
>  tools/{perf/util => lib/perf_util}/data.h          |   0
>  tools/{perf/util => lib/perf_util}/debug.c         |   2 +-
>  tools/{perf/util => lib/perf_util}/debug.h         |   6 +-
>  tools/{perf/util => lib/perf_util}/dso.c           |   0
>  tools/{perf/util => lib/perf_util}/dso.h           |   0
>  tools/{perf/util => lib/perf_util}/dwarf-aux.c     |   0
>  tools/{perf/util => lib/perf_util}/dwarf-aux.h     |   0
>  tools/{perf/util => lib/perf_util}/environment.c   |   0
>  tools/{perf/util => lib/perf_util}/event.c         |   0
>  tools/{perf/util => lib/perf_util}/event.h         |   2 +-
>  tools/{perf/util => lib/perf_util}/evlist.c        |   0
>  tools/{perf/util => lib/perf_util}/evlist.h        |   2 +-
>  tools/{perf/util => lib/perf_util}/evsel.c         |   0
>  tools/{perf/util => lib/perf_util}/evsel.h         |   0
>  tools/{perf/util => lib/perf_util}/exec_cmd.c      |   0
>  tools/{perf/util => lib/perf_util}/exec_cmd.h      |   0
>  .../util => lib/perf_util}/generate-cmdlist.sh     |   0
>  tools/{perf/util => lib/perf_util}/header.c        |   2 +-
>  tools/{perf/util => lib/perf_util}/header.h        |   0
>  tools/{perf/util => lib/perf_util}/help.c          |   2 +-
>  tools/{perf/util => lib/perf_util}/help.h          |   0
>  tools/{perf/util => lib/perf_util}/hist.c          |   0
>  tools/{perf/util => lib/perf_util}/hist.h          |   2 +-
>  tools/{perf/util => lib/perf_util}/hweight.c       |   0
>  .../perf_util}/include/asm/alternative-asm.h       |   0
>  .../perf_util}/include/asm/asm-offsets.h           |   0
>  .../util => lib/perf_util}/include/asm/byteorder.h |   0
>  .../perf_util}/include/asm/cpufeature.h            |   0
>  .../util => lib/perf_util}/include/asm/dwarf2.h    |   0
>  .../util => lib/perf_util}/include/asm/hash.h      |   0
>  .../util => lib/perf_util}/include/asm/hweight.h   |   0
>  .../util => lib/perf_util}/include/asm/swab.h      |   0
>  .../util => lib/perf_util}/include/asm/system.h    |   0
>  .../util => lib/perf_util}/include/asm/uaccess.h   |   0
>  .../util => lib/perf_util}/include/asm/unistd_32.h |   0
>  .../util => lib/perf_util}/include/asm/unistd_64.h |   0
>  .../util => lib/perf_util}/include/dwarf-regs.h    |   0
>  .../util => lib/perf_util}/include/linux/bitmap.h  |   0
>  .../util => lib/perf_util}/include/linux/bitops.h  |   0
>  .../util => lib/perf_util}/include/linux/const.h   |   0
>  .../util => lib/perf_util}/include/linux/ctype.h   |   0
>  .../util => lib/perf_util}/include/linux/kernel.h  |   0
>  .../util => lib/perf_util}/include/linux/linkage.h |   0
>  .../util => lib/perf_util}/include/linux/list.h    |   0
>  .../util => lib/perf_util}/include/linux/poison.h  |   0
>  .../util => lib/perf_util}/include/linux/rbtree.h  |   0
>  .../perf_util}/include/linux/rbtree_augmented.h    |   0
>  .../util => lib/perf_util}/include/linux/string.h  |   0
>  tools/{perf/util => lib/perf_util}/intlist.c       |   0
>  tools/{perf/util => lib/perf_util}/intlist.h       |   0
>  tools/{perf/util => lib/perf_util}/levenshtein.c   |   0
>  tools/{perf/util => lib/perf_util}/levenshtein.h   |   0
>  tools/{perf/util => lib/perf_util}/machine.c       |   0
>  tools/{perf/util => lib/perf_util}/machine.h       |   0
>  tools/{perf/util => lib/perf_util}/map.c           |   0
>  tools/{perf/util => lib/perf_util}/map.h           |   0
>  tools/{perf/util => lib/perf_util}/pager.c         |   0
>  tools/{perf/util => lib/perf_util}/parse-events.c  |   2 +-
>  tools/{perf/util => lib/perf_util}/parse-events.h  |   0
>  tools/{perf/util => lib/perf_util}/parse-events.l  |   2 +-
>  tools/{perf/util => lib/perf_util}/parse-events.y  |   0
>  tools/{perf/util => lib/perf_util}/parse-options.c |   0
>  tools/{perf/util => lib/perf_util}/parse-options.h |   0
>  tools/{perf/util => lib/perf_util}/path.c          |   0
>  tools/{perf/util => lib/perf_util}/perf_regs.c     |   0
>  tools/{perf/util => lib/perf_util}/perf_regs.h     |   0
>  tools/{perf/util => lib/perf_util}/pmu.c           |   0
>  tools/{perf/util => lib/perf_util}/pmu.h           |   0
>  tools/{perf/util => lib/perf_util}/pmu.l           |   0
>  tools/{perf/util => lib/perf_util}/pmu.y           |   0
>  tools/{perf/util => lib/perf_util}/probe-event.c   |   0
>  tools/{perf/util => lib/perf_util}/probe-event.h   |   0
>  tools/{perf/util => lib/perf_util}/probe-finder.c  |   0
>  tools/{perf/util => lib/perf_util}/probe-finder.h  |   0
>  tools/{perf/util => lib/perf_util}/pstack.c        |   0
>  tools/{perf/util => lib/perf_util}/pstack.h        |   0
>  .../util => lib/perf_util}/python-ext-sources      |   0
>  tools/{perf/util => lib/perf_util}/python.c        |   0
>  tools/{perf/util => lib/perf_util}/quote.c         |   0
>  tools/{perf/util => lib/perf_util}/quote.h         |   0
>  tools/{perf/util => lib/perf_util}/rblist.c        |   0
>  tools/{perf/util => lib/perf_util}/rblist.h        |   0
>  tools/{perf/util => lib/perf_util}/record.c        |   0
>  tools/{perf/util => lib/perf_util}/run-command.c   |   0
>  tools/{perf/util => lib/perf_util}/run-command.h   |   0
>  .../scripting-engines/trace-event-perl.c           |   2 +-
>  .../scripting-engines/trace-event-python.c         |   2 +-
>  tools/{perf/util => lib/perf_util}/session.c       |   0
>  tools/{perf/util => lib/perf_util}/session.h       |   0
>  tools/{perf/util => lib/perf_util}/setup.py        |   0
>  tools/{perf/util => lib/perf_util}/sigchain.c      |   0
>  tools/{perf/util => lib/perf_util}/sigchain.h      |   0
>  tools/{perf/util => lib/perf_util}/sort.c          |   0
>  tools/{perf/util => lib/perf_util}/sort.h          |   4 +-
>  tools/{perf/util => lib/perf_util}/srcline.c       |   6 +-
>  tools/{perf/util => lib/perf_util}/stat.c          |   0
>  tools/{perf/util => lib/perf_util}/stat.h          |   0
>  tools/{perf/util => lib/perf_util}/strbuf.c        |   0
>  tools/{perf/util => lib/perf_util}/strbuf.h        |   0
>  tools/{perf/util => lib/perf_util}/strfilter.c     |   0
>  tools/{perf/util => lib/perf_util}/strfilter.h     |   0
>  tools/{perf/util => lib/perf_util}/string.c        |   0
>  tools/{perf/util => lib/perf_util}/strlist.c       |   0
>  tools/{perf/util => lib/perf_util}/strlist.h       |   0
>  tools/{perf/util => lib/perf_util}/svghelper.c     |   0
>  tools/{perf/util => lib/perf_util}/svghelper.h     |   0
>  tools/{perf/util => lib/perf_util}/symbol-elf.c    |   0
>  .../{perf/util => lib/perf_util}/symbol-minimal.c  |   0
>  tools/{perf/util => lib/perf_util}/symbol.c        |   0
>  tools/{perf/util => lib/perf_util}/symbol.h        |   2 +-
>  tools/{perf/util => lib/perf_util}/target.c        |   0
>  tools/{perf/util => lib/perf_util}/target.h        |   0
>  tools/{perf/util => lib/perf_util}/thread.c        |   2 +-
>  tools/{perf/util => lib/perf_util}/thread.h        |   0
>  tools/{perf/util => lib/perf_util}/thread_map.c    |   0
>  tools/{perf/util => lib/perf_util}/thread_map.h    |   0
>  tools/{perf/util => lib/perf_util}/tool.h          |   0
>  tools/{perf/util => lib/perf_util}/top.c           |   0
>  tools/{perf/util => lib/perf_util}/top.h           |   0
>  .../util => lib/perf_util}/trace-event-info.c      |   2 +-
>  .../util => lib/perf_util}/trace-event-parse.c     |   2 +-
>  .../util => lib/perf_util}/trace-event-read.c      |   2 +-
>  .../util => lib/perf_util}/trace-event-scripting.c |   2 +-
>  tools/{perf/util => lib/perf_util}/trace-event.c   |   0
>  tools/{perf/util => lib/perf_util}/trace-event.h   |   0
>  tools/{perf/util => lib/perf_util}/unwind-libdw.c  |   0
>  tools/{perf/util => lib/perf_util}/unwind-libdw.h  |   0
>  .../util => lib/perf_util}/unwind-libunwind.c      |   0
>  tools/{perf/util => lib/perf_util}/unwind.h        |   0
>  tools/{perf/util => lib/perf_util}/usage.c         |   0
>  tools/{perf/util => lib/perf_util}/util.c          |   2 +-
>  tools/{perf/util => lib/perf_util}/util.h          |   0
>  tools/{perf/util => lib/perf_util}/values.c        |   0
>  tools/{perf/util => lib/perf_util}/values.h        |   0
>  tools/{perf/util => lib/perf_util}/vdso.c          |   0
>  tools/{perf/util => lib/perf_util}/vdso.h          |   0
>  tools/{perf/util => lib/perf_util}/wrapper.c       |   0
>  tools/{perf/util => lib/perf_util}/xyarray.c       |   0
>  tools/{perf/util => lib/perf_util}/xyarray.h       |   0
>  tools/perf/Makefile.perf                           | 342 ++++++-----------
>  tools/perf/arch/arm/util/unwind-libdw.c            |   4 +-
>  tools/perf/arch/arm/util/unwind-libunwind.c        |   2 +-
>  tools/perf/arch/arm64/util/unwind-libunwind.c      |   2 +-
>  tools/perf/arch/common.c                           |   2 +-
>  tools/perf/arch/common.h                           |   2 +-
>  tools/perf/arch/powerpc/util/header.c              |   2 +-
>  tools/perf/arch/x86/util/header.c                  |   2 +-
>  tools/perf/arch/x86/util/tsc.c                     |   4 +-
>  tools/perf/arch/x86/util/unwind-libdw.c            |   4 +-
>  tools/perf/arch/x86/util/unwind-libunwind.c        |   2 +-
>  tools/perf/bench/futex-hash.c                      |   8 +-
>  tools/perf/bench/futex-requeue.c                   |   8 +-
>  tools/perf/bench/futex-wake.c                      |   8 +-
>  tools/perf/bench/mem-memcpy.c                      |   6 +-
>  tools/perf/bench/mem-memset.c                      |   6 +-
>  tools/perf/bench/numa.c                            |   4 +-
>  tools/perf/bench/sched-messaging.c                 |   4 +-
>  tools/perf/bench/sched-pipe.c                      |   4 +-
>  tools/perf/builtin-annotate.c                      |  36 +-
>  tools/perf/builtin-bench.c                         |   4 +-
>  tools/perf/builtin-buildid-cache.c                 |  16 +-
>  tools/perf/builtin-buildid-list.c                  |  14 +-
>  tools/perf/builtin-diff.c                          |  22 +-
>  tools/perf/builtin-evlist.c                        |  14 +-
>  tools/perf/builtin-help.c                          |  10 +-
>  tools/perf/builtin-inject.c                        |  20 +-
>  tools/perf/builtin-kmem.c                          |  32 +-
>  tools/perf/builtin-kvm.c                           |  32 +-
>  tools/perf/builtin-list.c                          |   8 +-
>  tools/perf/builtin-lock.c                          |  30 +-
>  tools/perf/builtin-mem.c                           |  10 +-
>  tools/perf/builtin-probe.c                         |  16 +-
>  tools/perf/builtin-record.c                        |  32 +-
>  tools/perf/builtin-report.c                        |  44 +--
>  tools/perf/builtin-sched.c                         |  28 +-
>  tools/perf/builtin-script.c                        |  30 +-
>  tools/perf/builtin-stat.c                          |  28 +-
>  tools/perf/builtin-timechart.c                     |  32 +-
>  tools/perf/builtin-top.c                           |  38 +-
>  tools/perf/builtin-trace.c                         |  24 +-
>  tools/perf/builtin.h                               |   4 +-
>  tools/perf/config/Makefile                         |  10 +-
>  tools/perf/perf.c                                  |  10 +-
>  tools/perf/perf.h                                  |   2 +-
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   4 +-
>  .../perf/scripts/python/Perf-Trace-Util/Context.c  |   4 +-
>  tools/perf/tests/hists_common.c                    |  14 +-
>  tools/perf/tests/hists_cumulate.c                  |  16 +-
>  tools/perf/tests/hists_filter.c                    |  16 +-
>  tools/perf/tests/hists_output.c                    |  16 +-
>  tools/perf/tests/sw-clock.c                        |   8 +-
>  tools/perf/ui/browser.c                            |   4 +-
>  tools/perf/ui/browsers/annotate.c                  |  12 +-
>  tools/perf/ui/browsers/header.c                    |   8 +-
>  tools/perf/ui/browsers/hists.c                     |  12 +-
>  tools/perf/ui/browsers/map.c                       |   6 +-
>  tools/perf/ui/browsers/scripts.c                   |  10 +-
>  tools/perf/ui/gtk/annotate.c                       |   6 +-
>  tools/perf/ui/gtk/helpline.c                       |   2 +-
>  tools/perf/ui/gtk/setup.c                          |   4 +-
>  tools/perf/ui/gtk/util.c                           |   2 +-
>  tools/perf/ui/helpline.h                           |   2 +-
>  tools/perf/ui/hist.c                               |   8 +-
>  tools/perf/ui/setup.c                              |   6 +-
>  tools/perf/ui/stdio/hist.c                         |   8 +-
>  tools/perf/ui/tui/helpline.c                       |   2 +-
>  tools/perf/ui/tui/setup.c                          |   4 +-
>  tools/perf/ui/tui/util.c                           |   6 +-
>  tools/perf/ui/util.c                               |   2 +-
>  232 files changed, 973 insertions(+), 663 deletions(-)
>  create mode 100644 tools/lib/perf_util/Makefile
>  rename tools/{perf/util => lib/perf_util}/PERF-VERSION-GEN (100%)
>  rename tools/{perf/util => lib/perf_util}/abspath.c (100%)
>  rename tools/{perf/util => lib/perf_util}/alias.c (100%)
>  rename tools/{perf/util => lib/perf_util}/annotate.c (100%)
>  rename tools/{perf/util => lib/perf_util}/annotate.h (100%)
>  rename tools/{perf/util => lib/perf_util}/bitmap.c (100%)
>  rename tools/{perf/util => lib/perf_util}/build-id.c (100%)
>  rename tools/{perf/util => lib/perf_util}/build-id.h (100%)
>  rename tools/{perf/util => lib/perf_util}/cache.h (98%)
>  rename tools/{perf/util => lib/perf_util}/callchain.c (100%)
>  rename tools/{perf/util => lib/perf_util}/callchain.h (99%)
>  rename tools/{perf/util => lib/perf_util}/cgroup.c (99%)
>  rename tools/{perf/util => lib/perf_util}/cgroup.h (100%)
>  rename tools/{perf/util => lib/perf_util}/color.c (100%)
>  rename tools/{perf/util => lib/perf_util}/color.h (100%)
>  rename tools/{perf/util => lib/perf_util}/comm.c (100%)
>  rename tools/{perf/util => lib/perf_util}/comm.h (95%)
>  rename tools/{perf/util => lib/perf_util}/config.c (99%)
>  rename tools/{perf/util => lib/perf_util}/cpumap.c (99%)
>  rename tools/{perf/util => lib/perf_util}/cpumap.h (98%)
>  rename tools/{perf/util => lib/perf_util}/ctype.c (100%)
>  rename tools/{perf/util => lib/perf_util}/data.c (100%)
>  rename tools/{perf/util => lib/perf_util}/data.h (100%)
>  rename tools/{perf/util => lib/perf_util}/debug.c (98%)
>  rename tools/{perf/util => lib/perf_util}/debug.h (86%)
>  rename tools/{perf/util => lib/perf_util}/dso.c (100%)
>  rename tools/{perf/util => lib/perf_util}/dso.h (100%)
>  rename tools/{perf/util => lib/perf_util}/dwarf-aux.c (100%)
>  rename tools/{perf/util => lib/perf_util}/dwarf-aux.h (100%)
>  rename tools/{perf/util => lib/perf_util}/environment.c (100%)
>  rename tools/{perf/util => lib/perf_util}/event.c (100%)
>  rename tools/{perf/util => lib/perf_util}/event.h (99%)
>  rename tools/{perf/util => lib/perf_util}/evlist.c (100%)
>  rename tools/{perf/util => lib/perf_util}/evlist.h (99%)
>  rename tools/{perf/util => lib/perf_util}/evsel.c (100%)
>  rename tools/{perf/util => lib/perf_util}/evsel.h (100%)
>  rename tools/{perf/util => lib/perf_util}/exec_cmd.c (100%)
>  rename tools/{perf/util => lib/perf_util}/exec_cmd.h (100%)
>  rename tools/{perf/util => lib/perf_util}/generate-cmdlist.sh (100%)
>  rename tools/{perf/util => lib/perf_util}/header.c (99%)
>  rename tools/{perf/util => lib/perf_util}/header.h (100%)
>  rename tools/{perf/util => lib/perf_util}/help.c (99%)
>  rename tools/{perf/util => lib/perf_util}/help.h (100%)
>  rename tools/{perf/util => lib/perf_util}/hist.c (100%)
>  rename tools/{perf/util => lib/perf_util}/hist.h (99%)
>  rename tools/{perf/util => lib/perf_util}/hweight.c (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/alternative-asm.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/asm-offsets.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/byteorder.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/cpufeature.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/dwarf2.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/hash.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/hweight.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/swab.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/system.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/uaccess.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/unistd_32.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/asm/unistd_64.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/dwarf-regs.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/bitmap.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/bitops.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/const.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/ctype.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/kernel.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/linkage.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/list.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/poison.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/rbtree.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/rbtree_augmented.h (100%)
>  rename tools/{perf/util => lib/perf_util}/include/linux/string.h (100%)
>  rename tools/{perf/util => lib/perf_util}/intlist.c (100%)
>  rename tools/{perf/util => lib/perf_util}/intlist.h (100%)
>  rename tools/{perf/util => lib/perf_util}/levenshtein.c (100%)
>  rename tools/{perf/util => lib/perf_util}/levenshtein.h (100%)
>  rename tools/{perf/util => lib/perf_util}/machine.c (100%)
>  rename tools/{perf/util => lib/perf_util}/machine.h (100%)
>  rename tools/{perf/util => lib/perf_util}/map.c (100%)
>  rename tools/{perf/util => lib/perf_util}/map.h (100%)
>  rename tools/{perf/util => lib/perf_util}/pager.c (100%)
>  rename tools/{perf/util => lib/perf_util}/parse-events.c (99%)
>  rename tools/{perf/util => lib/perf_util}/parse-events.h (100%)
>  rename tools/{perf/util => lib/perf_util}/parse-events.l (99%)
>  rename tools/{perf/util => lib/perf_util}/parse-events.y (100%)
>  rename tools/{perf/util => lib/perf_util}/parse-options.c (100%)
>  rename tools/{perf/util => lib/perf_util}/parse-options.h (100%)
>  rename tools/{perf/util => lib/perf_util}/path.c (100%)
>  rename tools/{perf/util => lib/perf_util}/perf_regs.c (100%)
>  rename tools/{perf/util => lib/perf_util}/perf_regs.h (100%)
>  rename tools/{perf/util => lib/perf_util}/pmu.c (100%)
>  rename tools/{perf/util => lib/perf_util}/pmu.h (100%)
>  rename tools/{perf/util => lib/perf_util}/pmu.l (100%)
>  rename tools/{perf/util => lib/perf_util}/pmu.y (100%)
>  rename tools/{perf/util => lib/perf_util}/probe-event.c (100%)
>  rename tools/{perf/util => lib/perf_util}/probe-event.h (100%)
>  rename tools/{perf/util => lib/perf_util}/probe-finder.c (100%)
>  rename tools/{perf/util => lib/perf_util}/probe-finder.h (100%)
>  rename tools/{perf/util => lib/perf_util}/pstack.c (100%)
>  rename tools/{perf/util => lib/perf_util}/pstack.h (100%)
>  rename tools/{perf/util => lib/perf_util}/python-ext-sources (100%)
>  rename tools/{perf/util => lib/perf_util}/python.c (100%)
>  rename tools/{perf/util => lib/perf_util}/quote.c (100%)
>  rename tools/{perf/util => lib/perf_util}/quote.h (100%)
>  rename tools/{perf/util => lib/perf_util}/rblist.c (100%)
>  rename tools/{perf/util => lib/perf_util}/rblist.h (100%)
>  rename tools/{perf/util => lib/perf_util}/record.c (100%)
>  rename tools/{perf/util => lib/perf_util}/run-command.c (100%)
>  rename tools/{perf/util => lib/perf_util}/run-command.h (100%)
>  rename tools/{perf/util => lib/perf_util}/scripting-engines/trace-event-perl.c (99%)
>  rename tools/{perf/util => lib/perf_util}/scripting-engines/trace-event-python.c (99%)
>  rename tools/{perf/util => lib/perf_util}/session.c (100%)
>  rename tools/{perf/util => lib/perf_util}/session.h (100%)
>  rename tools/{perf/util => lib/perf_util}/setup.py (100%)
>  rename tools/{perf/util => lib/perf_util}/sigchain.c (100%)
>  rename tools/{perf/util => lib/perf_util}/sigchain.h (100%)
>  rename tools/{perf/util => lib/perf_util}/sort.c (100%)
>  rename tools/{perf/util => lib/perf_util}/sort.h (99%)
>  rename tools/{perf/util => lib/perf_util}/srcline.c (98%)
>  rename tools/{perf/util => lib/perf_util}/stat.c (100%)
>  rename tools/{perf/util => lib/perf_util}/stat.h (100%)
>  rename tools/{perf/util => lib/perf_util}/strbuf.c (100%)
>  rename tools/{perf/util => lib/perf_util}/strbuf.h (100%)
>  rename tools/{perf/util => lib/perf_util}/strfilter.c (100%)
>  rename tools/{perf/util => lib/perf_util}/strfilter.h (100%)
>  rename tools/{perf/util => lib/perf_util}/string.c (100%)
>  rename tools/{perf/util => lib/perf_util}/strlist.c (100%)
>  rename tools/{perf/util => lib/perf_util}/strlist.h (100%)
>  rename tools/{perf/util => lib/perf_util}/svghelper.c (100%)
>  rename tools/{perf/util => lib/perf_util}/svghelper.h (100%)
>  rename tools/{perf/util => lib/perf_util}/symbol-elf.c (100%)
>  rename tools/{perf/util => lib/perf_util}/symbol-minimal.c (100%)
>  rename tools/{perf/util => lib/perf_util}/symbol.c (100%)
>  rename tools/{perf/util => lib/perf_util}/symbol.h (99%)
>  rename tools/{perf/util => lib/perf_util}/target.c (100%)
>  rename tools/{perf/util => lib/perf_util}/target.h (100%)
>  rename tools/{perf/util => lib/perf_util}/thread.c (99%)
>  rename tools/{perf/util => lib/perf_util}/thread.h (100%)
>  rename tools/{perf/util => lib/perf_util}/thread_map.c (100%)
>  rename tools/{perf/util => lib/perf_util}/thread_map.h (100%)
>  rename tools/{perf/util => lib/perf_util}/tool.h (100%)
>  rename tools/{perf/util => lib/perf_util}/top.c (100%)
>  rename tools/{perf/util => lib/perf_util}/top.h (100%)
>  rename tools/{perf/util => lib/perf_util}/trace-event-info.c (99%)
>  rename tools/{perf/util => lib/perf_util}/trace-event-parse.c (99%)
>  rename tools/{perf/util => lib/perf_util}/trace-event-read.c (99%)
>  rename tools/{perf/util => lib/perf_util}/trace-event-scripting.c (99%)
>  rename tools/{perf/util => lib/perf_util}/trace-event.c (100%)
>  rename tools/{perf/util => lib/perf_util}/trace-event.h (100%)
>  rename tools/{perf/util => lib/perf_util}/unwind-libdw.c (100%)
>  rename tools/{perf/util => lib/perf_util}/unwind-libdw.h (100%)
>  rename tools/{perf/util => lib/perf_util}/unwind-libunwind.c (100%)
>  rename tools/{perf/util => lib/perf_util}/unwind.h (100%)
>  rename tools/{perf/util => lib/perf_util}/usage.c (100%)
>  rename tools/{perf/util => lib/perf_util}/util.c (99%)
>  rename tools/{perf/util => lib/perf_util}/util.h (100%)
>  rename tools/{perf/util => lib/perf_util}/values.c (100%)
>  rename tools/{perf/util => lib/perf_util}/values.h (100%)
>  rename tools/{perf/util => lib/perf_util}/vdso.c (100%)
>  rename tools/{perf/util => lib/perf_util}/vdso.h (100%)
>  rename tools/{perf/util => lib/perf_util}/wrapper.c (100%)
>  rename tools/{perf/util => lib/perf_util}/xyarray.c (100%)
>  rename tools/{perf/util => lib/perf_util}/xyarray.h (100%)
> 
> diff --git a/tools/lib/perf_util/Makefile b/tools/lib/perf_util/Makefile
> new file mode 100644
> index 0000000..46f3122
> --- /dev/null
> +++ b/tools/lib/perf_util/Makefile
> @@ -0,0 +1,426 @@
> +# trace-cmd version
> +EP_VERSION = 1
> +EP_PATCHLEVEL = 0
> +EP_EXTRAVERSION = 0
> +
> +# file format version
> +FILE_VERSION = 1
> +
> +MAKEFLAGS += --no-print-directory
> +
> +
> +# Makefiles suck: This macro sets a default value of $(2) for the
> +# variable named by $(1), unless the variable has been set by
> +# environment or command line. This is necessary for CC and AR
> +# because make sets default values, so the simpler ?= approach
> +# won't work as expected.
> +define allow-override
> +  $(if $(or $(findstring environment,$(origin $(1))),\
> +            $(findstring command line,$(origin $(1)))),,\
> +    $(eval $(1) = $(2)))
> +endef
> +
> +# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
> +$(call allow-override,CC,$(CROSS_COMPILE)gcc)
> +$(call allow-override,AR,$(CROSS_COMPILE)ar)
> +
> +EXT = -std=gnu99
> +INSTALL = install
> +
> +# Use DESTDIR for installing into a different root directory.
> +# This is useful for building a package. The program will be
> +# installed in this directory as if it was the root directory.
> +# Then the build tool can move it later.
> +DESTDIR ?=
> +DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
> +
> +prefix ?= /usr/local
> +bindir_relative = bin
> +bindir = $(prefix)/$(bindir_relative)
> +man_dir = $(prefix)/share/man
> +man_dir_SQ = '$(subst ','\'',$(man_dir))'
> +
> +export man_dir man_dir_SQ INSTALL
> +export DESTDIR DESTDIR_SQ
> +
> +include $(if $(BUILD_SRC),$(BUILD_SRC)/)../../scripts/Makefile.include
> +
> +# copy a bit from Linux kbuild
> +
> +ifeq ("$(origin V)", "command line")
> +  VERBOSE = $(V)
> +endif
> +ifndef VERBOSE
> +  VERBOSE = 0
> +endif
> +
> +ifeq ("$(origin O)", "command line")
> +  BUILD_OUTPUT := $(O)
> +endif
> +
> +ifeq ($(BUILD_SRC),)
> +ifneq ($(OUTPUT),)
> +
> +define build_output
> +  $(if $(VERBOSE:1=),@)+$(MAKE) -C $(OUTPUT) \
> +  BUILD_SRC=$(CURDIR)/ -f $(CURDIR)/Makefile $1
> +endef
> +
> +all: sub-make
> +
> +$(MAKECMDGOALS): sub-make
> +
> +sub-make: force
> +	$(call build_output, $(MAKECMDGOALS))
> +
> +
> +# Leave processing to above invocation of make
> +skip-makefile := 1
> +
> +endif # OUTPUT
> +endif # BUILD_SRC
> +
> +# We process the rest of the Makefile if this is the final invocation of make
> +ifeq ($(skip-makefile),)
> +
> +srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
> +objtree		:= $(CURDIR)
> +src		:= $(srctree)
> +obj		:= $(objtree)
> +
> +export prefix bindir src obj
> +
> +# Shell quotes
> +bindir_SQ = $(subst ','\'',$(bindir))
> +bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
> +
> +LIB_FILE = libperfutil.a libperfutil.so
> +
> +CONFIG_INCLUDES = 
> +CONFIG_LIBS	=
> +CONFIG_FLAGS	=
> +
> +VERSION		= $(EP_VERSION)
> +PATCHLEVEL	= $(EP_PATCHLEVEL)
> +EXTRAVERSION	= $(EP_EXTRAVERSION)
> +
> +OBJ		= $@
> +N		=
> +
> +export Q VERBOSE
> +
> +EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
> +
> +INCLUDES = -I. -I $(srctree)/.. -I $(srctree)/../../perf -I $(srctree)/../../include $(CONFIG_INCLUDES)
> +
> +# Set compile option CFLAGS if not set elsewhere
> +CFLAGS ?= -g -Wall
> +
> +# Append required CFLAGS
> +override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES)
> +override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
> +
> +ifeq ($(VERBOSE),1)
> +  Q = @
> +else
> +  Q =
> +endif
> +
> +do_compile_shared_library =			\
> +	($(print_shared_lib_compile)		\
> +	$(CC) --shared $^ -o $@)
> +
> +do_build_static_lib =				\
> +	($(print_static_lib_build)		\
> +	$(RM) $@;  $(AR) rcs $@ $^)
> +
> +$(OUTPUT)parse-events-flex.c: $(src)/parse-events.l $(OUTPUT)parse-events-bison.c
> +	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)parse-events-flex.h $(PARSER_DEBUG_FLEX) $(src)/parse-events.l
> +
> +$(OUTPUT)parse-events-bison.c: $(src)/parse-events.y
> +	$(QUIET_BISON)$(BISON) -v $(src)/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)parse-events-bison.c -p parse_events_
> +
> +$(OUTPUT)pmu-flex.c: $(src)/pmu.l $(OUTPUT)pmu-bison.c
> +	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)pmu-flex.h $(src)/pmu.l
> +
> +$(OUTPUT)pmu-bison.c: $(src)/pmu.y
> +	$(QUIET_BISON)$(BISON) -v $(src)/pmu.y -d -o $(OUTPUT)pmu-bison.c -p perf_pmu_
> +
> +$(OUTPUT)pmu.o: $(OUTPUT)pmu-flex.c $(OUTPUT)pmu-bison.c
> +
> +LIB_OBJS += abspath.o
> +LIB_OBJS += alias.o
> +LIB_OBJS += annotate.o
> +LIB_OBJS += build-id.o
> +LIB_OBJS += config.o
> +LIB_OBJS += ctype.o
> +LIB_OBJS += pmu.o
> +LIB_OBJS += environment.o
> +LIB_OBJS += event.o
> +LIB_OBJS += evlist.o
> +LIB_OBJS += evsel.o
> +LIB_OBJS += exec_cmd.o
> +LIB_OBJS += help.o
> +LIB_OBJS += levenshtein.o
> +LIB_OBJS += parse-options.o
> +LIB_OBJS += parse-events.o
> +LIB_OBJS += path.o
> +LIB_OBJS += bitmap.o
> +LIB_OBJS += hweight.o
> +LIB_OBJS += run-command.o
> +LIB_OBJS += quote.o
> +LIB_OBJS += strbuf.o
> +LIB_OBJS += string.o
> +LIB_OBJS += strlist.o
> +LIB_OBJS += strfilter.o
> +LIB_OBJS += top.o
> +LIB_OBJS += usage.o
> +LIB_OBJS += wrapper.o
> +LIB_OBJS += sigchain.o
> +LIB_OBJS += dso.o
> +LIB_OBJS += symbol.o
> +LIB_OBJS += symbol-elf.o
> +LIB_OBJS += color.o
> +LIB_OBJS += pager.o
> +LIB_OBJS += header.o
> +LIB_OBJS += callchain.o
> +LIB_OBJS += values.o
> +LIB_OBJS += debug.o
> +LIB_OBJS += machine.o
> +LIB_OBJS += map.o
> +LIB_OBJS += pstack.o
> +LIB_OBJS += session.o
> +LIB_OBJS += comm.o
> +LIB_OBJS += thread.o
> +LIB_OBJS += thread_map.o
> +LIB_OBJS += trace-event-parse.o
> +LIB_OBJS += parse-events-flex.o
> +LIB_OBJS += parse-events-bison.o
> +LIB_OBJS += pmu-flex.o
> +LIB_OBJS += pmu-bison.o
> +LIB_OBJS += trace-event-read.o
> +LIB_OBJS += trace-event-info.o
> +LIB_OBJS += trace-event-scripting.o
> +LIB_OBJS += trace-event.o
> +LIB_OBJS += svghelper.o
> +LIB_OBJS += sort.o
> +LIB_OBJS += hist.o
> +LIB_OBJS += probe-event.o
> +LIB_OBJS += util.o
> +LIB_OBJS += xyarray.o
> +LIB_OBJS += cpumap.o
> +LIB_OBJS += cgroup.o
> +LIB_OBJS += target.o
> +LIB_OBJS += rblist.o
> +LIB_OBJS += intlist.o
> +LIB_OBJS += vdso.o
> +LIB_OBJS += stat.o
> +LIB_OBJS += record.o
> +LIB_OBJS += srcline.o
> +LIB_OBJS += data.o
> +
> +# Remove ELF/DWARF dependent codes
> +LIB_OBJS := $(filter-out symbol-elf.o,$(LIB_OBJS))
> +LIB_OBJS := $(filter-out dwarf-aux.o,$(LIB_OBJS))
> +LIB_OBJS := $(filter-out probe-event.o,$(LIB_OBJS))
> +LIB_OBJS := $(filter-out probe-finder.o,$(LIB_OBJS))
> +
> +# Use minimal symbol handling
> +LIB_OBJS += symbol-minimal.o
> +
> +ifndef NO_LIBELF
> +ifndef NO_DWARF
> +  LIB_OBJS += probe-finder.o
> +  LIB_OBJS += dwarf-aux.o
> +endif # NO_DWARF
> +endif # NO_LIBELF
> +
> +ifndef NO_LIBDW_DWARF_UNWIND
> +  LIB_OBJS += unwind-libdw.o
> +endif
> +
> +ifndef NO_LIBUNWIND
> +  LIB_OBJS += unwind-libunwind.o
> +endif
> +
> +ifndef NO_LIBPERL
> +  LIB_OBJS += scripting-engines/trace-event-perl.o
> +endif
> +
> +ifndef NO_LIBPYTHON
> +  LIB_OBJS += scripting-engines/trace-event-python.o
> +endif
> +
> +ifeq ($(NO_PERF_REGS),0)
> +  LIB_OBJS += perf_regs.o
> +endif
> +
> +# ALL_OBJS is used to build the deps and the .o objects
> +ALL_OBJS = $(LIB_OBJS)
> +# Skip the deps check and do not use the default .c=>.o rule
> +# for custom built targets (flex, bison etc.)
> +ALL_OBJS := $(filter-out parse-events.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out parse-events-flex.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out pmu-flex.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out parse-events-bison.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out pmu-bison.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out exec_cmd.o,$(ALL_OBJS))
> +ALL_OBJS := $(filter-out config.o,$(ALL_OBJS))
> +
> +CMD_TARGETS = $(LIB_FILE)
> +
> +TARGETS = $(CMD_TARGETS)
> +
> +all: all_cmd
> +
> +all_cmd: $(CMD_TARGETS)
> +
> +liberfutil.so: $(LIB_OBJS)
> +	$(QUIET_LINK)$(CC) --shared $^ -o $@
> +
> +libperfutil.a: $(LIB_OBJS)
> +	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
> +
> +#
> +# If a target does not match any of the later rules then prefix it by $(OUTPUT)
> +# This makes targets like 'make O=/tmp/perf perf.o' work in a natural way.
> +#
> +ifneq ($(OUTPUT),)
> +%.o: $(OUTPUT)%.o
> +	@echo "    # Redirected target $@ => $(OUTPUT)$@"
> +endif
> +
> +# These two need to be here so that when O= is not used they take precedence
> +# over the general rule for .o
> +%-flex.o: $(OUTPUT)%-flex.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c -I$(src)/ $(CFLAGS) -w $<
> +
> +%-bison.o: $(OUTPUT)%-bison.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c -I$(src)/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
> +
> +$(ALL_OBJS): %.o: $(src)/%.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@
> +
> +exec_cmd.o: $(src)/exec_cmd.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
> +		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
> +		'-DPREFIX="$(prefix_SQ)"' \
> +		$<
> +
> +config.o: $(src)/config.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> +
> +parse-events.o: $(src)/parse-events.c $(OUTPUT)parse-events-flex.c $(OUTPUT)parse-events-bison.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-error -Wno-redundant-decls -Wno-unused-parameter -Wno-unused -Wno-switch-default $(src)/parse-events.c
> +
> +scripting-engines/trace-event-perl.o: $(src)/scripting-engines/trace-event-perl.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
> +
> +scripting-engines/trace-event-python.o: $(src)/scripting-engines/trace-event-python.c $(OUTPUT)LIB_PERFUTIL-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
> +
> +define make_version.h
> +  (echo '/* This file is automatically generated. Do not modify. */';		\
> +   echo \#define VERSION_CODE $(shell						\
> +   expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
> +   echo '#define EXTRAVERSION ' $(EXTRAVERSION);				\
> +   echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
> +   echo '#define FILE_VERSION '$(FILE_VERSION);					\
> +  ) > $1
> +endef
> +
> +define update_version.h
> +  ($(call make_version.h, $@.tmp);		\
> +    if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
> +      rm -f $@.tmp;				\
> +    else					\
> +      echo '  UPDATE                 $@';	\
> +      mv -f $@.tmp $@;				\
> +    fi);
> +endef
> +
> +ep_version.h: force
> +	$(Q)$(N)$(call update_version.h)
> +
> +VERSION_FILES = ep_version.h
> +
> +define update_dir
> +  (echo $1 > $@.tmp;				\
> +   if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
> +     rm -f $@.tmp;				\
> +   else						\
> +     echo '  UPDATE                 $@';	\
> +     mv -f $@.tmp $@;				\
> +   fi);
> +endef
> +
> +## make deps
> +
> +all_objs := $(sort $(ALL_OBJS))
> +all_deps := $(all_objs:%.o=.%.d)
> +
> +# let .d file also depends on the source and header files
> +define check_deps
> +  @set -e; $(RM) $@; \
> +  $(CC) -MM $(CFLAGS) $< > $@.$$$$; \
> +  sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
> +  $(RM) $@.$$$$
> +endef
> +
> +$(all_deps): .%.d: $(src)/%.c
> +	$(Q)$(call check_deps)
> +
> +$(all_objs) : %.o : .%.d
> +
> +dep_includes := $(wildcard $(all_deps))
> +
> +ifneq ($(dep_includes),)
> + include $(dep_includes)
> +endif
> +
> +### Detect environment changes
> +TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
> +
> +$(OUTPUT)LIB_PERFUTIL-CFLAGS: force
> +	@FLAGS='$(TRACK_CFLAGS)'; \
> +	    if test x"$$FLAGS" != x"`cat LIB_PERFUTIL-CFLAGS 2>/dev/null`" ; then \
> +		echo 1>&2 "  FLAGS:   * new build flags or cross compiler"; \
> +		echo "$$FLAGS" > $(OUTPUT)LIB_PERFUTIL-CFLAGS; \
> +            fi
> +
> +tags:	force
> +	$(RM) tags
> +	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
> +	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'
> +
> +TAGS:	force
> +	$(RM) TAGS
> +	find . -name '*.[ch]' | xargs etags \
> +	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
> +
> +define do_install
> +	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
> +		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
> +	fi;						\
> +	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
> +endef
> +
> +install_lib: all_cmd
> +	$(call QUIET_INSTALL, $(LIB_FILE)) \
> +		$(call do_install,$(LIB_FILE),$(bindir_SQ))
> +
> +install: install_lib
> +
> +clean:
> +	$(call QUIET_CLEAN, libperfutil) \
> +		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d *-bison* *-flex* \
> +		$(RM) LIB_PERFUTIL-CFLAGS tags TAGS
> +
> +endif # skip-makefile
> +
> +PHONY += force
> +force:
> +
> +# Declare the contents of the .PHONY variable as phony.  We keep that
> +# information in a variable so we can use it in if_changed and friends.
> +.PHONY: $(PHONY)
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/lib/perf_util/PERF-VERSION-GEN
> similarity index 100%
> rename from tools/perf/util/PERF-VERSION-GEN
> rename to tools/lib/perf_util/PERF-VERSION-GEN
> diff --git a/tools/perf/util/abspath.c b/tools/lib/perf_util/abspath.c
> similarity index 100%
> rename from tools/perf/util/abspath.c
> rename to tools/lib/perf_util/abspath.c
> diff --git a/tools/perf/util/alias.c b/tools/lib/perf_util/alias.c
> similarity index 100%
> rename from tools/perf/util/alias.c
> rename to tools/lib/perf_util/alias.c
> diff --git a/tools/perf/util/annotate.c b/tools/lib/perf_util/annotate.c
> similarity index 100%
> rename from tools/perf/util/annotate.c
> rename to tools/lib/perf_util/annotate.c
> diff --git a/tools/perf/util/annotate.h b/tools/lib/perf_util/annotate.h
> similarity index 100%
> rename from tools/perf/util/annotate.h
> rename to tools/lib/perf_util/annotate.h
> diff --git a/tools/perf/util/bitmap.c b/tools/lib/perf_util/bitmap.c
> similarity index 100%
> rename from tools/perf/util/bitmap.c
> rename to tools/lib/perf_util/bitmap.c
> diff --git a/tools/perf/util/build-id.c b/tools/lib/perf_util/build-id.c
> similarity index 100%
> rename from tools/perf/util/build-id.c
> rename to tools/lib/perf_util/build-id.c
> diff --git a/tools/perf/util/build-id.h b/tools/lib/perf_util/build-id.h
> similarity index 100%
> rename from tools/perf/util/build-id.h
> rename to tools/lib/perf_util/build-id.h
> diff --git a/tools/perf/util/cache.h b/tools/lib/perf_util/cache.h
> similarity index 98%
> rename from tools/perf/util/cache.h
> rename to tools/lib/perf_util/cache.h
> index 7b176dd..2d417b7 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/lib/perf_util/cache.h
> @@ -4,8 +4,8 @@
>  #include <stdbool.h>
>  #include "util.h"
>  #include "strbuf.h"
> -#include "../perf.h"
> -#include "../ui/ui.h"
> +#include <perf.h>
> +#include <ui/ui.h>
>  
>  #define CMD_EXEC_PATH "--exec-path"
>  #define CMD_PERF_DIR "--perf-dir="
> diff --git a/tools/perf/util/callchain.c b/tools/lib/perf_util/callchain.c
> similarity index 100%
> rename from tools/perf/util/callchain.c
> rename to tools/lib/perf_util/callchain.c
> diff --git a/tools/perf/util/callchain.h b/tools/lib/perf_util/callchain.h
> similarity index 99%
> rename from tools/perf/util/callchain.h
> rename to tools/lib/perf_util/callchain.h
> index 8f84423..52e9615 100644
> --- a/tools/perf/util/callchain.h
> +++ b/tools/lib/perf_util/callchain.h
> @@ -1,7 +1,7 @@
>  #ifndef __PERF_CALLCHAIN_H
>  #define __PERF_CALLCHAIN_H
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
>  #include "event.h"
> diff --git a/tools/perf/util/cgroup.c b/tools/lib/perf_util/cgroup.c
> similarity index 99%
> rename from tools/perf/util/cgroup.c
> rename to tools/lib/perf_util/cgroup.c
> index 88f7be3..5f5fceb 100644
> --- a/tools/perf/util/cgroup.c
> +++ b/tools/lib/perf_util/cgroup.c
> @@ -1,5 +1,5 @@
>  #include "util.h"
> -#include "../perf.h"
> +#include <perf.h>
>  #include "parse-options.h"
>  #include "evsel.h"
>  #include "cgroup.h"
> diff --git a/tools/perf/util/cgroup.h b/tools/lib/perf_util/cgroup.h
> similarity index 100%
> rename from tools/perf/util/cgroup.h
> rename to tools/lib/perf_util/cgroup.h
> diff --git a/tools/perf/util/color.c b/tools/lib/perf_util/color.c
> similarity index 100%
> rename from tools/perf/util/color.c
> rename to tools/lib/perf_util/color.c
> diff --git a/tools/perf/util/color.h b/tools/lib/perf_util/color.h
> similarity index 100%
> rename from tools/perf/util/color.h
> rename to tools/lib/perf_util/color.h
> diff --git a/tools/perf/util/comm.c b/tools/lib/perf_util/comm.c
> similarity index 100%
> rename from tools/perf/util/comm.c
> rename to tools/lib/perf_util/comm.c
> diff --git a/tools/perf/util/comm.h b/tools/lib/perf_util/comm.h
> similarity index 95%
> rename from tools/perf/util/comm.h
> rename to tools/lib/perf_util/comm.h
> index fac5bd5..b40ddfe 100644
> --- a/tools/perf/util/comm.h
> +++ b/tools/lib/perf_util/comm.h
> @@ -1,7 +1,7 @@
>  #ifndef __PERF_COMM_H
>  #define __PERF_COMM_H
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include <linux/rbtree.h>
>  #include <linux/list.h>
>  
> diff --git a/tools/perf/util/config.c b/tools/lib/perf_util/config.c
> similarity index 99%
> rename from tools/perf/util/config.c
> rename to tools/lib/perf_util/config.c
> index 24519e1..121bb35 100644
> --- a/tools/perf/util/config.c
> +++ b/tools/lib/perf_util/config.c
> @@ -11,7 +11,7 @@
>  #include "util.h"
>  #include "cache.h"
>  #include "exec_cmd.h"
> -#include "util/hist.h"  /* perf_hist_config */
> +#include <hist.h>  /* perf_hist_config */
>  
>  #define MAXNAME (256)
>  
> diff --git a/tools/perf/util/cpumap.c b/tools/lib/perf_util/cpumap.c
> similarity index 99%
> rename from tools/perf/util/cpumap.c
> rename to tools/lib/perf_util/cpumap.c
> index c4e55b7..0b29702 100644
> --- a/tools/perf/util/cpumap.c
> +++ b/tools/lib/perf_util/cpumap.c
> @@ -1,6 +1,6 @@
>  #include "util.h"
>  #include <api/fs/fs.h>
> -#include "../perf.h"
> +#include <perf.h>
>  #include "cpumap.h"
>  #include <assert.h>
>  #include <stdio.h>
> diff --git a/tools/perf/util/cpumap.h b/tools/lib/perf_util/cpumap.h
> similarity index 98%
> rename from tools/perf/util/cpumap.h
> rename to tools/lib/perf_util/cpumap.h
> index 61a6548..a2c268c 100644
> --- a/tools/perf/util/cpumap.h
> +++ b/tools/lib/perf_util/cpumap.h
> @@ -5,7 +5,7 @@
>  #include <stdbool.h>
>  
>  #include "perf.h"
> -#include "util/debug.h"
> +#include <debug.h>
>  
>  struct cpu_map {
>  	int nr;
> diff --git a/tools/perf/util/ctype.c b/tools/lib/perf_util/ctype.c
> similarity index 100%
> rename from tools/perf/util/ctype.c
> rename to tools/lib/perf_util/ctype.c
> diff --git a/tools/perf/util/data.c b/tools/lib/perf_util/data.c
> similarity index 100%
> rename from tools/perf/util/data.c
> rename to tools/lib/perf_util/data.c
> diff --git a/tools/perf/util/data.h b/tools/lib/perf_util/data.h
> similarity index 100%
> rename from tools/perf/util/data.h
> rename to tools/lib/perf_util/data.h
> diff --git a/tools/perf/util/debug.c b/tools/lib/perf_util/debug.c
> similarity index 98%
> rename from tools/perf/util/debug.c
> rename to tools/lib/perf_util/debug.c
> index 299b555..75ba4c2 100644
> --- a/tools/perf/util/debug.c
> +++ b/tools/lib/perf_util/debug.c
> @@ -1,6 +1,6 @@
>  /* For general debugging purposes */
>  
> -#include "../perf.h"
> +#include <perf.h>
>  
>  #include <string.h>
>  #include <stdarg.h>
> diff --git a/tools/perf/util/debug.h b/tools/lib/perf_util/debug.h
> similarity index 86%
> rename from tools/perf/util/debug.h
> rename to tools/lib/perf_util/debug.h
> index 443694c..dad4f53 100644
> --- a/tools/perf/util/debug.h
> +++ b/tools/lib/perf_util/debug.h
> @@ -4,9 +4,9 @@
>  
>  #include <stdbool.h>
>  #include "event.h"
> -#include "../ui/helpline.h"
> -#include "../ui/progress.h"
> -#include "../ui/util.h"
> +#include <ui/helpline.h>
> +#include <ui/progress.h>
> +#include <ui/util.h>
>  
>  extern int verbose;
>  extern bool quiet, dump_trace;
> diff --git a/tools/perf/util/dso.c b/tools/lib/perf_util/dso.c
> similarity index 100%
> rename from tools/perf/util/dso.c
> rename to tools/lib/perf_util/dso.c
> diff --git a/tools/perf/util/dso.h b/tools/lib/perf_util/dso.h
> similarity index 100%
> rename from tools/perf/util/dso.h
> rename to tools/lib/perf_util/dso.h
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/lib/perf_util/dwarf-aux.c
> similarity index 100%
> rename from tools/perf/util/dwarf-aux.c
> rename to tools/lib/perf_util/dwarf-aux.c
> diff --git a/tools/perf/util/dwarf-aux.h b/tools/lib/perf_util/dwarf-aux.h
> similarity index 100%
> rename from tools/perf/util/dwarf-aux.h
> rename to tools/lib/perf_util/dwarf-aux.h
> diff --git a/tools/perf/util/environment.c b/tools/lib/perf_util/environment.c
> similarity index 100%
> rename from tools/perf/util/environment.c
> rename to tools/lib/perf_util/environment.c
> diff --git a/tools/perf/util/event.c b/tools/lib/perf_util/event.c
> similarity index 100%
> rename from tools/perf/util/event.c
> rename to tools/lib/perf_util/event.c
> diff --git a/tools/perf/util/event.h b/tools/lib/perf_util/event.h
> similarity index 99%
> rename from tools/perf/util/event.h
> rename to tools/lib/perf_util/event.h
> index d970232..b8bbd22 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/lib/perf_util/event.h
> @@ -4,7 +4,7 @@
>  #include <limits.h>
>  #include <stdio.h>
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "map.h"
>  #include "build-id.h"
>  
> diff --git a/tools/perf/util/evlist.c b/tools/lib/perf_util/evlist.c
> similarity index 100%
> rename from tools/perf/util/evlist.c
> rename to tools/lib/perf_util/evlist.c
> diff --git a/tools/perf/util/evlist.h b/tools/lib/perf_util/evlist.h
> similarity index 99%
> rename from tools/perf/util/evlist.h
> rename to tools/lib/perf_util/evlist.h
> index f5173cd..6f24750 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/lib/perf_util/evlist.h
> @@ -3,7 +3,7 @@
>  
>  #include <linux/list.h>
>  #include <stdio.h>
> -#include "../perf.h"
> +#include <perf.h>
>  #include "event.h"
>  #include "evsel.h"
>  #include "util.h"
> diff --git a/tools/perf/util/evsel.c b/tools/lib/perf_util/evsel.c
> similarity index 100%
> rename from tools/perf/util/evsel.c
> rename to tools/lib/perf_util/evsel.c
> diff --git a/tools/perf/util/evsel.h b/tools/lib/perf_util/evsel.h
> similarity index 100%
> rename from tools/perf/util/evsel.h
> rename to tools/lib/perf_util/evsel.h
> diff --git a/tools/perf/util/exec_cmd.c b/tools/lib/perf_util/exec_cmd.c
> similarity index 100%
> rename from tools/perf/util/exec_cmd.c
> rename to tools/lib/perf_util/exec_cmd.c
> diff --git a/tools/perf/util/exec_cmd.h b/tools/lib/perf_util/exec_cmd.h
> similarity index 100%
> rename from tools/perf/util/exec_cmd.h
> rename to tools/lib/perf_util/exec_cmd.h
> diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/lib/perf_util/generate-cmdlist.sh
> similarity index 100%
> rename from tools/perf/util/generate-cmdlist.sh
> rename to tools/lib/perf_util/generate-cmdlist.sh
> diff --git a/tools/perf/util/header.c b/tools/lib/perf_util/header.c
> similarity index 99%
> rename from tools/perf/util/header.c
> rename to tools/lib/perf_util/header.c
> index 893f8e2..fee68cb 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/lib/perf_util/header.c
> @@ -12,7 +12,7 @@
>  #include "evlist.h"
>  #include "evsel.h"
>  #include "header.h"
> -#include "../perf.h"
> +#include <perf.h>
>  #include "trace-event.h"
>  #include "session.h"
>  #include "symbol.h"
> diff --git a/tools/perf/util/header.h b/tools/lib/perf_util/header.h
> similarity index 100%
> rename from tools/perf/util/header.h
> rename to tools/lib/perf_util/header.h
> diff --git a/tools/perf/util/help.c b/tools/lib/perf_util/help.c
> similarity index 99%
> rename from tools/perf/util/help.c
> rename to tools/lib/perf_util/help.c
> index 86c37c4..977d39a 100644
> --- a/tools/perf/util/help.c
> +++ b/tools/lib/perf_util/help.c
> @@ -1,5 +1,5 @@
>  #include "cache.h"
> -#include "../builtin.h"
> +#include <builtin.h>
>  #include "exec_cmd.h"
>  #include "levenshtein.h"
>  #include "help.h"
> diff --git a/tools/perf/util/help.h b/tools/lib/perf_util/help.h
> similarity index 100%
> rename from tools/perf/util/help.h
> rename to tools/lib/perf_util/help.h
> diff --git a/tools/perf/util/hist.c b/tools/lib/perf_util/hist.c
> similarity index 100%
> rename from tools/perf/util/hist.c
> rename to tools/lib/perf_util/hist.c
> diff --git a/tools/perf/util/hist.h b/tools/lib/perf_util/hist.h
> similarity index 99%
> rename from tools/perf/util/hist.h
> rename to tools/lib/perf_util/hist.h
> index 82b28ff..f3d0543 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/lib/perf_util/hist.h
> @@ -293,7 +293,7 @@ struct hist_browser_timer {
>  };
>  
>  #ifdef HAVE_SLANG_SUPPORT
> -#include "../ui/keysyms.h"
> +#include <ui/keysyms.h>
>  int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
>  			     struct hist_browser_timer *hbt);
>  
> diff --git a/tools/perf/util/hweight.c b/tools/lib/perf_util/hweight.c
> similarity index 100%
> rename from tools/perf/util/hweight.c
> rename to tools/lib/perf_util/hweight.c
> diff --git a/tools/perf/util/include/asm/alternative-asm.h b/tools/lib/perf_util/include/asm/alternative-asm.h
> similarity index 100%
> rename from tools/perf/util/include/asm/alternative-asm.h
> rename to tools/lib/perf_util/include/asm/alternative-asm.h
> diff --git a/tools/perf/util/include/asm/asm-offsets.h b/tools/lib/perf_util/include/asm/asm-offsets.h
> similarity index 100%
> rename from tools/perf/util/include/asm/asm-offsets.h
> rename to tools/lib/perf_util/include/asm/asm-offsets.h
> diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/lib/perf_util/include/asm/byteorder.h
> similarity index 100%
> rename from tools/perf/util/include/asm/byteorder.h
> rename to tools/lib/perf_util/include/asm/byteorder.h
> diff --git a/tools/perf/util/include/asm/cpufeature.h b/tools/lib/perf_util/include/asm/cpufeature.h
> similarity index 100%
> rename from tools/perf/util/include/asm/cpufeature.h
> rename to tools/lib/perf_util/include/asm/cpufeature.h
> diff --git a/tools/perf/util/include/asm/dwarf2.h b/tools/lib/perf_util/include/asm/dwarf2.h
> similarity index 100%
> rename from tools/perf/util/include/asm/dwarf2.h
> rename to tools/lib/perf_util/include/asm/dwarf2.h
> diff --git a/tools/perf/util/include/asm/hash.h b/tools/lib/perf_util/include/asm/hash.h
> similarity index 100%
> rename from tools/perf/util/include/asm/hash.h
> rename to tools/lib/perf_util/include/asm/hash.h
> diff --git a/tools/perf/util/include/asm/hweight.h b/tools/lib/perf_util/include/asm/hweight.h
> similarity index 100%
> rename from tools/perf/util/include/asm/hweight.h
> rename to tools/lib/perf_util/include/asm/hweight.h
> diff --git a/tools/perf/util/include/asm/swab.h b/tools/lib/perf_util/include/asm/swab.h
> similarity index 100%
> rename from tools/perf/util/include/asm/swab.h
> rename to tools/lib/perf_util/include/asm/swab.h
> diff --git a/tools/perf/util/include/asm/system.h b/tools/lib/perf_util/include/asm/system.h
> similarity index 100%
> rename from tools/perf/util/include/asm/system.h
> rename to tools/lib/perf_util/include/asm/system.h
> diff --git a/tools/perf/util/include/asm/uaccess.h b/tools/lib/perf_util/include/asm/uaccess.h
> similarity index 100%
> rename from tools/perf/util/include/asm/uaccess.h
> rename to tools/lib/perf_util/include/asm/uaccess.h
> diff --git a/tools/perf/util/include/asm/unistd_32.h b/tools/lib/perf_util/include/asm/unistd_32.h
> similarity index 100%
> rename from tools/perf/util/include/asm/unistd_32.h
> rename to tools/lib/perf_util/include/asm/unistd_32.h
> diff --git a/tools/perf/util/include/asm/unistd_64.h b/tools/lib/perf_util/include/asm/unistd_64.h
> similarity index 100%
> rename from tools/perf/util/include/asm/unistd_64.h
> rename to tools/lib/perf_util/include/asm/unistd_64.h
> diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/lib/perf_util/include/dwarf-regs.h
> similarity index 100%
> rename from tools/perf/util/include/dwarf-regs.h
> rename to tools/lib/perf_util/include/dwarf-regs.h
> diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/lib/perf_util/include/linux/bitmap.h
> similarity index 100%
> rename from tools/perf/util/include/linux/bitmap.h
> rename to tools/lib/perf_util/include/linux/bitmap.h
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/lib/perf_util/include/linux/bitops.h
> similarity index 100%
> rename from tools/perf/util/include/linux/bitops.h
> rename to tools/lib/perf_util/include/linux/bitops.h
> diff --git a/tools/perf/util/include/linux/const.h b/tools/lib/perf_util/include/linux/const.h
> similarity index 100%
> rename from tools/perf/util/include/linux/const.h
> rename to tools/lib/perf_util/include/linux/const.h
> diff --git a/tools/perf/util/include/linux/ctype.h b/tools/lib/perf_util/include/linux/ctype.h
> similarity index 100%
> rename from tools/perf/util/include/linux/ctype.h
> rename to tools/lib/perf_util/include/linux/ctype.h
> diff --git a/tools/perf/util/include/linux/kernel.h b/tools/lib/perf_util/include/linux/kernel.h
> similarity index 100%
> rename from tools/perf/util/include/linux/kernel.h
> rename to tools/lib/perf_util/include/linux/kernel.h
> diff --git a/tools/perf/util/include/linux/linkage.h b/tools/lib/perf_util/include/linux/linkage.h
> similarity index 100%
> rename from tools/perf/util/include/linux/linkage.h
> rename to tools/lib/perf_util/include/linux/linkage.h
> diff --git a/tools/perf/util/include/linux/list.h b/tools/lib/perf_util/include/linux/list.h
> similarity index 100%
> rename from tools/perf/util/include/linux/list.h
> rename to tools/lib/perf_util/include/linux/list.h
> diff --git a/tools/perf/util/include/linux/poison.h b/tools/lib/perf_util/include/linux/poison.h
> similarity index 100%
> rename from tools/perf/util/include/linux/poison.h
> rename to tools/lib/perf_util/include/linux/poison.h
> diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/lib/perf_util/include/linux/rbtree.h
> similarity index 100%
> rename from tools/perf/util/include/linux/rbtree.h
> rename to tools/lib/perf_util/include/linux/rbtree.h
> diff --git a/tools/perf/util/include/linux/rbtree_augmented.h b/tools/lib/perf_util/include/linux/rbtree_augmented.h
> similarity index 100%
> rename from tools/perf/util/include/linux/rbtree_augmented.h
> rename to tools/lib/perf_util/include/linux/rbtree_augmented.h
> diff --git a/tools/perf/util/include/linux/string.h b/tools/lib/perf_util/include/linux/string.h
> similarity index 100%
> rename from tools/perf/util/include/linux/string.h
> rename to tools/lib/perf_util/include/linux/string.h
> diff --git a/tools/perf/util/intlist.c b/tools/lib/perf_util/intlist.c
> similarity index 100%
> rename from tools/perf/util/intlist.c
> rename to tools/lib/perf_util/intlist.c
> diff --git a/tools/perf/util/intlist.h b/tools/lib/perf_util/intlist.h
> similarity index 100%
> rename from tools/perf/util/intlist.h
> rename to tools/lib/perf_util/intlist.h
> diff --git a/tools/perf/util/levenshtein.c b/tools/lib/perf_util/levenshtein.c
> similarity index 100%
> rename from tools/perf/util/levenshtein.c
> rename to tools/lib/perf_util/levenshtein.c
> diff --git a/tools/perf/util/levenshtein.h b/tools/lib/perf_util/levenshtein.h
> similarity index 100%
> rename from tools/perf/util/levenshtein.h
> rename to tools/lib/perf_util/levenshtein.h
> diff --git a/tools/perf/util/machine.c b/tools/lib/perf_util/machine.c
> similarity index 100%
> rename from tools/perf/util/machine.c
> rename to tools/lib/perf_util/machine.c
> diff --git a/tools/perf/util/machine.h b/tools/lib/perf_util/machine.h
> similarity index 100%
> rename from tools/perf/util/machine.h
> rename to tools/lib/perf_util/machine.h
> diff --git a/tools/perf/util/map.c b/tools/lib/perf_util/map.c
> similarity index 100%
> rename from tools/perf/util/map.c
> rename to tools/lib/perf_util/map.c
> diff --git a/tools/perf/util/map.h b/tools/lib/perf_util/map.h
> similarity index 100%
> rename from tools/perf/util/map.h
> rename to tools/lib/perf_util/map.h
> diff --git a/tools/perf/util/pager.c b/tools/lib/perf_util/pager.c
> similarity index 100%
> rename from tools/perf/util/pager.c
> rename to tools/lib/perf_util/pager.c
> diff --git a/tools/perf/util/parse-events.c b/tools/lib/perf_util/parse-events.c
> similarity index 99%
> rename from tools/perf/util/parse-events.c
> rename to tools/lib/perf_util/parse-events.c
> index 1e15df1..b83237c 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/lib/perf_util/parse-events.c
> @@ -1,6 +1,6 @@
>  #include <linux/hw_breakpoint.h>
>  #include "util.h"
> -#include "../perf.h"
> +#include <perf.h>
>  #include "evlist.h"
>  #include "evsel.h"
>  #include "parse-options.h"
> diff --git a/tools/perf/util/parse-events.h b/tools/lib/perf_util/parse-events.h
> similarity index 100%
> rename from tools/perf/util/parse-events.h
> rename to tools/lib/perf_util/parse-events.h
> diff --git a/tools/perf/util/parse-events.l b/tools/lib/perf_util/parse-events.l
> similarity index 99%
> rename from tools/perf/util/parse-events.l
> rename to tools/lib/perf_util/parse-events.l
> index 3432995..166712f 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/lib/perf_util/parse-events.l
> @@ -6,7 +6,7 @@
>  
>  %{
>  #include <errno.h>
> -#include "../perf.h"
> +#include <perf.h>
>  #include "parse-events-bison.h"
>  #include "parse-events.h"
>  
> diff --git a/tools/perf/util/parse-events.y b/tools/lib/perf_util/parse-events.y
> similarity index 100%
> rename from tools/perf/util/parse-events.y
> rename to tools/lib/perf_util/parse-events.y
> diff --git a/tools/perf/util/parse-options.c b/tools/lib/perf_util/parse-options.c
> similarity index 100%
> rename from tools/perf/util/parse-options.c
> rename to tools/lib/perf_util/parse-options.c
> diff --git a/tools/perf/util/parse-options.h b/tools/lib/perf_util/parse-options.h
> similarity index 100%
> rename from tools/perf/util/parse-options.h
> rename to tools/lib/perf_util/parse-options.h
> diff --git a/tools/perf/util/path.c b/tools/lib/perf_util/path.c
> similarity index 100%
> rename from tools/perf/util/path.c
> rename to tools/lib/perf_util/path.c
> diff --git a/tools/perf/util/perf_regs.c b/tools/lib/perf_util/perf_regs.c
> similarity index 100%
> rename from tools/perf/util/perf_regs.c
> rename to tools/lib/perf_util/perf_regs.c
> diff --git a/tools/perf/util/perf_regs.h b/tools/lib/perf_util/perf_regs.h
> similarity index 100%
> rename from tools/perf/util/perf_regs.h
> rename to tools/lib/perf_util/perf_regs.h
> diff --git a/tools/perf/util/pmu.c b/tools/lib/perf_util/pmu.c
> similarity index 100%
> rename from tools/perf/util/pmu.c
> rename to tools/lib/perf_util/pmu.c
> diff --git a/tools/perf/util/pmu.h b/tools/lib/perf_util/pmu.h
> similarity index 100%
> rename from tools/perf/util/pmu.h
> rename to tools/lib/perf_util/pmu.h
> diff --git a/tools/perf/util/pmu.l b/tools/lib/perf_util/pmu.l
> similarity index 100%
> rename from tools/perf/util/pmu.l
> rename to tools/lib/perf_util/pmu.l
> diff --git a/tools/perf/util/pmu.y b/tools/lib/perf_util/pmu.y
> similarity index 100%
> rename from tools/perf/util/pmu.y
> rename to tools/lib/perf_util/pmu.y
> diff --git a/tools/perf/util/probe-event.c b/tools/lib/perf_util/probe-event.c
> similarity index 100%
> rename from tools/perf/util/probe-event.c
> rename to tools/lib/perf_util/probe-event.c
> diff --git a/tools/perf/util/probe-event.h b/tools/lib/perf_util/probe-event.h
> similarity index 100%
> rename from tools/perf/util/probe-event.h
> rename to tools/lib/perf_util/probe-event.h
> diff --git a/tools/perf/util/probe-finder.c b/tools/lib/perf_util/probe-finder.c
> similarity index 100%
> rename from tools/perf/util/probe-finder.c
> rename to tools/lib/perf_util/probe-finder.c
> diff --git a/tools/perf/util/probe-finder.h b/tools/lib/perf_util/probe-finder.h
> similarity index 100%
> rename from tools/perf/util/probe-finder.h
> rename to tools/lib/perf_util/probe-finder.h
> diff --git a/tools/perf/util/pstack.c b/tools/lib/perf_util/pstack.c
> similarity index 100%
> rename from tools/perf/util/pstack.c
> rename to tools/lib/perf_util/pstack.c
> diff --git a/tools/perf/util/pstack.h b/tools/lib/perf_util/pstack.h
> similarity index 100%
> rename from tools/perf/util/pstack.h
> rename to tools/lib/perf_util/pstack.h
> diff --git a/tools/perf/util/python-ext-sources b/tools/lib/perf_util/python-ext-sources
> similarity index 100%
> rename from tools/perf/util/python-ext-sources
> rename to tools/lib/perf_util/python-ext-sources
> diff --git a/tools/perf/util/python.c b/tools/lib/perf_util/python.c
> similarity index 100%
> rename from tools/perf/util/python.c
> rename to tools/lib/perf_util/python.c
> diff --git a/tools/perf/util/quote.c b/tools/lib/perf_util/quote.c
> similarity index 100%
> rename from tools/perf/util/quote.c
> rename to tools/lib/perf_util/quote.c
> diff --git a/tools/perf/util/quote.h b/tools/lib/perf_util/quote.h
> similarity index 100%
> rename from tools/perf/util/quote.h
> rename to tools/lib/perf_util/quote.h
> diff --git a/tools/perf/util/rblist.c b/tools/lib/perf_util/rblist.c
> similarity index 100%
> rename from tools/perf/util/rblist.c
> rename to tools/lib/perf_util/rblist.c
> diff --git a/tools/perf/util/rblist.h b/tools/lib/perf_util/rblist.h
> similarity index 100%
> rename from tools/perf/util/rblist.h
> rename to tools/lib/perf_util/rblist.h
> diff --git a/tools/perf/util/record.c b/tools/lib/perf_util/record.c
> similarity index 100%
> rename from tools/perf/util/record.c
> rename to tools/lib/perf_util/record.c
> diff --git a/tools/perf/util/run-command.c b/tools/lib/perf_util/run-command.c
> similarity index 100%
> rename from tools/perf/util/run-command.c
> rename to tools/lib/perf_util/run-command.c
> diff --git a/tools/perf/util/run-command.h b/tools/lib/perf_util/run-command.h
> similarity index 100%
> rename from tools/perf/util/run-command.h
> rename to tools/lib/perf_util/run-command.h
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/lib/perf_util/scripting-engines/trace-event-perl.c
> similarity index 99%
> rename from tools/perf/util/scripting-engines/trace-event-perl.c
> rename to tools/lib/perf_util/scripting-engines/trace-event-perl.c
> index e108207..27bf505 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/lib/perf_util/scripting-engines/trace-event-perl.c
> @@ -29,7 +29,7 @@
>  #include <EXTERN.h>
>  #include <perl.h>
>  
> -#include "../../perf.h"
> +#include <perf.h>
>  #include "../thread.h"
>  #include "../event.h"
>  #include "../trace-event.h"
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/lib/perf_util/scripting-engines/trace-event-python.c
> similarity index 99%
> rename from tools/perf/util/scripting-engines/trace-event-python.c
> rename to tools/lib/perf_util/scripting-engines/trace-event-python.c
> index cd9774d..8dcc85f 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/lib/perf_util/scripting-engines/trace-event-python.c
> @@ -26,7 +26,7 @@
>  #include <string.h>
>  #include <errno.h>
>  
> -#include "../../perf.h"
> +#include <perf.h>
>  #include "../evsel.h"
>  #include "../util.h"
>  #include "../event.h"
> diff --git a/tools/perf/util/session.c b/tools/lib/perf_util/session.c
> similarity index 100%
> rename from tools/perf/util/session.c
> rename to tools/lib/perf_util/session.c
> diff --git a/tools/perf/util/session.h b/tools/lib/perf_util/session.h
> similarity index 100%
> rename from tools/perf/util/session.h
> rename to tools/lib/perf_util/session.h
> diff --git a/tools/perf/util/setup.py b/tools/lib/perf_util/setup.py
> similarity index 100%
> rename from tools/perf/util/setup.py
> rename to tools/lib/perf_util/setup.py
> diff --git a/tools/perf/util/sigchain.c b/tools/lib/perf_util/sigchain.c
> similarity index 100%
> rename from tools/perf/util/sigchain.c
> rename to tools/lib/perf_util/sigchain.c
> diff --git a/tools/perf/util/sigchain.h b/tools/lib/perf_util/sigchain.h
> similarity index 100%
> rename from tools/perf/util/sigchain.h
> rename to tools/lib/perf_util/sigchain.h
> diff --git a/tools/perf/util/sort.c b/tools/lib/perf_util/sort.c
> similarity index 100%
> rename from tools/perf/util/sort.c
> rename to tools/lib/perf_util/sort.c
> diff --git a/tools/perf/util/sort.h b/tools/lib/perf_util/sort.h
> similarity index 99%
> rename from tools/perf/util/sort.h
> rename to tools/lib/perf_util/sort.h
> index 426b873..7e32dce 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/lib/perf_util/sort.h
> @@ -1,6 +1,6 @@
>  #ifndef __PERF_SORT_H
>  #define __PERF_SORT_H
> -#include "../builtin.h"
> +#include <builtin.h>
>  
>  #include "util.h"
>  
> @@ -14,7 +14,7 @@
>  #include "strlist.h"
>  #include "values.h"
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "debug.h"
>  #include "header.h"
>  
> diff --git a/tools/perf/util/srcline.c b/tools/lib/perf_util/srcline.c
> similarity index 98%
> rename from tools/perf/util/srcline.c
> rename to tools/lib/perf_util/srcline.c
> index f3e4bc5..77ef2da 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/lib/perf_util/srcline.c
> @@ -4,9 +4,9 @@
>  
>  #include <linux/kernel.h>
>  
> -#include "util/dso.h"
> -#include "util/util.h"
> -#include "util/debug.h"
> +#include <dso.h>
> +#include <util.h>
> +#include <debug.h>
>  
>  #ifdef HAVE_LIBBFD_SUPPORT
>  
> diff --git a/tools/perf/util/stat.c b/tools/lib/perf_util/stat.c
> similarity index 100%
> rename from tools/perf/util/stat.c
> rename to tools/lib/perf_util/stat.c
> diff --git a/tools/perf/util/stat.h b/tools/lib/perf_util/stat.h
> similarity index 100%
> rename from tools/perf/util/stat.h
> rename to tools/lib/perf_util/stat.h
> diff --git a/tools/perf/util/strbuf.c b/tools/lib/perf_util/strbuf.c
> similarity index 100%
> rename from tools/perf/util/strbuf.c
> rename to tools/lib/perf_util/strbuf.c
> diff --git a/tools/perf/util/strbuf.h b/tools/lib/perf_util/strbuf.h
> similarity index 100%
> rename from tools/perf/util/strbuf.h
> rename to tools/lib/perf_util/strbuf.h
> diff --git a/tools/perf/util/strfilter.c b/tools/lib/perf_util/strfilter.c
> similarity index 100%
> rename from tools/perf/util/strfilter.c
> rename to tools/lib/perf_util/strfilter.c
> diff --git a/tools/perf/util/strfilter.h b/tools/lib/perf_util/strfilter.h
> similarity index 100%
> rename from tools/perf/util/strfilter.h
> rename to tools/lib/perf_util/strfilter.h
> diff --git a/tools/perf/util/string.c b/tools/lib/perf_util/string.c
> similarity index 100%
> rename from tools/perf/util/string.c
> rename to tools/lib/perf_util/string.c
> diff --git a/tools/perf/util/strlist.c b/tools/lib/perf_util/strlist.c
> similarity index 100%
> rename from tools/perf/util/strlist.c
> rename to tools/lib/perf_util/strlist.c
> diff --git a/tools/perf/util/strlist.h b/tools/lib/perf_util/strlist.h
> similarity index 100%
> rename from tools/perf/util/strlist.h
> rename to tools/lib/perf_util/strlist.h
> diff --git a/tools/perf/util/svghelper.c b/tools/lib/perf_util/svghelper.c
> similarity index 100%
> rename from tools/perf/util/svghelper.c
> rename to tools/lib/perf_util/svghelper.c
> diff --git a/tools/perf/util/svghelper.h b/tools/lib/perf_util/svghelper.h
> similarity index 100%
> rename from tools/perf/util/svghelper.h
> rename to tools/lib/perf_util/svghelper.h
> diff --git a/tools/perf/util/symbol-elf.c b/tools/lib/perf_util/symbol-elf.c
> similarity index 100%
> rename from tools/perf/util/symbol-elf.c
> rename to tools/lib/perf_util/symbol-elf.c
> diff --git a/tools/perf/util/symbol-minimal.c b/tools/lib/perf_util/symbol-minimal.c
> similarity index 100%
> rename from tools/perf/util/symbol-minimal.c
> rename to tools/lib/perf_util/symbol-minimal.c
> diff --git a/tools/perf/util/symbol.c b/tools/lib/perf_util/symbol.c
> similarity index 100%
> rename from tools/perf/util/symbol.c
> rename to tools/lib/perf_util/symbol.c
> diff --git a/tools/perf/util/symbol.h b/tools/lib/perf_util/symbol.h
> similarity index 99%
> rename from tools/perf/util/symbol.h
> rename to tools/lib/perf_util/symbol.h
> index 615c752..24ecad5 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/lib/perf_util/symbol.h
> @@ -5,7 +5,7 @@
>  #include <stdbool.h>
>  #include <stdint.h>
>  #include "map.h"
> -#include "../perf.h"
> +#include <perf.h>
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
>  #include <stdio.h>
> diff --git a/tools/perf/util/target.c b/tools/lib/perf_util/target.c
> similarity index 100%
> rename from tools/perf/util/target.c
> rename to tools/lib/perf_util/target.c
> diff --git a/tools/perf/util/target.h b/tools/lib/perf_util/target.h
> similarity index 100%
> rename from tools/perf/util/target.h
> rename to tools/lib/perf_util/target.h
> diff --git a/tools/perf/util/thread.c b/tools/lib/perf_util/thread.c
> similarity index 99%
> rename from tools/perf/util/thread.c
> rename to tools/lib/perf_util/thread.c
> index 2fde0d5..a3e93d4 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/lib/perf_util/thread.c
> @@ -1,4 +1,4 @@
> -#include "../perf.h"
> +#include <perf.h>
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <string.h>
> diff --git a/tools/perf/util/thread.h b/tools/lib/perf_util/thread.h
> similarity index 100%
> rename from tools/perf/util/thread.h
> rename to tools/lib/perf_util/thread.h
> diff --git a/tools/perf/util/thread_map.c b/tools/lib/perf_util/thread_map.c
> similarity index 100%
> rename from tools/perf/util/thread_map.c
> rename to tools/lib/perf_util/thread_map.c
> diff --git a/tools/perf/util/thread_map.h b/tools/lib/perf_util/thread_map.h
> similarity index 100%
> rename from tools/perf/util/thread_map.h
> rename to tools/lib/perf_util/thread_map.h
> diff --git a/tools/perf/util/tool.h b/tools/lib/perf_util/tool.h
> similarity index 100%
> rename from tools/perf/util/tool.h
> rename to tools/lib/perf_util/tool.h
> diff --git a/tools/perf/util/top.c b/tools/lib/perf_util/top.c
> similarity index 100%
> rename from tools/perf/util/top.c
> rename to tools/lib/perf_util/top.c
> diff --git a/tools/perf/util/top.h b/tools/lib/perf_util/top.h
> similarity index 100%
> rename from tools/perf/util/top.h
> rename to tools/lib/perf_util/top.h
> diff --git a/tools/perf/util/trace-event-info.c b/tools/lib/perf_util/trace-event-info.c
> similarity index 99%
> rename from tools/perf/util/trace-event-info.c
> rename to tools/lib/perf_util/trace-event-info.c
> index 7e6fcfe..e32dd6b 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/lib/perf_util/trace-event-info.c
> @@ -36,7 +36,7 @@
>  #include <linux/list.h>
>  #include <linux/kernel.h>
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "trace-event.h"
>  #include <api/fs/debugfs.h>
>  #include "evsel.h"
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/lib/perf_util/trace-event-parse.c
> similarity index 99%
> rename from tools/perf/util/trace-event-parse.c
> rename to tools/lib/perf_util/trace-event-parse.c
> index c36636f..3b41432 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/lib/perf_util/trace-event-parse.c
> @@ -24,7 +24,7 @@
>  #include <ctype.h>
>  #include <errno.h>
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "util.h"
>  #include "trace-event.h"
>  
> diff --git a/tools/perf/util/trace-event-read.c b/tools/lib/perf_util/trace-event-read.c
> similarity index 99%
> rename from tools/perf/util/trace-event-read.c
> rename to tools/lib/perf_util/trace-event-read.c
> index e113e18..a3e1f3a 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/lib/perf_util/trace-event-read.c
> @@ -33,7 +33,7 @@
>  #include <unistd.h>
>  #include <errno.h>
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "util.h"
>  #include "trace-event.h"
>  
> diff --git a/tools/perf/util/trace-event-scripting.c b/tools/lib/perf_util/trace-event-scripting.c
> similarity index 99%
> rename from tools/perf/util/trace-event-scripting.c
> rename to tools/lib/perf_util/trace-event-scripting.c
> index 57aaccc..3ab8501 100644
> --- a/tools/perf/util/trace-event-scripting.c
> +++ b/tools/lib/perf_util/trace-event-scripting.c
> @@ -24,7 +24,7 @@
>  #include <string.h>
>  #include <errno.h>
>  
> -#include "../perf.h"
> +#include <perf.h>
>  #include "util.h"
>  #include "trace-event.h"
>  
> diff --git a/tools/perf/util/trace-event.c b/tools/lib/perf_util/trace-event.c
> similarity index 100%
> rename from tools/perf/util/trace-event.c
> rename to tools/lib/perf_util/trace-event.c
> diff --git a/tools/perf/util/trace-event.h b/tools/lib/perf_util/trace-event.h
> similarity index 100%
> rename from tools/perf/util/trace-event.h
> rename to tools/lib/perf_util/trace-event.h
> diff --git a/tools/perf/util/unwind-libdw.c b/tools/lib/perf_util/unwind-libdw.c
> similarity index 100%
> rename from tools/perf/util/unwind-libdw.c
> rename to tools/lib/perf_util/unwind-libdw.c
> diff --git a/tools/perf/util/unwind-libdw.h b/tools/lib/perf_util/unwind-libdw.h
> similarity index 100%
> rename from tools/perf/util/unwind-libdw.h
> rename to tools/lib/perf_util/unwind-libdw.h
> diff --git a/tools/perf/util/unwind-libunwind.c b/tools/lib/perf_util/unwind-libunwind.c
> similarity index 100%
> rename from tools/perf/util/unwind-libunwind.c
> rename to tools/lib/perf_util/unwind-libunwind.c
> diff --git a/tools/perf/util/unwind.h b/tools/lib/perf_util/unwind.h
> similarity index 100%
> rename from tools/perf/util/unwind.h
> rename to tools/lib/perf_util/unwind.h
> diff --git a/tools/perf/util/usage.c b/tools/lib/perf_util/usage.c
> similarity index 100%
> rename from tools/perf/util/usage.c
> rename to tools/lib/perf_util/usage.c
> diff --git a/tools/perf/util/util.c b/tools/lib/perf_util/util.c
> similarity index 99%
> rename from tools/perf/util/util.c
> rename to tools/lib/perf_util/util.c
> index 7fff6be..2184fa8 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/lib/perf_util/util.c
> @@ -1,4 +1,4 @@
> -#include "../perf.h"
> +#include <perf.h>
>  #include "util.h"
>  #include <api/fs/fs.h>
>  #include <sys/mman.h>
> diff --git a/tools/perf/util/util.h b/tools/lib/perf_util/util.h
> similarity index 100%
> rename from tools/perf/util/util.h
> rename to tools/lib/perf_util/util.h
> diff --git a/tools/perf/util/values.c b/tools/lib/perf_util/values.c
> similarity index 100%
> rename from tools/perf/util/values.c
> rename to tools/lib/perf_util/values.c
> diff --git a/tools/perf/util/values.h b/tools/lib/perf_util/values.h
> similarity index 100%
> rename from tools/perf/util/values.h
> rename to tools/lib/perf_util/values.h
> diff --git a/tools/perf/util/vdso.c b/tools/lib/perf_util/vdso.c
> similarity index 100%
> rename from tools/perf/util/vdso.c
> rename to tools/lib/perf_util/vdso.c
> diff --git a/tools/perf/util/vdso.h b/tools/lib/perf_util/vdso.h
> similarity index 100%
> rename from tools/perf/util/vdso.h
> rename to tools/lib/perf_util/vdso.h
> diff --git a/tools/perf/util/wrapper.c b/tools/lib/perf_util/wrapper.c
> similarity index 100%
> rename from tools/perf/util/wrapper.c
> rename to tools/lib/perf_util/wrapper.c
> diff --git a/tools/perf/util/xyarray.c b/tools/lib/perf_util/xyarray.c
> similarity index 100%
> rename from tools/perf/util/xyarray.c
> rename to tools/lib/perf_util/xyarray.c
> diff --git a/tools/perf/util/xyarray.h b/tools/lib/perf_util/xyarray.h
> similarity index 100%
> rename from tools/perf/util/xyarray.h
> rename to tools/lib/perf_util/xyarray.h
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 67f7c05..bc9c460 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -75,8 +75,10 @@ ifneq ($(OUTPUT),)
>  #$(info Determined 'OUTPUT' to be $(OUTPUT))
>  endif
>  
> +LIB_PERFUTIL=$(srctree)/tools/lib/perf_util
> +
>  $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
> -	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
> +	@$(SHELL_PATH) $(LIB_PERFUTIL)/PERF-VERSION-GEN $(OUTPUT)
>  	@touch $(OUTPUT)PERF-VERSION-FILE
>  
>  CC = $(CROSS_COMPILE)gcc
> @@ -148,6 +150,9 @@ export LIBTRACEEVENT
>  LIBAPIKFS = $(LIB_PATH)libapikfs.a
>  export LIBAPIKFS
>  
> +LIBPERFUTIL = $(OUTPUT)libperfutil.a
> +export LIBPERFUTIL
> +
>  # python extension build directories
>  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
>  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
> @@ -156,11 +161,11 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
>  
>  python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
>  
> -PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
> -PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS)
> +PYTHON_EXT_SRCS := $(shell grep -v ^\# $(LIB_PERFUTIL)/python-ext-sources)
> +PYTHON_EXT_DEPS := $(LIB_PERFUTIL)/python-ext-sources $(LIB_PERFUTIL)/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS)
>  
>  $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
> -	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
> +	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) $(LIB_PERFUTIL)/setup.py \
>  	  --quiet build_ext; \
>  	mkdir -p $(OUTPUT)python && \
>  	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
> @@ -191,21 +196,6 @@ endif
>  
>  export PERL_PATH
>  
> -$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
> -	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
> -
> -$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
> -	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
> -
> -$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
> -	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
> -
> -$(OUTPUT)util/pmu-bison.c: util/pmu.y
> -	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
> -
> -$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
> -$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
> -
>  LIB_FILE=$(OUTPUT)libperf.a
>  
>  LIB_H += ../lib/symbol/kallsyms.h
> @@ -215,164 +205,91 @@ LIB_H += ../../include/linux/list.h
>  LIB_H += ../../include/uapi/linux/const.h
>  LIB_H += ../include/linux/hash.h
>  LIB_H += ../../include/linux/stringify.h
> -LIB_H += util/include/linux/bitmap.h
> -LIB_H += util/include/linux/bitops.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/bitmap.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/bitops.h
>  LIB_H += ../include/linux/compiler.h
> -LIB_H += util/include/linux/const.h
> -LIB_H += util/include/linux/ctype.h
> -LIB_H += util/include/linux/kernel.h
> -LIB_H += util/include/linux/list.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/const.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/ctype.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/kernel.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/list.h
>  LIB_H += ../include/linux/export.h
> -LIB_H += util/include/linux/poison.h
> -LIB_H += util/include/linux/rbtree.h
> -LIB_H += util/include/linux/rbtree_augmented.h
> -LIB_H += util/include/linux/string.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/poison.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/rbtree.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/rbtree_augmented.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/string.h
>  LIB_H += ../include/linux/types.h
> -LIB_H += util/include/linux/linkage.h
> -LIB_H += util/include/asm/asm-offsets.h
> +LIB_H += $(LIB_PERFUTIL)/include/linux/linkage.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/asm-offsets.h
>  LIB_H += ../include/asm/bug.h
> -LIB_H += util/include/asm/byteorder.h
> -LIB_H += util/include/asm/hweight.h
> -LIB_H += util/include/asm/swab.h
> -LIB_H += util/include/asm/system.h
> -LIB_H += util/include/asm/uaccess.h
> -LIB_H += util/include/dwarf-regs.h
> -LIB_H += util/include/asm/dwarf2.h
> -LIB_H += util/include/asm/cpufeature.h
> -LIB_H += util/include/asm/unistd_32.h
> -LIB_H += util/include/asm/unistd_64.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/byteorder.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/hweight.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/swab.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/system.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/uaccess.h
> +LIB_H += $(LIB_PERFUTIL)/include/dwarf-regs.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/dwarf2.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/cpufeature.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/unistd_32.h
> +LIB_H += $(LIB_PERFUTIL)/include/asm/unistd_64.h
>  LIB_H += perf.h
> -LIB_H += util/annotate.h
> -LIB_H += util/cache.h
> -LIB_H += util/callchain.h
> -LIB_H += util/build-id.h
> -LIB_H += util/debug.h
> -LIB_H += util/pmu.h
> -LIB_H += util/event.h
> -LIB_H += util/evsel.h
> -LIB_H += util/evlist.h
> -LIB_H += util/exec_cmd.h
> -LIB_H += util/levenshtein.h
> -LIB_H += util/machine.h
> -LIB_H += util/map.h
> -LIB_H += util/parse-options.h
> -LIB_H += util/parse-events.h
> -LIB_H += util/quote.h
> -LIB_H += util/util.h
> -LIB_H += util/xyarray.h
> -LIB_H += util/header.h
> -LIB_H += util/help.h
> -LIB_H += util/session.h
> -LIB_H += util/strbuf.h
> -LIB_H += util/strlist.h
> -LIB_H += util/strfilter.h
> -LIB_H += util/svghelper.h
> -LIB_H += util/tool.h
> -LIB_H += util/run-command.h
> -LIB_H += util/sigchain.h
> -LIB_H += util/dso.h
> -LIB_H += util/symbol.h
> -LIB_H += util/color.h
> -LIB_H += util/values.h
> -LIB_H += util/sort.h
> -LIB_H += util/hist.h
> -LIB_H += util/comm.h
> -LIB_H += util/thread.h
> -LIB_H += util/thread_map.h
> -LIB_H += util/trace-event.h
> -LIB_H += util/probe-finder.h
> -LIB_H += util/dwarf-aux.h
> -LIB_H += util/probe-event.h
> -LIB_H += util/pstack.h
> -LIB_H += util/cpumap.h
> -LIB_H += util/top.h
> +LIB_H += $(LIB_PERFUTIL)/annotate.h
> +LIB_H += $(LIB_PERFUTIL)/cache.h
> +LIB_H += $(LIB_PERFUTIL)/callchain.h
> +LIB_H += $(LIB_PERFUTIL)/build-id.h
> +LIB_H += $(LIB_PERFUTIL)/debug.h
> +LIB_H += $(LIB_PERFUTIL)/pmu.h
> +LIB_H += $(LIB_PERFUTIL)/event.h
> +LIB_H += $(LIB_PERFUTIL)/evsel.h
> +LIB_H += $(LIB_PERFUTIL)/evlist.h
> +LIB_H += $(LIB_PERFUTIL)/exec_cmd.h
> +LIB_H += $(LIB_PERFUTIL)/levenshtein.h
> +LIB_H += $(LIB_PERFUTIL)/machine.h
> +LIB_H += $(LIB_PERFUTIL)/map.h
> +LIB_H += $(LIB_PERFUTIL)/parse-options.h
> +LIB_H += $(LIB_PERFUTIL)/parse-events.h
> +LIB_H += $(LIB_PERFUTIL)/quote.h
> +LIB_H += $(LIB_PERFUTIL)/util.h
> +LIB_H += $(LIB_PERFUTIL)/xyarray.h
> +LIB_H += $(LIB_PERFUTIL)/header.h
> +LIB_H += $(LIB_PERFUTIL)/help.h
> +LIB_H += $(LIB_PERFUTIL)/session.h
> +LIB_H += $(LIB_PERFUTIL)/strbuf.h
> +LIB_H += $(LIB_PERFUTIL)/strlist.h
> +LIB_H += $(LIB_PERFUTIL)/strfilter.h
> +LIB_H += $(LIB_PERFUTIL)/svghelper.h
> +LIB_H += $(LIB_PERFUTIL)/tool.h
> +LIB_H += $(LIB_PERFUTIL)/run-command.h
> +LIB_H += $(LIB_PERFUTIL)/sigchain.h
> +LIB_H += $(LIB_PERFUTIL)/dso.h
> +LIB_H += $(LIB_PERFUTIL)/symbol.h
> +LIB_H += $(LIB_PERFUTIL)/color.h
> +LIB_H += $(LIB_PERFUTIL)/values.h
> +LIB_H += $(LIB_PERFUTIL)/sort.h
> +LIB_H += $(LIB_PERFUTIL)/hist.h
> +LIB_H += $(LIB_PERFUTIL)/comm.h
> +LIB_H += $(LIB_PERFUTIL)/thread.h
> +LIB_H += $(LIB_PERFUTIL)/thread_map.h
> +LIB_H += $(LIB_PERFUTIL)/trace-event.h
> +LIB_H += $(LIB_PERFUTIL)/probe-finder.h
> +LIB_H += $(LIB_PERFUTIL)/dwarf-aux.h
> +LIB_H += $(LIB_PERFUTIL)/probe-event.h
> +LIB_H += $(LIB_PERFUTIL)/pstack.h
> +LIB_H += $(LIB_PERFUTIL)/cpumap.h
> +LIB_H += $(LIB_PERFUTIL)/top.h
>  LIB_H += $(ARCH_INCLUDE)
> -LIB_H += util/cgroup.h
> +LIB_H += $(LIB_PERFUTIL)/cgroup.h
>  LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
> -LIB_H += util/target.h
> -LIB_H += util/rblist.h
> -LIB_H += util/intlist.h
> -LIB_H += util/perf_regs.h
> -LIB_H += util/unwind.h
> -LIB_H += util/vdso.h
> +LIB_H += $(LIB_PERFUTIL)/target.h
> +LIB_H += $(LIB_PERFUTIL)/rblist.h
> +LIB_H += $(LIB_PERFUTIL)/intlist.h
> +LIB_H += $(LIB_PERFUTIL)/perf_regs.h
> +LIB_H += $(LIB_PERFUTIL)/unwind.h
> +LIB_H += $(LIB_PERFUTIL)/vdso.h
>  LIB_H += ui/helpline.h
>  LIB_H += ui/progress.h
>  LIB_H += ui/util.h
>  LIB_H += ui/ui.h
> -LIB_H += util/data.h
> -
> -LIB_OBJS += $(OUTPUT)util/abspath.o
> -LIB_OBJS += $(OUTPUT)util/alias.o
> -LIB_OBJS += $(OUTPUT)util/annotate.o
> -LIB_OBJS += $(OUTPUT)util/build-id.o
> -LIB_OBJS += $(OUTPUT)util/config.o
> -LIB_OBJS += $(OUTPUT)util/ctype.o
> -LIB_OBJS += $(OUTPUT)util/pmu.o
> -LIB_OBJS += $(OUTPUT)util/environment.o
> -LIB_OBJS += $(OUTPUT)util/event.o
> -LIB_OBJS += $(OUTPUT)util/evlist.o
> -LIB_OBJS += $(OUTPUT)util/evsel.o
> -LIB_OBJS += $(OUTPUT)util/exec_cmd.o
> -LIB_OBJS += $(OUTPUT)util/help.o
> -LIB_OBJS += $(OUTPUT)util/kallsyms.o
> -LIB_OBJS += $(OUTPUT)util/levenshtein.o
> -LIB_OBJS += $(OUTPUT)util/parse-options.o
> -LIB_OBJS += $(OUTPUT)util/parse-events.o
> -LIB_OBJS += $(OUTPUT)util/path.o
> -LIB_OBJS += $(OUTPUT)util/rbtree.o
> -LIB_OBJS += $(OUTPUT)util/bitmap.o
> -LIB_OBJS += $(OUTPUT)util/hweight.o
> -LIB_OBJS += $(OUTPUT)util/run-command.o
> -LIB_OBJS += $(OUTPUT)util/quote.o
> -LIB_OBJS += $(OUTPUT)util/strbuf.o
> -LIB_OBJS += $(OUTPUT)util/string.o
> -LIB_OBJS += $(OUTPUT)util/strlist.o
> -LIB_OBJS += $(OUTPUT)util/strfilter.o
> -LIB_OBJS += $(OUTPUT)util/top.o
> -LIB_OBJS += $(OUTPUT)util/usage.o
> -LIB_OBJS += $(OUTPUT)util/wrapper.o
> -LIB_OBJS += $(OUTPUT)util/sigchain.o
> -LIB_OBJS += $(OUTPUT)util/dso.o
> -LIB_OBJS += $(OUTPUT)util/symbol.o
> -LIB_OBJS += $(OUTPUT)util/symbol-elf.o
> -LIB_OBJS += $(OUTPUT)util/color.o
> -LIB_OBJS += $(OUTPUT)util/pager.o
> -LIB_OBJS += $(OUTPUT)util/header.o
> -LIB_OBJS += $(OUTPUT)util/callchain.o
> -LIB_OBJS += $(OUTPUT)util/values.o
> -LIB_OBJS += $(OUTPUT)util/debug.o
> -LIB_OBJS += $(OUTPUT)util/machine.o
> -LIB_OBJS += $(OUTPUT)util/map.o
> -LIB_OBJS += $(OUTPUT)util/pstack.o
> -LIB_OBJS += $(OUTPUT)util/session.o
> -LIB_OBJS += $(OUTPUT)util/comm.o
> -LIB_OBJS += $(OUTPUT)util/thread.o
> -LIB_OBJS += $(OUTPUT)util/thread_map.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
> -LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
> -LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
> -LIB_OBJS += $(OUTPUT)util/pmu-flex.o
> -LIB_OBJS += $(OUTPUT)util/pmu-bison.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-read.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-info.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
> -LIB_OBJS += $(OUTPUT)util/trace-event.o
> -LIB_OBJS += $(OUTPUT)util/svghelper.o
> -LIB_OBJS += $(OUTPUT)util/sort.o
> -LIB_OBJS += $(OUTPUT)util/hist.o
> -LIB_OBJS += $(OUTPUT)util/probe-event.o
> -LIB_OBJS += $(OUTPUT)util/util.o
> -LIB_OBJS += $(OUTPUT)util/xyarray.o
> -LIB_OBJS += $(OUTPUT)util/cpumap.o
> -LIB_OBJS += $(OUTPUT)util/cgroup.o
> -LIB_OBJS += $(OUTPUT)util/target.o
> -LIB_OBJS += $(OUTPUT)util/rblist.o
> -LIB_OBJS += $(OUTPUT)util/intlist.o
> -LIB_OBJS += $(OUTPUT)util/vdso.o
> -LIB_OBJS += $(OUTPUT)util/stat.o
> -LIB_OBJS += $(OUTPUT)util/record.o
> -LIB_OBJS += $(OUTPUT)util/srcline.o
> -LIB_OBJS += $(OUTPUT)util/data.o
> +LIB_H += $(LIB_PERFUTIL)/data.h
>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> @@ -383,6 +300,9 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
>  
>  LIB_OBJS += $(OUTPUT)arch/common.o
>  
> +LIB_OBJS += $(OUTPUT)lib/symbol/kallsyms.o
> +LIB_OBJS += $(OUTPUT)lib/rbtree.o
> +
>  LIB_OBJS += $(OUTPUT)tests/parse-events.o
>  LIB_OBJS += $(OUTPUT)tests/dso-data.o
>  LIB_OBJS += $(OUTPUT)tests/attr.o
> @@ -456,7 +376,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
>  BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
>  
> -PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
> +PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT) $(LIBPERFUTIL)
>  
>  # We choose to avoid "if .. else if .. else .. endif endif"
>  # because maintaining the nesting to match is a pain.  If
> @@ -471,32 +391,9 @@ endif
>  ifdef NO_LIBELF
>  EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
>  
> -# Remove ELF/DWARF dependent codes
> -LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
> -LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
> -LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
> -LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
> -
>  BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
> -
> -# Use minimal symbol handling
> -LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
> -
> -else # NO_LIBELF
> -ifndef NO_DWARF
> -  LIB_OBJS += $(OUTPUT)util/probe-finder.o
> -  LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
> -endif # NO_DWARF
> -endif # NO_LIBELF
> -
> -ifndef NO_LIBDW_DWARF_UNWIND
> -  LIB_OBJS += $(OUTPUT)util/unwind-libdw.o
> -  LIB_H += util/unwind-libdw.h
>  endif
>  
> -ifndef NO_LIBUNWIND
> -  LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
> -endif
>  LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
>  
>  ifndef NO_LIBAUDIT
> @@ -539,12 +436,10 @@ install-gtk: $(OUTPUT)libperf-gtk.so
>  endif
>  
>  ifndef NO_LIBPERL
> -  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
>    LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
>  endif
>  
>  ifndef NO_LIBPYTHON
> -  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>    LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>  endif
>  
> @@ -552,7 +447,6 @@ ifeq ($(NO_PERF_REGS),0)
>    ifeq ($(ARCH),x86)
>      LIB_H += arch/x86/include/perf_regs.h
>    endif
> -  LIB_OBJS += $(OUTPUT)util/perf_regs.o
>  endif
>  
>  ifndef NO_LIBNUMA
> @@ -608,10 +502,10 @@ $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPU
>  		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
>  		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
>  
> -$(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
> +$(OUTPUT)common-cmds.h: $(LIB_PERFUTIL)/generate-cmdlist.sh command-list.txt
>  
>  $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
> -	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
> +	$(QUIET_GEN). $(LIB_PERFUTIL)/generate-cmdlist.sh > $@+ && mv $@+ $@
>  
>  $(SCRIPTS) : % : %.sh
>  	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
> @@ -630,8 +524,6 @@ $(OUTPUT)perf.o perf.spec \
>  ifneq ($(OUTPUT),)
>  %.o: $(OUTPUT)%.o
>  	@echo "    # Redirected target $@ => $(OUTPUT)$@"
> -util/%.o: $(OUTPUT)util/%.o
> -	@echo "    # Redirected target $@ => $(OUTPUT)$@"
>  bench/%.o: $(OUTPUT)bench/%.o
>  	@echo "    # Redirected target $@ => $(OUTPUT)$@"
>  tests/%.o: $(OUTPUT)tests/%.o
> @@ -641,12 +533,6 @@ endif
>  # These two need to be here so that when O= is not used they take precedence
>  # over the general rule for .o
>  
> -$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
> -
> -$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
> -
>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
>  $(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
> @@ -658,12 +544,6 @@ $(OUTPUT)%.o: %.S
>  $(OUTPUT)%.s: %.S
>  	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
>  
> -$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
> -		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
> -		'-DPREFIX="$(prefix_SQ)"' \
> -		$<
> -
>  $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
>  		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
> @@ -678,9 +558,6 @@ $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)tests/dwarf-unwind.o: tests/dwarf-unwind.c
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -fno-optimize-sibling-calls $<
>  
> -$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> -
>  $(OUTPUT)ui/setup.o: ui/setup.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DLIBDIR='"$(libdir_SQ)"' $<
>  
> @@ -699,24 +576,15 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
>  
> -$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
> +$(OUTPUT)lib/symbol/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
>  
> -$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
> +$(OUTPUT)lib/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
>  
> -$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
> -
> -$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
> -
>  $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
>  
> -$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
> -
>  $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
>  
> @@ -730,9 +598,6 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
>  # we depend the various files onto their directories.
>  DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
>  DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
> -# no need to add flex objects, because they depend on bison ones
> -DIRECTORY_DEPS += $(OUTPUT)util/parse-events-bison.c
> -DIRECTORY_DEPS += $(OUTPUT)util/pmu-bison.c
>  
>  OUTPUT_DIRECTORIES := $(sort $(dir $(DIRECTORY_DEPS)))
>  
> @@ -776,6 +641,25 @@ ifeq ($(subdir),)
>  	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
>  endif
>  
> +LIBPERFUTIL_FLAGS   = O=$(OUTPUT) $(QUIET_SUBDIR1)
> +LIBPERFUTIL_FLAGS  += NO_LIBELF=$(NO_LIBELF) NO_DWARF=$(NO_DWARF)
> +LIBPERFUTIL_FLAGS  += NO_LIBDW_DWARF_UNWIND=$(NO_LIBDW_DWARF_UNWIND)
> +LIBPERFUTIL_FLAGS  += NO_LIBUNWIND=$(NO_LIBUNWIND) NO_LIBPERL=$(NO_LIBPERL)
> +LIBPERFUTIL_FLAGS  += NO_LIBPYTHON=$(NO_LIBPYTHON) NO_PERF_REGS=$(NO_PERF_REGS)
> +LIBPERFUTIL_FLAGS  += FLEX=$(FLEX) BISON=$(BISON)
> +LIBPERFUTIL_FLAGS  += perfexecdir_SQ=$(perfexecdir_SQ) prefix_SQ=$(prefix_SQ)
> +LIBPERFUTIL_FLAGS  += ETC_PERFCONFIG_SQ=$(ETC_PERFCONFIG_SQ)
> +LIBPERFUTIL_FLAGS  += CC=$(CC)
> +LIBPERFUTIL_FLAGS  += CFLAGS="-g -Wall $(CFLAGS) $(EXTRA_CFLAGS)"
> +
> +LIBPERFUTIL_SOURCES = $(wildcard $(LIB_PERFUTIL)/*.[ch])
> +$(LIBPERFUTIL): $(LIBPERFUTIL_SOURCES) $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_SUBDIR0)$(LIB_PERFUTIL) $(LIBPERFUTIL_FLAGS) libperfutil.a
> +
> +$(LIBPERFUTIL)-clean:
> +	$(call QUIET_CLEAN, libperfutil)
> +	@$(MAKE) -C $(LIB_PERFUTIL) O=$(OUTPUT) clean >/dev/null
> +
>  help:
>  	@echo 'Perf make targets:'
>  	@echo '  doc		- make *all* documentation (see below)'
> @@ -896,7 +780,7 @@ endif
>  install: install-bin try-install-man install-traceevent-plugins
>  
>  install-python_ext:
> -	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
> +	$(PYTHON_WORD) $(LIB_PERFUTIL)/setup.py --quiet install --root='/$(DESTDIR_SQ)'
>  
>  # 'make install-doc' should call 'make -C Documentation install'
>  $(INSTALL_DOC_TARGETS):
> @@ -912,10 +796,10 @@ config-clean:
>  	$(call QUIET_CLEAN, config)
>  	@$(MAKE) -C config/feature-checks clean >/dev/null
>  
> -clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
> +clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean $(LIBPERFUTIL)-clean config-clean
>  	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
>  	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
> -	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
> +	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES
>  	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
>  	$(python-clean)
>  
> diff --git a/tools/perf/arch/arm/util/unwind-libdw.c b/tools/perf/arch/arm/util/unwind-libdw.c
> index b4176c6..83716f0 100644
> --- a/tools/perf/arch/arm/util/unwind-libdw.c
> +++ b/tools/perf/arch/arm/util/unwind-libdw.c
> @@ -1,6 +1,6 @@
>  #include <elfutils/libdwfl.h>
> -#include "../../util/unwind-libdw.h"
> -#include "../../util/perf_regs.h"
> +#include <unwind-libdw.h>
> +#include <perf_regs.h>
>  
>  bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
>  {
> diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
> index 729ed69..6650eed 100644
> --- a/tools/perf/arch/arm/util/unwind-libunwind.c
> +++ b/tools/perf/arch/arm/util/unwind-libunwind.c
> @@ -2,7 +2,7 @@
>  #include <errno.h>
>  #include <libunwind.h>
>  #include "perf_regs.h"
> -#include "../../util/unwind.h"
> +#include <unwind.h>
>  
>  int libunwind__arch_reg_id(int regnum)
>  {
> diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
> index 436ee43..5ae2768 100644
> --- a/tools/perf/arch/arm64/util/unwind-libunwind.c
> +++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
> @@ -2,7 +2,7 @@
>  #include <errno.h>
>  #include <libunwind.h>
>  #include "perf_regs.h"
> -#include "../../util/unwind.h"
> +#include <unwind.h>
>  
>  int libunwind__arch_reg_id(int regnum)
>  {
> diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
> index 42faf36..7a908cb 100644
> --- a/tools/perf/arch/common.c
> +++ b/tools/perf/arch/common.c
> @@ -1,7 +1,7 @@
>  #include <stdio.h>
>  #include <sys/utsname.h>
>  #include "common.h"
> -#include "../util/debug.h"
> +#include <debug.h>
>  
>  const char *const arm_triplets[] = {
>  	"arm-eabi-",
> diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
> index ede246e..508be80 100644
> --- a/tools/perf/arch/common.h
> +++ b/tools/perf/arch/common.h
> @@ -1,7 +1,7 @@
>  #ifndef ARCH_PERF_COMMON_H
>  #define ARCH_PERF_COMMON_H
>  
> -#include "../util/session.h"
> +#include <session.h>
>  
>  extern const char *objdump_path;
>  
> diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
> index 2f7073d..841b361 100644
> --- a/tools/perf/arch/powerpc/util/header.c
> +++ b/tools/perf/arch/powerpc/util/header.c
> @@ -4,7 +4,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  
> -#include "../../util/header.h"
> +#include <header.h>
>  
>  #define __stringify_1(x)        #x
>  #define __stringify(x)          __stringify_1(x)
> diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
> index 146d12a..9161c71 100644
> --- a/tools/perf/arch/x86/util/header.c
> +++ b/tools/perf/arch/x86/util/header.c
> @@ -4,7 +4,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  
> -#include "../../util/header.h"
> +#include <header.h>
>  
>  static inline void
>  cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
> diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
> index 40021fa..c48e2c8 100644
> --- a/tools/perf/arch/x86/util/tsc.c
> +++ b/tools/perf/arch/x86/util/tsc.c
> @@ -3,9 +3,9 @@
>  
>  #include <linux/perf_event.h>
>  
> -#include "../../perf.h"
> +#include "perf.h"
>  #include <linux/types.h>
> -#include "../../util/debug.h"
> +#include <debug.h>
>  #include "tsc.h"
>  
>  u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
> diff --git a/tools/perf/arch/x86/util/unwind-libdw.c b/tools/perf/arch/x86/util/unwind-libdw.c
> index c4b7217..7ec191b 100644
> --- a/tools/perf/arch/x86/util/unwind-libdw.c
> +++ b/tools/perf/arch/x86/util/unwind-libdw.c
> @@ -1,6 +1,6 @@
>  #include <elfutils/libdwfl.h>
> -#include "../../util/unwind-libdw.h"
> -#include "../../util/perf_regs.h"
> +#include <unwind-libdw.h>
> +#include <perf_regs.h>
>  
>  bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
>  {
> diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
> index 3261f68..44c6614 100644
> --- a/tools/perf/arch/x86/util/unwind-libunwind.c
> +++ b/tools/perf/arch/x86/util/unwind-libunwind.c
> @@ -2,7 +2,7 @@
>  #include <errno.h>
>  #include <libunwind.h>
>  #include "perf_regs.h"
> -#include "../../util/unwind.h"
> +#include <unwind.h>
>  
>  #ifdef HAVE_ARCH_X86_64_SUPPORT
>  int libunwind__arch_reg_id(int regnum)
> diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
> index a84206e..c806863 100644
> --- a/tools/perf/bench/futex-hash.c
> +++ b/tools/perf/bench/futex-hash.c
> @@ -9,10 +9,10 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/stat.h"
> -#include "../util/parse-options.h"
> -#include "../util/header.h"
> +#include <util.h>
> +#include <stat.h>
> +#include <parse-options.h>
> +#include <header.h>
>  #include "bench.h"
>  #include "futex.h"
>  
> diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
> index a1625587..a8580ae 100644
> --- a/tools/perf/bench/futex-requeue.c
> +++ b/tools/perf/bench/futex-requeue.c
> @@ -9,10 +9,10 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/stat.h"
> -#include "../util/parse-options.h"
> -#include "../util/header.h"
> +#include <util.h>
> +#include <stat.h>
> +#include <parse-options.h>
> +#include <header.h>
>  #include "bench.h"
>  #include "futex.h"
>  
> diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
> index d096169..94e2609 100644
> --- a/tools/perf/bench/futex-wake.c
> +++ b/tools/perf/bench/futex-wake.c
> @@ -9,10 +9,10 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/stat.h"
> -#include "../util/parse-options.h"
> -#include "../util/header.h"
> +#include <util.h>
> +#include <stat.h>
> +#include <parse-options.h>
> +#include <header.h>
>  #include "bench.h"
>  #include "futex.h"
>  
> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> index 5ce71d3..2019dbd 100644
> --- a/tools/perf/bench/mem-memcpy.c
> +++ b/tools/perf/bench/mem-memcpy.c
> @@ -7,9 +7,9 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/parse-options.h"
> -#include "../util/header.h"
> +#include <util.h>
> +#include <parse-options.h>
> +#include <header.h>
>  #include "bench.h"
>  #include "mem-memcpy-arch.h"
>  
> diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
> index 9af79d2..84cc664 100644
> --- a/tools/perf/bench/mem-memset.c
> +++ b/tools/perf/bench/mem-memset.c
> @@ -7,9 +7,9 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/parse-options.h"
> -#include "../util/header.h"
> +#include <util.h>
> +#include <parse-options.h>
> +#include <header.h>
>  #include "bench.h"
>  #include "mem-memset-arch.h"
>  
> diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
> index ebfa163..fe38505 100644
> --- a/tools/perf/bench/numa.c
> +++ b/tools/perf/bench/numa.c
> @@ -6,8 +6,8 @@
>  
>  #include "../perf.h"
>  #include "../builtin.h"
> -#include "../util/util.h"
> -#include "../util/parse-options.h"
> +#include <util.h>
> +#include <parse-options.h>
>  
>  #include "bench.h"
>  
> diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
> index cc1190a..7894f67 100644
> --- a/tools/perf/bench/sched-messaging.c
> +++ b/tools/perf/bench/sched-messaging.c
> @@ -10,8 +10,8 @@
>   */
>  
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/parse-options.h"
> +#include <util.h>
> +#include <parse-options.h>
>  #include "../builtin.h"
>  #include "bench.h"
>  
> diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
> index 07a8d76..a5f8544 100644
> --- a/tools/perf/bench/sched-pipe.c
> +++ b/tools/perf/bench/sched-pipe.c
> @@ -9,8 +9,8 @@
>   * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
>   */
>  #include "../perf.h"
> -#include "../util/util.h"
> -#include "../util/parse-options.h"
> +#include <util.h>
> +#include <parse-options.h>
>  #include "../builtin.h"
>  #include "bench.h"
>  
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 1ec429f..c40ecf9 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -7,28 +7,28 @@
>   */
>  #include "builtin.h"
>  
> -#include "util/util.h"
> -#include "util/color.h"
> +#include <util.h>
> +#include <color.h>
>  #include <linux/list.h>
> -#include "util/cache.h"
> +#include <cache.h>
>  #include <linux/rbtree.h>
> -#include "util/symbol.h"
> +#include <symbol.h>
>  
>  #include "perf.h"
> -#include "util/debug.h"
> -
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/annotate.h"
> -#include "util/event.h"
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -#include "util/thread.h"
> -#include "util/sort.h"
> -#include "util/hist.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/data.h"
> +#include <debug.h>
> +
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <annotate.h>
> +#include <event.h>
> +#include <parse-options.h>
> +#include <parse-events.h>
> +#include <thread.h>
> +#include <sort.h>
> +#include <hist.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <data.h>
>  #include "arch/common.h"
>  
>  #include <dlfcn.h>
> diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
> index 1e6e777..0ba682a 100644
> --- a/tools/perf/builtin-bench.c
> +++ b/tools/perf/builtin-bench.c
> @@ -15,8 +15,8 @@
>   *  futex ... Futex performance
>   */
>  #include "perf.h"
> -#include "util/util.h"
> -#include "util/parse-options.h"
> +#include <util.h>
> +#include <parse-options.h>
>  #include "builtin.h"
>  #include "bench/bench.h"
>  
> diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
> index b22dbb1..4ea7748 100644
> --- a/tools/perf/builtin-buildid-cache.c
> +++ b/tools/perf/builtin-buildid-cache.c
> @@ -13,14 +13,14 @@
>  #include <unistd.h>
>  #include "builtin.h"
>  #include "perf.h"
> -#include "util/cache.h"
> -#include "util/debug.h"
> -#include "util/header.h"
> -#include "util/parse-options.h"
> -#include "util/strlist.h"
> -#include "util/build-id.h"
> -#include "util/session.h"
> -#include "util/symbol.h"
> +#include <cache.h>
> +#include <debug.h>
> +#include <header.h>
> +#include <parse-options.h>
> +#include <strlist.h>
> +#include <build-id.h>
> +#include <session.h>
> +#include <symbol.h>
>  
>  static int build_id_cache__kcore_buildid(const char *proc_dir, char *sbuildid)
>  {
> diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
> index ed3873b..f7b6d01 100644
> --- a/tools/perf/builtin-buildid-list.c
> +++ b/tools/perf/builtin-buildid-list.c
> @@ -9,13 +9,13 @@
>   */
>  #include "builtin.h"
>  #include "perf.h"
> -#include "util/build-id.h"
> -#include "util/cache.h"
> -#include "util/debug.h"
> -#include "util/parse-options.h"
> -#include "util/session.h"
> -#include "util/symbol.h"
> -#include "util/data.h"
> +#include <build-id.h>
> +#include <cache.h>
> +#include <debug.h>
> +#include <parse-options.h>
> +#include <session.h>
> +#include <symbol.h>
> +#include <data.h>
>  
>  static int sysfs__fprintf_build_id(FILE *fp)
>  {
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 9a5a035..17216dc 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -6,17 +6,17 @@
>   */
>  #include "builtin.h"
>  
> -#include "util/debug.h"
> -#include "util/event.h"
> -#include "util/hist.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/sort.h"
> -#include "util/symbol.h"
> -#include "util/util.h"
> -#include "util/data.h"
> +#include <debug.h>
> +#include <event.h>
> +#include <hist.h>
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <sort.h>
> +#include <symbol.h>
> +#include <util.h>
> +#include <data.h>
>  
>  #include <stdlib.h>
>  #include <math.h>
> diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
> index c99e0de..983bde9 100644
> --- a/tools/perf/builtin-evlist.c
> +++ b/tools/perf/builtin-evlist.c
> @@ -4,17 +4,17 @@
>   */
>  #include "builtin.h"
>  
> -#include "util/util.h"
> +#include <util.h>
>  
>  #include <linux/list.h>
>  
>  #include "perf.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/parse-events.h"
> -#include "util/parse-options.h"
> -#include "util/session.h"
> -#include "util/data.h"
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <parse-events.h>
> +#include <parse-options.h>
> +#include <session.h>
> +#include <data.h>
>  
>  static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
>  {
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 178b88a..761f7ab 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -4,13 +4,13 @@
>   * Builtin help command
>   */
>  #include "perf.h"
> -#include "util/cache.h"
> +#include <cache.h>
>  #include "builtin.h"
> -#include "util/exec_cmd.h"
> +#include <exec_cmd.h>
>  #include "common-cmds.h"
> -#include "util/parse-options.h"
> -#include "util/run-command.h"
> -#include "util/help.h"
> +#include <parse-options.h>
> +#include <run-command.h>
> +#include <help.h>
>  
>  static struct man_viewer_list {
>  	struct man_viewer_list *next;
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 6a3af00..ff1bd62 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -8,16 +8,16 @@
>  #include "builtin.h"
>  
>  #include "perf.h"
> -#include "util/color.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/debug.h"
> -#include "util/build-id.h"
> -#include "util/data.h"
> -
> -#include "util/parse-options.h"
> +#include <color.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <debug.h>
> +#include <build-id.h>
> +#include <data.h>
> +
> +#include <parse-options.h>
>  
>  #include <linux/list.h>
>  
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index bef3376..f18626b 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -1,22 +1,22 @@
>  #include "builtin.h"
>  #include "perf.h"
>  
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/util.h"
> -#include "util/cache.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/header.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -
> -#include "util/parse-options.h"
> -#include "util/trace-event.h"
> -#include "util/data.h"
> -#include "util/cpumap.h"
> -
> -#include "util/debug.h"
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <util.h>
> +#include <cache.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <header.h>
> +#include <session.h>
> +#include <tool.h>
> +
> +#include <parse-options.h>
> +#include <trace-event.h>
> +#include <data.h>
> +#include <cpumap.h>
> +
> +#include <debug.h>
>  
>  #include <linux/rbtree.h>
>  #include <linux/string.h>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 0f1e5a2..a2315f7 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1,23 +1,23 @@
>  #include "builtin.h"
>  #include "perf.h"
>  
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/util.h"
> -#include "util/cache.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/header.h"
> -#include "util/session.h"
> -#include "util/intlist.h"
> -#include "util/parse-options.h"
> -#include "util/trace-event.h"
> -#include "util/debug.h"
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <util.h>
> +#include <cache.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <header.h>
> +#include <session.h>
> +#include <intlist.h>
> +#include <parse-options.h>
> +#include <trace-event.h>
> +#include <debug.h>
>  #include <api/fs/debugfs.h>
> -#include "util/tool.h"
> -#include "util/stat.h"
> -#include "util/top.h"
> -#include "util/data.h"
> +#include <tool.h>
> +#include <stat.h>
> +#include <top.h>
> +#include <data.h>
>  
>  #include <sys/prctl.h>
>  #ifdef HAVE_TIMERFD_SUPPORT
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..995ccd1 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -11,10 +11,10 @@
>  
>  #include "perf.h"
>  
> -#include "util/parse-events.h"
> -#include "util/cache.h"
> -#include "util/pmu.h"
> -#include "util/parse-options.h"
> +#include <parse-events.h>
> +#include <cache.h>
> +#include <pmu.h>
> +#include <parse-options.h>
>  
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index 6148afc..94284c0 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -1,21 +1,21 @@
>  #include "builtin.h"
>  #include "perf.h"
>  
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/util.h"
> -#include "util/cache.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/header.h"
> -
> -#include "util/parse-options.h"
> -#include "util/trace-event.h"
> -
> -#include "util/debug.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/data.h"
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <util.h>
> +#include <cache.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <header.h>
> +
> +#include <parse-options.h>
> +#include <trace-event.h>
> +
> +#include <debug.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <data.h>
>  
>  #include <sys/types.h>
>  #include <sys/prctl.h>
> diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
> index 4a1a6c9..03443c3 100644
> --- a/tools/perf/builtin-mem.c
> +++ b/tools/perf/builtin-mem.c
> @@ -1,11 +1,11 @@
>  #include "builtin.h"
>  #include "perf.h"
>  
> -#include "util/parse-options.h"
> -#include "util/trace-event.h"
> -#include "util/tool.h"
> -#include "util/session.h"
> -#include "util/data.h"
> +#include <parse-options.h>
> +#include <trace-event.h>
> +#include <tool.h>
> +#include <session.h>
> +#include <data.h>
>  
>  #define MEM_OPERATION_LOAD	"load"
>  #define MEM_OPERATION_STORE	"store"
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index cdcd4eb..6abb35c 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -32,15 +32,15 @@
>  
>  #include "perf.h"
>  #include "builtin.h"
> -#include "util/util.h"
> -#include "util/strlist.h"
> -#include "util/strfilter.h"
> -#include "util/symbol.h"
> -#include "util/debug.h"
> +#include <util.h>
> +#include <strlist.h>
> +#include <strfilter.h>
> +#include <symbol.h>
> +#include <debug.h>
>  #include <api/fs/debugfs.h>
> -#include "util/parse-options.h"
> -#include "util/probe-finder.h"
> -#include "util/probe-event.h"
> +#include <parse-options.h>
> +#include <probe-finder.h>
> +#include <probe-event.h>
>  
>  #define DEFAULT_VAR_FILTER "!__k???tab_* & !__crc_*"
>  #define DEFAULT_FUNC_FILTER "!_*"
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index e4c85b8..f78c4fd 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -9,22 +9,22 @@
>  
>  #include "perf.h"
>  
> -#include "util/build-id.h"
> -#include "util/util.h"
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -
> -#include "util/header.h"
> -#include "util/event.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/debug.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/symbol.h"
> -#include "util/cpumap.h"
> -#include "util/thread_map.h"
> -#include "util/data.h"
> +#include <build-id.h>
> +#include <util.h>
> +#include <parse-options.h>
> +#include <parse-events.h>
> +
> +#include <header.h>
> +#include <event.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <debug.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <symbol.h>
> +#include <cpumap.h>
> +#include <thread_map.h>
> +#include <data.h>
>  
>  #include <unistd.h>
>  #include <sched.h>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 21d830b..dc979be 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -7,33 +7,33 @@
>   */
>  #include "builtin.h"
>  
> -#include "util/util.h"
> -#include "util/cache.h"
> +#include <util.h>
> +#include <cache.h>
>  
> -#include "util/annotate.h"
> -#include "util/color.h"
> +#include <annotate.h>
> +#include <color.h>
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
> -#include "util/symbol.h"
> -#include "util/callchain.h"
> -#include "util/strlist.h"
> -#include "util/values.h"
> +#include <symbol.h>
> +#include <callchain.h>
> +#include <strlist.h>
> +#include <values.h>
>  
>  #include "perf.h"
> -#include "util/debug.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/header.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -
> -#include "util/thread.h"
> -#include "util/sort.h"
> -#include "util/hist.h"
> -#include "util/data.h"
> +#include <debug.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <header.h>
> +#include <session.h>
> +#include <tool.h>
> +
> +#include <parse-options.h>
> +#include <parse-events.h>
> +
> +#include <thread.h>
> +#include <sort.h>
> +#include <hist.h>
> +#include <data.h>
>  #include "arch/common.h"
>  
>  #include <dlfcn.h>
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index c38d06c..422b587 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1,20 +1,20 @@
>  #include "builtin.h"
>  #include "perf.h"
>  
> -#include "util/util.h"
> -#include "util/evlist.h"
> -#include "util/cache.h"
> -#include "util/evsel.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/header.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -
> -#include "util/parse-options.h"
> -#include "util/trace-event.h"
> -
> -#include "util/debug.h"
> +#include <util.h>
> +#include <evlist.h>
> +#include <cache.h>
> +#include <evsel.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <header.h>
> +#include <session.h>
> +#include <tool.h>
> +
> +#include <parse-options.h>
> +#include <trace-event.h>
> +
> +#include <debug.h>
>  
>  #include <sys/prctl.h>
>  #include <sys/resource.h>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 9e9c91f..5314660 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1,21 +1,21 @@
>  #include "builtin.h"
>  
>  #include "perf.h"
> -#include "util/cache.h"
> -#include "util/debug.h"
> -#include "util/exec_cmd.h"
> -#include "util/header.h"
> -#include "util/parse-options.h"
> -#include "util/session.h"
> -#include "util/tool.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/trace-event.h"
> -#include "util/util.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/sort.h"
> -#include "util/data.h"
> +#include <cache.h>
> +#include <debug.h>
> +#include <exec_cmd.h>
> +#include <header.h>
> +#include <parse-options.h>
> +#include <session.h>
> +#include <tool.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <trace-event.h>
> +#include <util.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <sort.h>
> +#include <data.h>
>  #include <linux/bitmap.h>
>  
>  static char const		*script_name;
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 65a151e..cb6d6b0 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -43,20 +43,20 @@
>  
>  #include "perf.h"
>  #include "builtin.h"
> -#include "util/util.h"
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -#include "util/pmu.h"
> -#include "util/event.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/debug.h"
> -#include "util/color.h"
> -#include "util/stat.h"
> -#include "util/header.h"
> -#include "util/cpumap.h"
> -#include "util/thread.h"
> -#include "util/thread_map.h"
> +#include <util.h>
> +#include <parse-options.h>
> +#include <parse-events.h>
> +#include <pmu.h>
> +#include <event.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <debug.h>
> +#include <color.h>
> +#include <stat.h>
> +#include <header.h>
> +#include <cpumap.h>
> +#include <thread.h>
> +#include <thread_map.h>
>  
>  #include <stdlib.h>
>  #include <sys/prctl.h>
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index 74db256..3a4e2c4 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -16,27 +16,27 @@
>  
>  #include "builtin.h"
>  
> -#include "util/util.h"
> +#include <util.h>
>  
> -#include "util/color.h"
> +#include <color.h>
>  #include <linux/list.h>
> -#include "util/cache.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> +#include <cache.h>
> +#include <evlist.h>
> +#include <evsel.h>
>  #include <linux/rbtree.h>
> -#include "util/symbol.h"
> -#include "util/callchain.h"
> -#include "util/strlist.h"
> +#include <symbol.h>
> +#include <callchain.h>
> +#include <strlist.h>
>  
>  #include "perf.h"
> -#include "util/header.h"
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -#include "util/event.h"
> -#include "util/session.h"
> -#include "util/svghelper.h"
> -#include "util/tool.h"
> -#include "util/data.h"
> +#include <header.h>
> +#include <parse-options.h>
> +#include <parse-events.h>
> +#include <event.h>
> +#include <session.h>
> +#include <svghelper.h>
> +#include <tool.h>
> +#include <data.h>
>  
>  #define SUPPORT_OLD_POWER_EVENTS 1
>  #define PWR_EVENT_EXIT -1
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 377971d..3930a1a 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -21,28 +21,28 @@
>  
>  #include "perf.h"
>  
> -#include "util/annotate.h"
> -#include "util/cache.h"
> -#include "util/color.h"
> -#include "util/evlist.h"
> -#include "util/evsel.h"
> -#include "util/machine.h"
> -#include "util/session.h"
> -#include "util/symbol.h"
> -#include "util/thread.h"
> -#include "util/thread_map.h"
> -#include "util/top.h"
> -#include "util/util.h"
> +#include <annotate.h>
> +#include <cache.h>
> +#include <color.h>
> +#include <evlist.h>
> +#include <evsel.h>
> +#include <machine.h>
> +#include <session.h>
> +#include <symbol.h>
> +#include <thread.h>
> +#include <thread_map.h>
> +#include <top.h>
> +#include <util.h>
>  #include <linux/rbtree.h>
> -#include "util/parse-options.h"
> -#include "util/parse-events.h"
> -#include "util/cpumap.h"
> -#include "util/xyarray.h"
> -#include "util/sort.h"
> -#include "util/intlist.h"
> +#include <parse-options.h>
> +#include <parse-events.h>
> +#include <cpumap.h>
> +#include <xyarray.h>
> +#include <sort.h>
> +#include <intlist.h>
>  #include "arch/common.h"
>  
> -#include "util/debug.h"
> +#include <debug.h>
>  
>  #include <assert.h>
>  #include <elf.h>
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index f954c26..cd1521d 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1,18 +1,18 @@
>  #include <traceevent/event-parse.h>
>  #include "builtin.h"
> -#include "util/color.h"
> -#include "util/debug.h"
> -#include "util/evlist.h"
> -#include "util/machine.h"
> -#include "util/session.h"
> -#include "util/thread.h"
> -#include "util/parse-options.h"
> -#include "util/strlist.h"
> -#include "util/intlist.h"
> -#include "util/thread_map.h"
> -#include "util/stat.h"
> +#include <color.h>
> +#include <debug.h>
> +#include <evlist.h>
> +#include <machine.h>
> +#include <session.h>
> +#include <thread.h>
> +#include <parse-options.h>
> +#include <strlist.h>
> +#include <intlist.h>
> +#include <thread_map.h>
> +#include <stat.h>
>  #include "trace-event.h"
> -#include "util/parse-events.h"
> +#include <parse-events.h>
>  
>  #include <libaudit.h>
>  #include <stdlib.h>
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index b210d62..754b744 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h
> @@ -1,8 +1,8 @@
>  #ifndef BUILTIN_H
>  #define BUILTIN_H
>  
> -#include "util/util.h"
> -#include "util/strbuf.h"
> +#include <util.h>
> +#include <strbuf.h>
>  
>  extern const char perf_usage_string[];
>  extern const char perf_more_info_string[];
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 729bbdf..07ae04a 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -247,7 +247,7 @@ ifeq ($(DEBUG),0)
>    endif
>  endif
>  
> -CFLAGS += -I$(src-perf)/util/include
> +CFLAGS += -I$(src-perf)/../lib/perf_util/include
>  CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
>  CFLAGS += -I$(srctree)/tools/include/
>  CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
> @@ -255,14 +255,14 @@ CFLAGS += -I$(srctree)/arch/$(ARCH)/include
>  CFLAGS += -I$(srctree)/include/uapi
>  CFLAGS += -I$(srctree)/include
>  
> -# $(obj-perf)      for generated common-cmds.h
> -# $(obj-perf)/util for generated bison/flex headers
> +# $(obj-perf)                  for generated common-cmds.h
> +# $(obj-perf)/../lib/perf_util for generated bison/flex headers
>  ifneq ($(OUTPUT),)
> -CFLAGS += -I$(obj-perf)/util
> +CFLAGS += -I$(obj-perf)/../lib/perf_util
>  CFLAGS += -I$(obj-perf)
>  endif
>  
> -CFLAGS += -I$(src-perf)/util
> +CFLAGS += -I$(src-perf)/../lib/perf_util
>  CFLAGS += -I$(src-perf)
>  CFLAGS += -I$(LIB_INCLUDE)
>  
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 431798a..a556b79 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -8,11 +8,11 @@
>   */
>  #include "builtin.h"
>  
> -#include "util/exec_cmd.h"
> -#include "util/cache.h"
> -#include "util/quote.h"
> -#include "util/run-command.h"
> -#include "util/parse-events.h"
> +#include <exec_cmd.h>
> +#include <cache.h>
> +#include <quote.h>
> +#include <run-command.h>
> +#include <parse-events.h>
>  #include <api/fs/debugfs.h>
>  #include <pthread.h>
>  
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 510c65f..94133fe 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -37,7 +37,7 @@ extern const char perf_version_string[];
>  
>  void pthread__unblock_sigwinch(void);
>  
> -#include "util/target.h"
> +#include <target.h>
>  
>  struct record_opts {
>  	struct target target;
> diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> index 8c7ea42..6456960 100644
> --- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> @@ -22,8 +22,8 @@
>  #include "EXTERN.h"
>  #include "perl.h"
>  #include "XSUB.h"
> -#include "../../../perf.h"
> -#include "../../../util/trace-event.h"
> +#include <perf.h>
> +#include <trace-event.h>
>  
>  MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
>  PROTOTYPES: ENABLE
> diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Context.c b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
> index fcd1dd6..d3a8ecd 100644
> --- a/tools/perf/scripts/python/Perf-Trace-Util/Context.c
> +++ b/tools/perf/scripts/python/Perf-Trace-Util/Context.c
> @@ -20,8 +20,8 @@
>   */
>  
>  #include <Python.h>
> -#include "../../../perf.h"
> -#include "../../../util/trace-event.h"
> +#include <perf.h>
> +#include <trace-event.h>
>  
>  PyMODINIT_FUNC initperf_trace_context(void);
>  
> diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
> index a62c091..9c3369b 100644
> --- a/tools/perf/tests/hists_common.c
> +++ b/tools/perf/tests/hists_common.c
> @@ -1,11 +1,11 @@
>  #include "perf.h"
> -#include "util/debug.h"
> -#include "util/symbol.h"
> -#include "util/sort.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/machine.h"
> -#include "util/thread.h"
> +#include <debug.h>
> +#include <symbol.h>
> +#include <sort.h>
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <machine.h>
> +#include <thread.h>
>  #include "tests/hists_common.h"
>  
>  static struct {
> diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
> index 0ac240d..bb7c555 100644
> --- a/tools/perf/tests/hists_cumulate.c
> +++ b/tools/perf/tests/hists_cumulate.c
> @@ -1,12 +1,12 @@
>  #include "perf.h"
> -#include "util/debug.h"
> -#include "util/symbol.h"
> -#include "util/sort.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/machine.h"
> -#include "util/thread.h"
> -#include "util/parse-events.h"
> +#include <debug.h>
> +#include <symbol.h>
> +#include <sort.h>
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <machine.h>
> +#include <thread.h>
> +#include <parse-events.h>
>  #include "tests/tests.h"
>  #include "tests/hists_common.h"
>  
> diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
> index 821f581..bb3f3d0 100644
> --- a/tools/perf/tests/hists_filter.c
> +++ b/tools/perf/tests/hists_filter.c
> @@ -1,12 +1,12 @@
>  #include "perf.h"
> -#include "util/debug.h"
> -#include "util/symbol.h"
> -#include "util/sort.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/machine.h"
> -#include "util/thread.h"
> -#include "util/parse-events.h"
> +#include <debug.h>
> +#include <symbol.h>
> +#include <sort.h>
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <machine.h>
> +#include <thread.h>
> +#include <parse-events.h>
>  #include "tests/tests.h"
>  #include "tests/hists_common.h"
>  
> diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
> index e3bbd6c..fd76cfa 100644
> --- a/tools/perf/tests/hists_output.c
> +++ b/tools/perf/tests/hists_output.c
> @@ -1,12 +1,12 @@
>  #include "perf.h"
> -#include "util/debug.h"
> -#include "util/symbol.h"
> -#include "util/sort.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/machine.h"
> -#include "util/thread.h"
> -#include "util/parse-events.h"
> +#include <debug.h>
> +#include <symbol.h>
> +#include <sort.h>
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <machine.h>
> +#include <thread.h>
> +#include <parse-events.h>
>  #include "tests/tests.h"
>  #include "tests/hists_common.h"
>  
> diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
> index 983d6b8..fc99514 100644
> --- a/tools/perf/tests/sw-clock.c
> +++ b/tools/perf/tests/sw-clock.c
> @@ -4,10 +4,10 @@
>  #include <sys/mman.h>
>  
>  #include "tests.h"
> -#include "util/evsel.h"
> -#include "util/evlist.h"
> -#include "util/cpumap.h"
> -#include "util/thread_map.h"
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <cpumap.h>
> +#include <thread_map.h>
>  
>  #define NR_LOOPS  10000000
>  
> diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
> index d11541d..5a6725d 100644
> --- a/tools/perf/ui/browser.c
> +++ b/tools/perf/ui/browser.c
> @@ -1,6 +1,6 @@
> -#include "../util.h"
> +#include <util.h>
>  #include "../cache.h"
> -#include "../../perf.h"
> +#include <perf.h>
>  #include "libslang.h"
>  #include "ui.h"
>  #include "util.h"
> diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
> index f0697a3..246719b 100644
> --- a/tools/perf/ui/browsers/annotate.c
> +++ b/tools/perf/ui/browsers/annotate.c
> @@ -1,14 +1,14 @@
> -#include "../../util/util.h"
> +#include <util.h>
>  #include "../browser.h"
>  #include "../helpline.h"
>  #include "../libslang.h"
>  #include "../ui.h"
>  #include "../util.h"
> -#include "../../util/annotate.h"
> -#include "../../util/hist.h"
> -#include "../../util/sort.h"
> -#include "../../util/symbol.h"
> -#include "../../util/evsel.h"
> +#include <annotate.h>
> +#include <hist.h>
> +#include <sort.h>
> +#include <symbol.h>
> +#include <evsel.h>
>  #include <pthread.h>
>  
>  struct browser_disasm_line {
> diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
> index 89c16b9..dfc7e7e 100644
> --- a/tools/perf/ui/browsers/header.c
> +++ b/tools/perf/ui/browsers/header.c
> @@ -1,11 +1,11 @@
> -#include "util/cache.h"
> -#include "util/debug.h"
> +#include <cache.h>
> +#include <debug.h>
>  #include "ui/browser.h"
>  #include "ui/ui.h"
>  #include "ui/util.h"
>  #include "ui/libslang.h"
> -#include "util/header.h"
> -#include "util/session.h"
> +#include <header.h>
> +#include <session.h>
>  
>  static void ui_browser__argv_write(struct ui_browser *browser,
>  				   void *entry, int row)
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 5905acd..1172945 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -4,12 +4,12 @@
>  #include <string.h>
>  #include <linux/rbtree.h>
>  
> -#include "../../util/evsel.h"
> -#include "../../util/evlist.h"
> -#include "../../util/hist.h"
> -#include "../../util/pstack.h"
> -#include "../../util/sort.h"
> -#include "../../util/util.h"
> +#include <evsel.h>
> +#include <evlist.h>
> +#include <hist.h>
> +#include <pstack.h>
> +#include <sort.h>
> +#include <util.h>
>  #include "../../arch/common.h"
>  
>  #include "../browser.h"
> diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
> index b11639f..6970176 100644
> --- a/tools/perf/ui/browsers/map.c
> +++ b/tools/perf/ui/browsers/map.c
> @@ -4,9 +4,9 @@
>  #include <sys/ttydefaults.h>
>  #include <string.h>
>  #include <linux/bitops.h>
> -#include "../../util/util.h"
> -#include "../../util/debug.h"
> -#include "../../util/symbol.h"
> +#include <util.h>
> +#include <debug.h>
> +#include <symbol.h>
>  #include "../browser.h"
>  #include "../helpline.h"
>  #include "../keysyms.h"
> diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
> index 402d2bd..71f90db 100644
> --- a/tools/perf/ui/browsers/scripts.c
> +++ b/tools/perf/ui/browsers/scripts.c
> @@ -2,11 +2,11 @@
>  #include <inttypes.h>
>  #include <sys/ttydefaults.h>
>  #include <string.h>
> -#include "../../util/sort.h"
> -#include "../../util/util.h"
> -#include "../../util/hist.h"
> -#include "../../util/debug.h"
> -#include "../../util/symbol.h"
> +#include <sort.h>
> +#include <util.h>
> +#include <hist.h>
> +#include <debug.h>
> +#include <symbol.h>
>  #include "../browser.h"
>  #include "../helpline.h"
>  #include "../libslang.h"
> diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
> index 9c7ff8d..381714f 100644
> --- a/tools/perf/ui/gtk/annotate.c
> +++ b/tools/perf/ui/gtk/annotate.c
> @@ -1,7 +1,7 @@
>  #include "gtk.h"
> -#include "util/debug.h"
> -#include "util/annotate.h"
> -#include "util/evsel.h"
> +#include <debug.h>
> +#include <annotate.h>
> +#include <evsel.h>
>  #include "ui/helpline.h"
>  
>  
> diff --git a/tools/perf/ui/gtk/helpline.c b/tools/perf/ui/gtk/helpline.c
> index 3388cbd..c9cfe8b 100644
> --- a/tools/perf/ui/gtk/helpline.c
> +++ b/tools/perf/ui/gtk/helpline.c
> @@ -4,7 +4,7 @@
>  #include "gtk.h"
>  #include "../ui.h"
>  #include "../helpline.h"
> -#include "../../util/debug.h"
> +#include <debug.h>
>  
>  static void gtk_helpline_pop(void)
>  {
> diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
> index 1d57676..e2aacd2 100644
> --- a/tools/perf/ui/gtk/setup.c
> +++ b/tools/perf/ui/gtk/setup.c
> @@ -1,6 +1,6 @@
>  #include "gtk.h"
> -#include "../../util/cache.h"
> -#include "../../util/debug.h"
> +#include <cache.h>
> +#include <debug.h>
>  
>  extern struct perf_error_ops perf_gtk_eops;
>  
> diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
> index 52e7fc4..708cea8 100644
> --- a/tools/perf/ui/gtk/util.c
> +++ b/tools/perf/ui/gtk/util.c
> @@ -1,5 +1,5 @@
>  #include "../util.h"
> -#include "../../util/debug.h"
> +#include <debug.h>
>  #include "gtk.h"
>  
>  #include <string.h>
> diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
> index 46181f4..ddb8442 100644
> --- a/tools/perf/ui/helpline.h
> +++ b/tools/perf/ui/helpline.h
> @@ -4,7 +4,7 @@
>  #include <stdio.h>
>  #include <stdarg.h>
>  
> -#include "../util/cache.h"
> +#include <cache.h>
>  
>  struct ui_helpline {
>  	void (*pop)(void);
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index 498adb2..603c52e 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -1,10 +1,10 @@
>  #include <math.h>
>  #include <linux/compiler.h>
>  
> -#include "../util/hist.h"
> -#include "../util/util.h"
> -#include "../util/sort.h"
> -#include "../util/evsel.h"
> +#include <hist.h>
> +#include <util.h>
> +#include <sort.h>
> +#include <evsel.h>
>  
>  /* hist period print (hpp) functions */
>  
> diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
> index ba51fa8..0dd2a83 100644
> --- a/tools/perf/ui/setup.c
> +++ b/tools/perf/ui/setup.c
> @@ -1,9 +1,9 @@
>  #include <pthread.h>
>  #include <dlfcn.h>
>  
> -#include "../util/cache.h"
> -#include "../util/debug.h"
> -#include "../util/hist.h"
> +#include <cache.h>
> +#include <debug.h>
> +#include <hist.h>
>  
>  pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
>  void *perf_gtk_handle;
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 90122ab..bda3438 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -1,9 +1,9 @@
>  #include <stdio.h>
>  
> -#include "../../util/util.h"
> -#include "../../util/hist.h"
> -#include "../../util/sort.h"
> -#include "../../util/evsel.h"
> +#include <util.h>
> +#include <hist.h>
> +#include <sort.h>
> +#include <evsel.h>
>  
>  
>  static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
> diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
> index 1c8b9af..217b137 100644
> --- a/tools/perf/ui/tui/helpline.c
> +++ b/tools/perf/ui/tui/helpline.c
> @@ -3,7 +3,7 @@
>  #include <string.h>
>  #include <pthread.h>
>  
> -#include "../../util/debug.h"
> +#include <debug.h>
>  #include "../helpline.h"
>  #include "../ui.h"
>  #include "../libslang.h"
> diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
> index 2f61256..516d65e 100644
> --- a/tools/perf/ui/tui/setup.c
> +++ b/tools/perf/ui/tui/setup.c
> @@ -1,8 +1,8 @@
>  #include <signal.h>
>  #include <stdbool.h>
>  
> -#include "../../util/cache.h"
> -#include "../../util/debug.h"
> +#include <cache.h>
> +#include <debug.h>
>  #include "../browser.h"
>  #include "../helpline.h"
>  #include "../ui.h"
> diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
> index bf890f7..de39ec9 100644
> --- a/tools/perf/ui/tui/util.c
> +++ b/tools/perf/ui/tui/util.c
> @@ -1,11 +1,11 @@
> -#include "../../util/util.h"
> +#include <util.h>
>  #include <signal.h>
>  #include <stdbool.h>
>  #include <string.h>
>  #include <sys/ttydefaults.h>
>  
> -#include "../../util/cache.h"
> -#include "../../util/debug.h"
> +#include <cache.h>
> +#include <debug.h>
>  #include "../browser.h"
>  #include "../keysyms.h"
>  #include "../helpline.h"
> diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
> index e3e0a96..1ca4c69 100644
> --- a/tools/perf/ui/util.c
> +++ b/tools/perf/ui/util.c
> @@ -1,5 +1,5 @@
>  #include "util.h"
> -#include "../debug.h"
> +#include <debug.h>
>  
>  
>  /*
> -- 
> 1.9.3
