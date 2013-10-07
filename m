Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3JGJc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3JGJcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:32:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/3] perf tools: Factor perf data handling
Date: Mon,  7 Oct 2013 11:31:38 +0200
Message-Id: <1381138301-6332-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding patches to centralize perf.data handling. New object
perf_data_file is added as a handler for perf.data file.

This cleans up perf.data handling and will become handy
for other perf.data file related changes in future, like
multiple file storage or separating storage into multiple
threads.

This patchset is extracted and rebased as generic one
from my earlier 'multiple file support' patchset:
http://marc.info/?t=137803189400001&r=1&w=2

It's reachable here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/file38

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
Jiri Olsa (3):
      perf tools: Add data object to handle perf data file
      perf tools: Add perf_data_file__open interface to data object
      perf tools: Separating data file properties from session

 tools/perf/Makefile                |   1 +
 tools/perf/builtin-annotate.c      |  11 ++++++---
 tools/perf/builtin-buildid-cache.c |   8 +++++--
 tools/perf/builtin-buildid-list.c  |  11 ++++++---
 tools/perf/builtin-diff.c          |  19 +++++++++------
 tools/perf/builtin-evlist.c        |   7 +++++-
 tools/perf/builtin-inject.c        |   7 +++++-
 tools/perf/builtin-kmem.c          |   7 +++++-
 tools/perf/builtin-kvm.c           |  13 +++++++---
 tools/perf/builtin-lock.c          |   7 +++++-
 tools/perf/builtin-mem.c           |   9 +++++--
 tools/perf/builtin-record.c        |  78 +++++++++++++++++++-----------------------------------------
 tools/perf/builtin-report.c        |  18 ++++++++++----
 tools/perf/builtin-sched.c         |   6 ++++-
 tools/perf/builtin-script.c        |  17 +++++++++----
 tools/perf/builtin-timechart.c     |  10 ++++++--
 tools/perf/builtin-top.c           |   7 ++----
 tools/perf/builtin-trace.c         |   8 ++++---
 tools/perf/perf.h                  |   1 -
 tools/perf/util/data.c             | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h             |  48 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.c           |  20 +++++++++-------
 tools/perf/util/session.c          | 125 +++++++++++++++++++++++++++++++++++-------------------------------------------------------------
 tools/perf/util/session.h          |  11 ++++-----
 24 files changed, 376 insertions(+), 193 deletions(-)
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h
