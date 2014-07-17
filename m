Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbaGQQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:52253 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965082AbaGQQNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:42 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/33] perf tools: Fix missing kernel map load
Date: Thu, 17 Jul 2014 13:12:13 -0300
Message-Id: <1405613555-23380-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

thread__find_addr_map() falls back to trying the kernel maps if the
address is negative and is not found in userspace maps.  As commented in
the code, the kernel maps must be "loaded" before use.  This patch
ensures that happens under the fallback condition also.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 198c4cc313a1..7e0e8ae568ec 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -788,6 +788,7 @@ try_again:
 		    cpumode == PERF_RECORD_MISC_USER &&
 		    machine && mg != &machine->kmaps) {
 			mg = &machine->kmaps;
+			load_map = true;
 			goto try_again;
 		}
 	} else {
-- 
1.9.3

