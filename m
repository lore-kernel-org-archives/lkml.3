Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3CNMXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:23:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56844
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573Ab3CNMXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:23:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Feng Tang <feng.tang@intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] perf report: Fix build with NO_NEWT=1
Date: Thu, 14 Mar 2013 09:23:09 -0300
Message-Id: <1363263795-31485-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363263795-31485-1-git-send-email-acme@infradead.org>
References: <1363263795-31485-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
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
 tools/perf/util/hist.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
1.7.1

