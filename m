Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaDNOTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbaDNOSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Richard Yao <ryao@gentoo.org>, Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        William Cohen <wcohen@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [GIT PULL v3 00/17] perf/core fixes
Date: Mon, 14 Apr 2014 16:17:24 +0200
Message-Id: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling.

As requested, sending only fixies for 3.15. I'll send the rest for 3.16.

thanks,
jirka


The following changes since commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-19 08:05:47 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to c12702d9bf3485d1b34c7913430b4e9271126561:

  perf tools: Instead of redirecting flex output, use -o (2014-04-14 13:00:46 +0200)

----------------------------------------------------------------
perf/core fixes:

Documentation:

. Fix documentation of invalid 'perf top -s' option (Namhyung Kim)

. Change e-mail to kernel.org one in MAINTAINERS file (Arnaldo Carvalho de Melo)

. Update bench manpage to mention numa and futex (Ramkumar Ramachandra)

Developer stuff:

. Disable unwind libraries when libelf isn't found (Arnaldo Carvalho de Melo)

. Print event name when showing libtraceevent warnings if possible (Namhyung Kim)

. Pick up libdw without explicit LIBDW_DIR (Ramkumar Ramachandra)

. Fix perf bench all segfault (Ramkumar Ramachandra)

. Set more defaults in the 'numa' suite (Ramkumar Ramachandra)

. Fix double free in perf test 21 (Adrian Hunter)

. Initialize statistics correctly (Andi Kleen)

. Instead of redirecting flex output, use -o (Cody P Schafer)

User visible:

. Assorted perf probe fixies (Namhyung Kim)

. Fix perf probe segfault (Masami Hiramatsu)

. Fix metrics calculation with event qualifiers (Andi Kleen)

. Search for modules in %s/lib/modules/%s (Richard Yao)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>

----------------------------------------------------------------
Adrian Hunter (1):
      perf tools: Fix double free in perf test 21 (code-reading.c)

Andi Kleen (2):
      perf stat: Initialize statistics correctly
      perf tools: Fix metrics calculation with event qualifiers

Arnaldo Carvalho de Melo (2):
      perf callchains: Disable unwind libraries when libelf isn't found
      MAINTAINERS: Change e-mail to kernel.org one

Cody P Schafer (1):
      perf tools: Instead of redirecting flex output, use -o

Masami Hiramatsu (1):
      perf probe: Fix to handle errors in line_range searching

Namhyung Kim (5):
      perf top: Fix documentation of invalid -s option
      tools lib traceevent: Print event name when show warning if possible
      tools lib traceevent: Do not call warning() directly
      perf probe: Fix --line option behavior
      perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()

Ramkumar Ramachandra (4):
      perf tools: Pick up libdw without explicit LIBDW_DIR
      perf bench: Update manpage to mention numa and futex
      perf bench: Fix segfault at the end of an 'all' execution
      perf bench: Set more defaults in the 'numa' suite

Richard Yao (1):
      perf machine: Search for modules in %s/lib/modules/%s

 MAINTAINERS                             |   2 +-
 tools/lib/traceevent/event-parse.c      | 109 +++++++++++++++----------
 tools/perf/Documentation/perf-bench.txt |  22 +++++
 tools/perf/Documentation/perf-top.txt   |   1 -
 tools/perf/Makefile.perf                |   4 +-
 tools/perf/bench/numa.c                 |   4 +
 tools/perf/builtin-bench.c              |   2 +-
 tools/perf/builtin-stat.c               | 140 ++++++++++++++++++++------------
 tools/perf/config/Makefile              |   7 +-
 tools/perf/tests/code-reading.c         |   1 +
 tools/perf/util/machine.c               |   2 +-
 tools/perf/util/probe-finder.c          |  15 ++--
 12 files changed, 197 insertions(+), 112 deletions(-)
