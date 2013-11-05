Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3KEOPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:15:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab3KEOPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:15:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Joe Mario <jmario@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCHv2 0/3] perf tools: Add perf_event_max_sample_rate freq check
Date: Tue,  5 Nov 2013 15:14:44 +0100
Message-Id: <1383660887-1734-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding the check for maximum allowed frequency rate
defined in perf_event_max_sample_rate.

Plus procfs mountpoint reading code. Reachable here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/max_rate

v2 changes:
  naming changes suggested by Arnaldo in patch 1/3
  patch 3/3:
    - unify freq. config code for record and top
    - add warning for default rate crossing the max

jirka   

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
---
Jiri Olsa (3):
      perf tools: Factor sysfs code into generic fs object
      perf tools: Add procfs support into fs object
      perf tools: Check maximum frequency rate for record/top

 tools/perf/Makefile.perf              |   4 ++--
 tools/perf/builtin-record.c           |  15 +-----------
 tools/perf/builtin-top.c              |  15 +-----------
 tools/perf/tests/parse-events.c       |   2 +-
 tools/perf/util/cpumap.c              |   2 +-
 tools/perf/util/evlist.h              |   1 +
 tools/perf/util/fs.c                  | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/fs.h                  |   7 ++++++
 tools/perf/util/include/linux/magic.h |   4 ++++
 tools/perf/util/pmu.c                 |   2 +-
 tools/perf/util/python-ext-sources    |   2 +-
 tools/perf/util/record.c              |  72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sysfs.c               |  60 -----------------------------------------------
 tools/perf/util/sysfs.h               |   6 -----
 14 files changed, 211 insertions(+), 100 deletions(-)
 create mode 100644 tools/perf/util/fs.c
 create mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/sysfs.c
 delete mode 100644 tools/perf/util/sysfs.h
