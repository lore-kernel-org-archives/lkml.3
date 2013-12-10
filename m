Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LJUcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:32:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34345 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3LJUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        linaro-kernel@lists.linaro.org, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, patches@linaro.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/34] perf/core improvements and fixes
Date: Tue, 10 Dec 2013 17:31:02 -0300
Message-Id: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	The first 20 patches in this series are the same as in the previous
one, so I'm not reposting them now.

	This series has the code style/constification changes you suggested in
the symbols code and then a reworked fix to the basename problem plus some
more patches not present in the previous series.

	Please let me know if you find any further problems,

Best Regards,

- Arnaldo

The following changes since commit 6d65894bc028d0342829ea1e64c9e9efad571124:

  tools lib traceevent: Update kvm plugin with is_writable_pte helper (2013-12-04 15:38:14 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 1448fef40af6079de38380c3a81bcf9994a1037d:

  perf unwinding: Use the per-feature check flags (2013-12-10 16:51:12 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Add an option in 'perf script' to print the source line number, from Adrian Hunter

. Add --header/--header-only options to 'script' and 'report', the default is not
  tho show the header info, but as this has been the default for some time,
  leave a single line explaining how to obtain that information, from Jiri Olsa.

. Fix symoff printing in callchains in 'perf script', from Adrian Hunter.

. Assorted mmap_pages handling fixes, from Adrian Hunter.

. Fix summary percentage when processing files in 'perf trace', fom David Ahern.

. Handle old kernels where the "raw_syscalls" tracepoints were called plan "syscalls",
  in 'perf trace', from David Ahern.

. Several man pages typo fixes from Dongsheng Yang.

. Add '-v' option to 'perf kvm', from Dongsheng Yang.

. Make perf kvm diff support --guestmount, from Dongsheng Yang.

. Get rid of several die() calls in libtraceevent, from Namhyung Kim.

. Use basename() in a more robust way, to avoid problems related to different
  system library implementations for that function, from Stephane Eranian.

. Remove open coded management of short_name_allocated member, from Adrian Hunter

. Several cleanups in the "dso" methods, constifying some parameters and
  renaming some fields to clarify its purpose.

. Add per-feature check flags, fixing libunwind related build problems on some
  architectures, from Jean Pihet.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (7):
      perf script: Fix symoff printing in callchains
      perf script: Add an option to print the source line number
      perf record: Fix display of incorrect mmap pages
      perf evlist: Remove unnecessary parentheses
      perf evlist: Fix max mmap_pages
      perf evlist: Fix mmap pages rounding to power of 2
      perf symbols: Remove open coded management of  short_name_allocated member

Arnaldo Carvalho de Melo (8):
      perf symbols: Rename [sl]name_alloc to match the members they refer to
      perf machine: Don't open code assign dso->short_name
      perf symbols: Set alloc flag close to setting the long_name
      perf symbols: Remove open coded management of  long_name_allocated member
      perf symbols: Constify dso->long_name
      perf symbols: Set freed members to NULL in dso destructor
      perf symbols: Constify some DSO methods parameters
      perf symbols: Rename filename argument

David Ahern (2):
      perf trace: Add support for syscalls vs raw_syscalls
      perf trace: Fix summary percentage when processing files

Dongsheng Yang (6):
      perf kvm: Introduce option -v for perf kvm command.
      perf kvm: Fix bug in 'stat report'
      perf archive: Remove duplicated 'runs' in man page
      perf annotate: Fix typo
      perf kvm: Move code to generate filename for perf-kvm to function.
      perf kvm: Make perf kvm diff support --guestmount.

Jean Pihet (2):
      perf tools: Add per-feature check flags
      perf unwinding: Use the per-feature check flags

Jiri Olsa (2):
      perf report: Add --header/--header-only options
      perf script: Add --header/--header-only options

Namhyung Kim (5):
      tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_alloc()
      tools lib traceevent: Get rid of malloc_or_die() in add_event()
      tools lib traceevent: Get rid of die() in create_arg_item()
      tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_add_filter_str()
      tools lib traceevent: Get rid of die() in pevent_filter_clear_trivial()

Stephane Eranian (1):
      perf symbols: Fix bug in usage of the basename() function

Steven Rostedt (1):
      tools lib traceevent: Report better error message on bad function args

 tools/lib/traceevent/event-parse.c        |  28 +++++---
 tools/lib/traceevent/event-parse.h        |   2 +-
 tools/lib/traceevent/parse-filter.c       |  57 +++++++++++----
 tools/perf/Documentation/perf-archive.txt |   6 +-
 tools/perf/Documentation/perf-kvm.txt     |   7 +-
 tools/perf/Documentation/perf-report.txt  |   9 +++
 tools/perf/Documentation/perf-script.txt  |   8 ++-
 tools/perf/builtin-annotate.c             |   2 +-
 tools/perf/builtin-diff.c                 |   3 +-
 tools/perf/builtin-kvm.c                  |  11 ++-
 tools/perf/builtin-record.c               |   2 +-
 tools/perf/builtin-report.c               |  22 +++++-
 tools/perf/builtin-script.c               |  23 +++++-
 tools/perf/builtin-trace.c                |  32 ++++++++-
 tools/perf/config/Makefile                |  52 ++++++++------
 tools/perf/config/feature-checks/Makefile |   8 +--
 tools/perf/util/annotate.c                |   2 +-
 tools/perf/util/build-id.c                |   2 +-
 tools/perf/util/build-id.h                |   2 +-
 tools/perf/util/dso.c                     | 112 ++++++++++++++++++++----------
 tools/perf/util/dso.h                     |  16 ++---
 tools/perf/util/evlist.c                  |  10 +--
 tools/perf/util/header.c                  |   6 +-
 tools/perf/util/machine.c                 |   6 +-
 tools/perf/util/map.c                     |  17 +++++
 tools/perf/util/map.h                     |   2 +
 tools/perf/util/probe-event.c             |   2 +-
 tools/perf/util/session.c                 |  15 +++-
 tools/perf/util/session.h                 |   1 +
 tools/perf/util/srcline.c                 |   2 +-
 tools/perf/util/symbol.c                  |  38 ++++------
 tools/perf/util/symbol.h                  |   3 +-
 tools/perf/util/util.c                    |  14 ++++
 tools/perf/util/util.h                    |  14 ++++
 tools/perf/util/vdso.c                    |   2 +-
 35 files changed, 375 insertions(+), 163 deletions(-)
