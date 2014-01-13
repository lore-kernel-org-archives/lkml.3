Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAMUwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:52:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40436 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaAMUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 28/38] perf tools: Include tools/lib/api/ in MANIFEST
Date: Mon, 13 Jan 2014 17:47:29 -0300
Message-Id: <1389646059-24881-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 4e535354f162..f41572d0dd76 100644
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
-- 
1.8.1.4

