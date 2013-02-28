Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3CAQjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:39:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33720 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CAQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:39:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Feng Tang <feng.tang@intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/15] perf report: Fix build with NO_NEWT=1
Date: Thu, 28 Feb 2013 18:05:27 -0300
Message-Id: <1362085527-25326-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1362085527-25326-1-git-send-email-acme@infradead.org>
References: <1362085527-25326-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

Commit ad0de09 "Enable the runtime switching of perf data file" broke
the build with NO_NEWT=1:

    CC builtin-report.o
builtin-report.c: In function '__cmd_report':
builtin-report.c:479:15: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
builtin-report.c:479:15: note: each undeclared identifier is reported only once for each function it appears in
builtin-report.c: In function 'cmd_report':
builtin-report.c:823:13: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
make: *** [builtin-report.o] Error 1

Fix it by adding a dummy definition of K_SWITCH_INPUT_DATA.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1361854923-1814-2-git-send-email-michael@ellerman.id.au
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 609a115..226a4ae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -210,6 +210,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 
 #define K_LEFT  -1000
 #define K_RIGHT -2000
+#define K_SWITCH_INPUT_DATA -3000
 #endif
 
 #ifdef GTK2_SUPPORT
-- 
1.8.1.1.361.gec3ae6e

