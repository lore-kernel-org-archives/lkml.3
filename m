Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3HLIRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:17:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49852 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3HLIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:17:32 -0400
Date: Mon, 12 Aug 2013 10:17:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jiri Olsa <jolsa@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Thiago Peixoto <thiagolcpeixoto@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/47] perf/core improvements and fixes
Message-ID: <20130812081726.GB2448@gmail.com>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 93786a5f6aeb9c032c1c240246c5aabcf457b38f:
> 
>   watchdog: Make it work under full dynticks (2013-07-30 22:29:15 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to cecb977e24da1465cdb0ff2d10d22e5891dc3e6c:
> 
>   Revert "tools lib lk: Fix for cross build" (2013-08-07 17:35:41 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Do annotation using /proc/kcore and /proc/kallsyms, removing the
>   need for a vmlinux file kernel assembly annotation. This also improves
>   this use case because vmlinux has just the initial kernel image, not
>   what is actually in use after various code patchings by things like
>   alternatives, etc. From Adrian Hunter.
> 
> . Various improvements and fixes to the "vmlinux matches kallsyms" 'perf test'
>   entry, related to the /proc/kcore annotation feature.
> 
> . Add --initial-delay option to 'perf stat' to skip measuring for
>   the startup phase, from Andi Kleen.
> 
> . perf kvm stat live mode, that combines aspects of 'perf kvm stat' record and
>   report, from David Ahern.
> 
> . Add option to analyze specific VM in perf kvm stat report, from David Ahern.
> 
> . Do not require /lib/modules/* on a guest, fix from Jason Wessel.
> 
> . Group leader sampling, that allows just one event in a group to sample while
>   the other events have just its values read, from Jiri Olsa.
> 
> . Add support for a new modifier "D", which requests that the event, or group
>   of events, be pinned to the PMU, from Michael Ellerman.
> 
> . Fix segmentation fault on the gtk browser, from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (13):
>       perf symbols: avoid SyS kernel syscall aliases
>       perf tests: Add test for reading object code
>       perf symbols: Load kernel maps before using
>       perf tools: Make it possible to read object code from vmlinux
>       perf tests: Adjust the vmlinux symtab matches kallsyms test
>       perf tools: Make it possible to read object code from kernel modules
>       perf symbols: Add support for reading from /proc/kcore
>       perf tests: Adjust the vmlinux symtab matches kallsyms test again
>       perf tests: Add kcore to the object code reading test
>       perf annotate: Allow disassembly using /proc/kcore
>       perf annotate: Put dso name in symbol annotation title
>       perf annotate: Remove nop at end of annotation
>       perf annotate: Add call target name if it is missing
> 
> Andi Kleen (4):
>       perf evlist: Remove obsolete dummy execve
>       perf evsel: Add support for enabling counters
>       perf stat: Add support for --initial-delay option
>       perf stat: Flush output after each line in interval mode
> 
> Arnaldo Carvalho de Melo (3):
>       perf trace: Beautify 'connect' result
>       perf python: Remove duplicate TID bit from mask
>       perf annotate browser: Improve description of '?' hotkey
> 
> David Ahern (10):
>       perf evsel: Actually show symbol offset in stack trace when requested
>       perf tools: Fix compile of util/tsc.c
>       perf top: move CONSOLE_CLEAR to header file
>       perf stats: Add max and min stats
>       perf session: Export a few functions for event processing
>       perf kvm: Split out tracepoints from record args
>       perf session: Export queue_event function
>       perf kvm: Add live mode
>       perf kvm: Add min and max stats to display
>       perf kvm stat report: Add option to analyze specific VM
> 
> Ingo Molnar (1):
>       perf annotate browser: Fix typo
> 
> Jason Wessel (1):
>       perf machine: Do not require /lib/modules/* on a guest
> 
> Jiri Olsa (10):
>       perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
>       perf: Do not get values from disabled counters in group format read
>       perf evlist: Use PERF_EVENT_IOC_ID perf ioctl to read event id
>       perf tools: Add support for parsing PERF_SAMPLE_READ sample type
>       perf evlist: Fix event ID retrieval for group format read case
>       perf evlist: Add perf_evlist__id2sid method to get event ID related data
>       perf evsel: Add PERF_SAMPLE_READ sample related processing
>       perf tools: Add 'S' event/group modifier to read sample value
>       perf tests: Add attr record group sampling test
>       perf tests: Add parse events tests for leader sampling
> 
> Joonsoo Kim (1):
>       Revert "tools lib lk: Fix for cross build"
> 
> Michael Ellerman (2):
>       perf tools: Add support for pinned modifier
>       perf tests: Add tests of new pinned modifier
> 
> Namhyung Kim (2):
>       perf util: Add parse_nsec_time() function
>       perf ui/gtk: Fix segmentation fault on perf_hpp__for_each_format loop
> 
>  include/uapi/linux/perf_event.h                  |   1 +
>  kernel/events/core.c                             |  12 +-
>  tools/lib/lk/Makefile                            |  15 -
>  tools/perf/Documentation/perf-list.txt           |   2 +
>  tools/perf/Documentation/perf-stat.txt           |   5 +
>  tools/perf/Makefile                              |   1 +
>  tools/perf/arch/x86/util/tsc.c                   |   8 +-
>  tools/perf/builtin-inject.c                      |   2 +-
>  tools/perf/builtin-kvm.c                         | 732 +++++++++++++++++++++--
>  tools/perf/builtin-script.c                      |   4 +-
>  tools/perf/builtin-stat.c                        |  24 +-
>  tools/perf/builtin-top.c                         |   5 +-
>  tools/perf/builtin-trace.c                       |   1 +
>  tools/perf/python/twatch.py                      |   2 +-
>  tools/perf/tests/attr/test-record-group-sampling |  36 ++
>  tools/perf/tests/builtin-test.c                  |   4 +
>  tools/perf/tests/code-reading.c                  | 573 ++++++++++++++++++
>  tools/perf/tests/parse-events.c                  | 168 ++++++
>  tools/perf/tests/tests.h                         |   1 +
>  tools/perf/tests/vmlinux-kallsyms.c              |  36 +-
>  tools/perf/ui/browsers/annotate.c                |  20 +-
>  tools/perf/ui/gtk/hists.c                        |   2 -
>  tools/perf/util/annotate.c                       |  60 +-
>  tools/perf/util/build-id.c                       |   2 +-
>  tools/perf/util/dso.c                            |  10 +-
>  tools/perf/util/dso.h                            |  17 +
>  tools/perf/util/event.c                          |  18 +-
>  tools/perf/util/event.h                          |  18 +
>  tools/perf/util/evlist.c                         |  77 ++-
>  tools/perf/util/evlist.h                         |   4 +
>  tools/perf/util/evsel.c                          |  80 ++-
>  tools/perf/util/evsel.h                          |   5 +
>  tools/perf/util/machine.c                        |  25 +-
>  tools/perf/util/map.c                            |  67 +--
>  tools/perf/util/map.h                            |  13 +
>  tools/perf/util/parse-events.c                   |  17 +-
>  tools/perf/util/parse-events.l                   |   3 +-
>  tools/perf/util/session.c                        | 123 +++-
>  tools/perf/util/session.h                        |   5 +
>  tools/perf/util/stat.c                           |   6 +
>  tools/perf/util/stat.h                           |   9 +
>  tools/perf/util/symbol-elf.c                     | 174 +++++-
>  tools/perf/util/symbol-minimal.c                 |   7 +
>  tools/perf/util/symbol.c                         | 273 ++++++++-
>  tools/perf/util/symbol.h                         |   5 +
>  tools/perf/util/thread.h                         |   2 +-
>  tools/perf/util/top.h                            |   2 +
>  tools/perf/util/unwind.c                         |   4 +-
>  tools/perf/util/util.c                           |  33 +
>  tools/perf/util/util.h                           |   2 +
>  50 files changed, 2523 insertions(+), 192 deletions(-)
>  create mode 100644 tools/perf/tests/attr/test-record-group-sampling
>  create mode 100644 tools/perf/tests/code-reading.c

Pulled, thanks a lot Arnaldo!

	Ingo
