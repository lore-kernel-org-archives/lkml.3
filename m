Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbbAXSPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:15:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875AbbAXSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:50 -0500
Message-Id: <20150124181330.195149364@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 0/5] perf: Have perf become tracefs aware
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I'm trying to move the tracing directory from debugfs, perf needs to
be aware of this as system admins will now be able to mount the tracing
directory without needing to mount debugfs. This patch series addresses
this and makes perf aware of tracefs.

I based this series on a recent tip branch: perf/core.

You can also get this series from my repo as stated below.


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 1a334ac9034ceefc1c87e4cd95c6e103ba29df44


Steven Rostedt (Red Hat) (5):
      tools lib fs: Add helper to find mounted file systems
      tools lib api fs: Add tracefs mount helper functions
      tools lib api fs: Add DEBUGFS_DEFAULT_PATH macro
      tools lib api fs: Add {tracefs,debugfs}_configured() functions
      perf: Make perf aware of tracefs

----
 tools/lib/api/Makefile                   |  4 ++
 tools/lib/api/fs/debugfs.c               | 68 ++++++++++----------------
 tools/lib/api/fs/debugfs.h               |  1 +
 tools/lib/api/fs/findfs.c                | 63 ++++++++++++++++++++++++
 tools/lib/api/fs/findfs.h                | 10 ++++
 tools/lib/api/fs/tracefs.c               | 84 ++++++++++++++++++++++++++++++++
 tools/lib/api/fs/tracefs.h               | 30 ++++++++++++
 tools/perf/tests/open-syscall-all-cpus.c |  7 ++-
 tools/perf/tests/open-syscall.c          |  7 ++-
 tools/perf/tests/parse-events.c          | 13 ++++-
 tools/perf/util/cache.h                  |  1 +
 tools/perf/util/evlist.c                 |  7 +--
 tools/perf/util/parse-events.c           | 15 ++++--
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/probe-event.c            | 24 ++++++---
 tools/perf/util/util.c                   | 60 ++++++++++++++++++-----
 tools/perf/util/util.h                   |  1 +
 17 files changed, 323 insertions(+), 74 deletions(-)
