Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3CAQkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:40:08 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45998
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab3CAQkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:40:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/15] perf/core improvements and fixes
Date: Thu, 28 Feb 2013 18:05:12 -0300
Message-Id: <1362085527-25326-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit e259514eef764a5286873618e34c560ecb6cff13:

  perf/x86/amd: Enable northbridge performance counters on AMD family 15h (2013-02-16 09:37:27 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 0e0c6670a333aa884d11799f38a435bdf4c408ed:

  perf report: Fix build with NO_NEWT=1 (2013-02-28 16:51:01 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Honor parallel jobs, fix from Borislav Petkov

. Introduce tools/lib/lk library, initially with just debugfs handling routines
  shared with tools/vm, more to come, from Borislav Petkov

. Fix handling of -C (cpus) in perf record, from Jiri Olsa

. Add perf_event_attr entries in 'perf test' to check -C handling in 'record'
  and 'stat', from Jiri Olsa.

. Check if -DFORTIFY_SOURCE=2 is allowed, fix from Marcin Slusarz.

. Fix build with NO_NEWT=1, from Michael Ellerman.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Borislav Petkov (6):
      perf tools: Remove a write-only variable in the debugfs code
      perf tools: Honor parallel jobs
      perf tools: Correct Makefile.include
      perf tools: Introduce tools/lib/lk library
      perf tools: Extract perf-specific stuff from debugfs.c
      tools/vm: Switch to liblk library

Jiri Olsa (5):
      perf tests: Make attr script verbose friendly
      perf tests: Make attr script test event cpu
      perf tests: Add attr record -C cpu test
      perf tests: Add attr stat -C cpu test
      perf record: Fix -C option

Marcin Slusarz (1):
      perf tools: check if -DFORTIFY_SOURCE=2 is allowed

Michael Ellerman (2):
      perf annotate: Fix build with NO_NEWT=1
      perf report: Fix build with NO_NEWT=1

liguang (1):
      perf tools: Sort command-list.txt alphabetically

 Makefile                              |  4 +-
 tools/Makefile                        | 16 ++++++-
 tools/lib/lk/Makefile                 | 35 +++++++++++++++
 tools/{perf/util => lib/lk}/debugfs.c | 49 ++++++++------------
 tools/lib/lk/debugfs.h                | 29 ++++++++++++
 tools/perf/MANIFEST                   |  1 +
 tools/perf/Makefile                   | 42 +++++++++++++----
 tools/perf/builtin-kvm.c              |  2 +-
 tools/perf/builtin-probe.c            |  2 +-
 tools/perf/builtin-record.c           |  6 ++-
 tools/perf/command-list.txt           | 14 +++---
 tools/perf/perf.c                     |  8 ++--
 tools/perf/tests/attr.c               |  9 +++-
 tools/perf/tests/attr.py              |  5 ++-
 tools/perf/tests/attr/base-record     |  1 +
 tools/perf/tests/attr/base-stat       |  1 +
 tools/perf/tests/attr/test-record-C0  | 13 ++++++
 tools/perf/tests/attr/test-stat-C0    |  9 ++++
 tools/perf/tests/parse-events.c       |  2 +-
 tools/perf/util/debugfs.h             | 12 -----
 tools/perf/util/evlist.c              |  2 +-
 tools/perf/util/evsel.c               |  2 +-
 tools/perf/util/hist.h                |  5 ++-
 tools/perf/util/parse-events.c        |  2 +-
 tools/perf/util/probe-event.c         |  2 +-
 tools/perf/util/python-ext-sources    |  1 -
 tools/perf/util/setup.py              |  3 +-
 tools/perf/util/trace-event-info.c    |  4 +-
 tools/perf/util/util.c                | 27 +++++++++++
 tools/perf/util/util.h                |  7 ++-
 tools/scripts/Makefile.include        |  6 ++-
 tools/vm/Makefile                     | 17 +++++--
 tools/vm/page-types.c                 | 85 +++--------------------------------
 33 files changed, 253 insertions(+), 170 deletions(-)
 create mode 100644 tools/lib/lk/Makefile
 rename tools/{perf/util => lib/lk}/debugfs.c (68%)
 create mode 100644 tools/lib/lk/debugfs.h
 create mode 100644 tools/perf/tests/attr/test-record-C0
 create mode 100644 tools/perf/tests/attr/test-stat-C0
 delete mode 100644 tools/perf/util/debugfs.h
