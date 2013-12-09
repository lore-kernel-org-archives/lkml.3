Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab3LIQOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:14:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab3LIQOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:14:31 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH -v1.1 0/2] perf tool: Carve out fs.* stuff
Date: Mon,  9 Dec 2013 17:14:22 +0100
Message-Id: <1386605664-24041-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

v1 -> v1.1:

* take care of some build nuisances and review comments caught by jolsa
and David Ahern. Fixup the doc cleaning target in Makefile.perf, while
at it.

v1:

step one: carve out fs-related stuff into a libapikfs.a library.

Borislav Petkov (2):
  tools/: Convert to new topic libraries
  perf: Move fs.* to lib/api/fs/

 tools/Makefile                                     | 12 ++++----
 tools/lib/{lk => api}/Makefile                     | 20 +++++++-----
 tools/lib/{lk => api/fs}/debugfs.c                 |  0
 tools/lib/{lk => api/fs}/debugfs.h                 |  6 ++--
 tools/{perf/util => lib/api/fs}/fs.c               | 11 +++++--
 .../util/include/linux/magic.h => lib/api/fs/fs.h} | 12 +++-----
 tools/perf/Makefile.perf                           | 36 ++++++++++------------
 tools/perf/builtin-kvm.c                           |  2 +-
 tools/perf/builtin-probe.c                         |  2 +-
 tools/perf/perf.c                                  |  2 +-
 tools/perf/tests/parse-events.c                    |  4 +--
 tools/perf/util/cpumap.c                           |  2 +-
 tools/perf/util/evlist.c                           |  2 +-
 tools/perf/util/evsel.c                            |  2 +-
 tools/perf/util/fs.h                               |  7 -----
 tools/perf/util/parse-events.c                     |  2 +-
 tools/perf/util/pmu.c                              |  2 +-
 tools/perf/util/probe-event.c                      |  2 +-
 tools/perf/util/python-ext-sources                 |  2 +-
 tools/perf/util/record.c                           |  2 +-
 tools/perf/util/setup.py                           |  4 +--
 tools/perf/util/trace-event-info.c                 |  2 +-
 tools/perf/util/util.h                             |  2 +-
 tools/vm/Makefile                                  | 14 ++++-----
 tools/vm/page-types.c                              |  2 +-
 25 files changed, 76 insertions(+), 78 deletions(-)
 rename tools/lib/{lk => api}/Makefile (64%)
 rename tools/lib/{lk => api/fs}/debugfs.c (100%)
 rename tools/lib/{lk => api/fs}/debugfs.h (86%)
 rename tools/{perf/util => lib/api/fs}/fs.c (91%)
 rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
 delete mode 100644 tools/perf/util/fs.h

-- 
1.8.4

