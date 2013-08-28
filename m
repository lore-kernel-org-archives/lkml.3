Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3H1PDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:03:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3H1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/21] perf/core improvements and fixes
Date: Wed, 28 Aug 2013 11:59:16 -0300
Message-Id: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling, another batch, more to come soon,

- Arnaldo

The following changes since commit 5ec4c599a52362896c3e7c6a31ba6145dca9c6f5:

  perf: Do not compute time values unnecessarily (2013-08-16 17:55:52 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 456da532a5fb04f8a79622df7dd49e84e04f31a8:

  tools lib traceevent: Fixup jobserver setup (2013-08-27 11:05:55 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Don't install scripting files files when perl/python support is disabled.

. Support ! in -e expressions in 'perf trace', to filter a list of syscalls.

. Add --verbose and -o/--output options to 'perf trace'.

. Introduce better formatting of syscall arguments in 'perf trace',
  including so far beautifiers for mmap, madvise, syscall return
  values.

. Fixup jobserver setup in libtraceevent makefile.

. Debug improvements from Adrian Hunter.

. Try to increase the file descriptor limits on EMFILE, from Andi Kleen.

. Remove unused force option in 'perf kvm', from David Ahern.

. Make 'perf trace' command line arguments consistent with 'perf record',
  from David Ahern.

. Fix correlation of samples coming after PERF_RECORD_EXIT event, from
  David Ahern.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (3):
      perf tools: Re-implement debug print function for linking python/perf.so
      perf tools: Add debug prints
      perf tools: Add pid to struct thread

Andi Kleen (1):
      perf tools: Try to increase the file descriptor limits on EMFILE

Arnaldo Carvalho de Melo (14):
      perf trace: Implement -o/--output filename
      perf tools: Don't install scripting files files when disabled
      perf trace: Support ! in -e expressions
      perf trace: Add --verbose option
      perf trace: Hide sys_exit messages about syscall id = -1
      perf trace: Introduce syscall arg formatters
      perf trace: Simplify sys_exit return printing
      perf trace: Allow printing syscall return values in hex
      perf trace: Add aliases to remaining syscalls of the sys_enter_newfoo
      perf trace: Allow overiding the formatting of syscall fields
      perf trace: Add beautifier for mmap prot parm
      perf trace: Add beautifier for mmap flags parm
      perf trace: Add beautifier for madvise behaviour/advice parm
      tools lib traceevent: Fixup jobserver setup

David Ahern (3):
      perf kvm: Remove force option to cmd_record
      perf trace: Make command line arguments consistent with perf-record
      perf tools: Sample after exit loses thread correlation

 tools/lib/traceevent/Makefile           |   2 +-
 tools/perf/Documentation/perf-trace.txt |  16 ++
 tools/perf/Makefile                     |   6 +-
 tools/perf/builtin-kvm.c                |   1 -
 tools/perf/builtin-trace.c              | 379 ++++++++++++++++++++++++++------
 tools/perf/util/evlist.c                |   3 +
 tools/perf/util/evsel.c                 |  93 ++++++++
 tools/perf/util/machine.c               |  50 +++--
 tools/perf/util/python.c                |  20 ++
 tools/perf/util/thread.c                |   3 +-
 tools/perf/util/thread.h                |   8 +-
 11 files changed, 488 insertions(+), 93 deletions(-)
