Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBEOwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:52:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55351 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaBEOwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:52:01 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 0/3] perf-tool: Move last fs* bits
Date: Wed,  5 Feb 2014 15:51:51 +0100
Message-Id: <1391611914-26054-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

One dangling patch fs* patch and two headers, one going to /dev/null
even.

Please apply.

Borislav Petkov (3):
  perf: Move fs.* to lib/api/fs/
  perf: Move hash.h header
  perf: Drop prefetch.h

 tools/include/linux/hash.h                                 |  5 +++++
 tools/lib/api/Makefile                                     |  2 ++
 tools/{perf/util => lib/api/fs}/fs.c                       | 11 ++++++++---
 tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} | 12 +++++-------
 tools/perf/MANIFEST                                        |  2 +-
 tools/perf/Makefile.perf                                   |  6 +-----
 tools/perf/tests/parse-events.c                            |  2 +-
 tools/perf/util/cpumap.c                                   |  2 +-
 tools/perf/util/fs.h                                       |  7 -------
 tools/perf/util/include/linux/hash.h                       |  5 -----
 tools/perf/util/include/linux/list.h                       |  1 -
 tools/perf/util/include/linux/prefetch.h                   |  6 ------
 tools/perf/util/pmu.c                                      |  2 +-
 tools/perf/util/python-ext-sources                         |  2 +-
 tools/perf/util/record.c                                   |  2 +-
 tools/perf/util/util.c                                     |  2 +-
 16 files changed, 28 insertions(+), 41 deletions(-)
 create mode 100644 tools/include/linux/hash.h
 rename tools/{perf/util => lib/api/fs}/fs.c (91%)
 rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
 delete mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/include/linux/hash.h
 delete mode 100644 tools/perf/util/include/linux/prefetch.h

-- 
1.8.5.2.192.g7794a68

