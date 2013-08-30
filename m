Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3H3TBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:01:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/15] perf/core improvements and fixes
Date: Fri, 30 Aug 2013 15:58:43 -0300
Message-Id: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 00e4cb1ced1b17c35465defafe86d156cbd7544e:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-08-29 12:02:34 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to f2935f3e585226b8203ec3861907e1cb16ad3d6a:

  perf trace: Handle missing HUGEPAGE defines (2013-08-30 15:43:28 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Tidy up sample parsing validation, from Adrian Hunter.

. Make events stream always parsable by adding a new sample_type bit:
  PERF_SAMPLE_IDENTIFIER, that when requested will be always aat a fixed
  position in all PERF_RECORD_ records, from Adrian Hunter.

. Add a sample parsing test, from Adrian Hunter.

. Add option to 'perf trace' to analyze events in a file versus live,
  so that one can do:

 [root@zoo ~]# perf record -a -e raw_syscalls:* sleep 1
 [ perf record: Woken up 0 times to write data ]
 [ perf record: Captured and wrote 25.150 MB perf.data (~1098836 samples) ]
 [root@zoo ~]# perf trace -i perf.data -e futex --duration 1
    17.799 ( 1.020 ms): 7127 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, ua
   113.344 (95.429 ms): 7127 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, uaddr2: 0x7fff3f6c6648, val3: 4294967
   133.778 ( 1.042 ms): 18004 futex(uaddr: 0x7fff3f6c6674, op: 393, val: 1, utime: 0x7fff3f6c6470, uaddr2: 0x7fff3f6c6648, val3: 429496
 [root@zoo ~]#

 From David Ahern.

. Honor target pid / tid options in 'perf trace' when analyzing a file,
  from David Ahern.

. Handle missing HUGEPAGE defines in the mmap beautifier in 'perf trace',
  from David Ahern.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (11):
      perf tools: change machine__findnew_thread() to set thread pid
      perf evsel: Tidy up sample parsing overflow checking
      perf callchain: Remove unnecessary validation
      perf tools: Remove references to struct ip_event
      perf: make events stream always parsable
      perf evlist: Move perf_evlist__config() to a new source file
      perf tools: Add support for PERF_SAMPLE_IDENTIFIER
      perf tools: Add missing 'abi' member to 'struct regs_dump'
      perf tools: Expand perf_event__synthesize_sample()
      perf tools: Add a function to calculate sample event size
      perf tests: Add a sample parsing test

David Ahern (4):
      perf evlist: Add tracepoint lookup by name
      perf trace: Add option to analyze events in a file versus live
      perf trace: Honor target pid / tid options when analyzing a file
      perf trace: Handle missing HUGEPAGE defines

 include/uapi/linux/perf_event.h         |  27 ++-
 kernel/events/core.c                    |  11 +-
 tools/perf/Documentation/perf-trace.txt |   4 +
 tools/perf/Makefile                     |   2 +
 tools/perf/builtin-inject.c             |   8 +-
 tools/perf/builtin-kmem.c               |   3 +-
 tools/perf/builtin-kvm.c                |   2 +-
 tools/perf/builtin-lock.c               |   3 +-
 tools/perf/builtin-mem.c                |   2 +-
 tools/perf/builtin-report.c             |   2 +-
 tools/perf/builtin-sched.c              |  20 +-
 tools/perf/builtin-script.c             |   3 +-
 tools/perf/builtin-top.c                |  11 +-
 tools/perf/builtin-trace.c              | 157 ++++++++++++-
 tools/perf/tests/builtin-test.c         |   4 +
 tools/perf/tests/code-reading.c         |   4 +-
 tools/perf/tests/hists_link.c           |  23 +-
 tools/perf/tests/mmap-basic.c           |   2 +-
 tools/perf/tests/sample-parsing.c       | 316 +++++++++++++++++++++++++
 tools/perf/tests/tests.h                |   1 +
 tools/perf/util/build-id.c              |  11 +-
 tools/perf/util/callchain.c             |   8 -
 tools/perf/util/callchain.h             |   5 -
 tools/perf/util/event.c                 |   5 +-
 tools/perf/util/event.h                 |  18 +-
 tools/perf/util/evlist.c                | 140 +++++++++--
 tools/perf/util/evlist.h                |  12 +-
 tools/perf/util/evsel.c                 | 405 ++++++++++++++++++++++++++++----
 tools/perf/util/evsel.h                 |  14 +-
 tools/perf/util/machine.c               |  22 +-
 tools/perf/util/machine.h               |   3 +-
 tools/perf/util/record.c                | 108 +++++++++
 tools/perf/util/session.c               |  32 +--
 33 files changed, 1193 insertions(+), 195 deletions(-)
 create mode 100644 tools/perf/tests/sample-parsing.c
 create mode 100644 tools/perf/util/record.c
