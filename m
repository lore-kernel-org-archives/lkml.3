Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaANQlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaANQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:38 -0500
Date: Tue, 14 Jan 2014 08:40:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-1wwjs01rt3xbyhn6kjl2gfs9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Include tools/lib/api/ in MANIFEST
Git-Commit-ID: c023f534c31f69a658fc21d619116ad12c7be464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c023f534c31f69a658fc21d619116ad12c7be464
Gitweb:     http://git.kernel.org/tip/c023f534c31f69a658fc21d619116ad12c7be464
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Jan 2014 16:25:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:26 -0300

perf tools: Include tools/lib/api/ in MANIFEST

When 553873e1df63 renamed tools/lib/lk to tools/lib/api we forgot to
do the switch in tools/perf/MANIFEST, breaking tarball building:

  [acme@ssdandy linux]$ make perf-targz-src-pkg
    TAR
  [acme@ssdandy linux]$ tar xf perf-3.13.0-rc4.tar.gz -C /tmp/tmp.OgdYyvp77p/
  [acme@ssdandy linux]$ make -C /tmp/tmp.OgdYyvp77p/perf-3.13.0-rc4/tools/perf
  make: Entering directory
  `/tmp/tmp.OgdYyvp77p/perf-3.13.0-rc4/tools/perf'
    BUILD:   Doing 'make -j8' parallel build
    FLEX     util/pmu-flex.c
    CC       util/evlist.o
    CC       util/evsel.o
  util/evsel.c:12:28: fatal error: api/fs/debugfs.h: No such file or directory compilation terminated.
  In file included from util/cache.h:5:0,
  <SNIP>

Fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1wwjs01rt3xbyhn6kjl2gfs9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 4e53535..f41572d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,7 +1,7 @@
 tools/perf
 tools/scripts
 tools/lib/traceevent
-tools/lib/lk
+tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
