Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbaLKV01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:26:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:44116 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbaLKV00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:26:26 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Arjun Sreedharan <arjun024@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@intel.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Matt Mullins <mmullins@mmlx.us>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin.vincent@axis.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Huynh <tom.huynh@freescale.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/18] perf/core improvements and fixes
Date: Thu, 11 Dec 2014 18:25:48 -0300
Message-Id: <1418333166-15429-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit cfa0bd52d0ba9b852f76c7b3f1055edd5e5c7846:

  Merge tag 'perf-core-for-mingo-2' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-12-08 07:45:45 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to e09b18d4907992d3d615b215c1abf585721b2810:

  perf trace: Provide a better explanation when mmap fails (2014-12-11 18:04:10 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

- Mark events as (x86 only) in help output for 'perf kvm stat live" (Alexander Yarygin)

- Provide a better explanation when mmap fails in 'trace' (Arnaldo Carvalho de Melo)

- Add --buildid-dir option to set cache directory, i.e. use:

      $ perf --buildid-dir /path/to/dir tool --tool-options

  (Jiri Olsa)

- Fix memcpy/memset 'perf bench' output (Rabin Vicent)

- Fix 'perf test' attr tests size values to cope with machine state on
  interrupt ABI changes (Jiri Olsa)

- Fixup callchain type parameter handling error message (Kan Liang)

Infrastructure/cleanups:

- calloc/xcalloc: Fix argument order (Arjun Sreedharan)

- Move filename__read_int from tools/perf/ to tools/lib, add sysctl__read_int
  there and use it in place of ad-hoc copies (Arnaldo Carvalho de Melo)

- Use single strcmp call instead of two (Jiri Olsa)

- Remove extra debugdir variables in 'perf buildid-cache' (Jiri Olsa)

- Fix -a segfault related to kcore handling in 'perf buildid-cache' (Jiri Olsa)

- Move cpumode resolve code to add_callchain_ip (Kan Liang)

- Merge memset into memcpy 'perf bench' (Rabin Vincent)

- Change print format from %lu to %PRIu64 in the hists browser (Tom Huynh)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Alexander Yarygin (1):
      perf kvm stat live: Mark events as (x86 only) in help output

Arjun Sreedharan (1):
      calloc/xcalloc: Fix argument order

Arnaldo Carvalho de Melo (5):
      tools lib fs: Adopt filename__read_int from tools/perf/
      tools lib fs: Add sysctl__read_int helper
      perf tools: Use sysctl__read_int instead of ad-hoc copies
      perf evlist: Introduce strerror_mmap method
      perf trace: Provide a better explanation when mmap fails

Jiri Olsa (5):
      perf tools: Use single strcmp call instead of two
      perf buildid-cache: Remove extra debugdir variables
      perf buildid cache: Fix -a segfault related to kcore handling
      perf tools: Add --buildid-dir option to set cache directory
      perf tests: Fix attr tests size values to cope with machine state on interrupt ABI changes

Kan Liang (2):
      perf callchain: Fixup parameter handling error message
      perf callchain: Move cpumode resolve code to add_callchain_ip

Rabin Vincent (3):
      perf bench: Prepare memcpy for merge
      perf bench: Merge memset into memcpy
      perf bench: Fix memcpy/memset output

Tom Huynh (1):
      perf hists browser: Change print format from %lu to %PRIu64

 scripts/kconfig/mconf.c            |   4 +-
 tools/lib/api/fs/fs.c              |  34 +++++
 tools/lib/api/fs/fs.h              |   3 +
 tools/perf/Documentation/perf.txt  |   4 +
 tools/perf/Makefile.perf           |   1 -
 tools/perf/bench/mem-memcpy.c      | 286 ++++++++++++++++++++++++----------
 tools/perf/bench/mem-memset.c      | 304 -------------------------------------
 tools/perf/builtin-buildid-cache.c |  13 +-
 tools/perf/builtin-kvm.c           |   3 +-
 tools/perf/builtin-trace.c         |  12 +-
 tools/perf/perf.c                  |  14 +-
 tools/perf/tests/attr/base-record  |   2 +-
 tools/perf/tests/attr/base-stat    |   2 +-
 tools/perf/ui/browsers/hists.c     |   2 +-
 tools/perf/ui/hist.c               |   4 +-
 tools/perf/util/build-id.c         |   9 +-
 tools/perf/util/callchain.c        |   2 +-
 tools/perf/util/config.c           |  10 +-
 tools/perf/util/evlist.c           |  23 +++
 tools/perf/util/evlist.h           |   1 +
 tools/perf/util/machine.c          |  72 +++++----
 tools/perf/util/record.c           |  11 +-
 tools/perf/util/util.c             |  26 +---
 tools/perf/util/util.h             |   3 +-
 tools/thermal/tmon/sysfs.c         |   6 +-
 25 files changed, 350 insertions(+), 501 deletions(-)
 delete mode 100644 tools/perf/bench/mem-memset.c
