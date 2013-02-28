Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3CAQmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:42:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33723 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CAQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:39:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Feng Tang <feng.tang@intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/15] perf annotate: Fix build with NO_NEWT=1
Date: Thu, 28 Feb 2013 18:05:26 -0300
Message-Id: <1362085527-25326-15-git-send-email-acme@infradead.org>
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

Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
the build with NO_NEWT=1:

   CC builtin-annotate.o
builtin-annotate.c: In function 'hists__find_annotations':
builtin-annotate.c:161:4: error: duplicate case value
builtin-annotate.c:154:4: error: previously used here
make: *** [builtin-annotate.o] Error 1

This is because without NEWT support K_LEFT is #defined to -1 in
utils/hist.h

Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
of error values.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1361854923-1814-1-git-send-email-michael@ellerman.id.au
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3862468..609a115 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,8 +208,8 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 	return 0;
 }
 
-#define K_LEFT -1
-#define K_RIGHT -2
+#define K_LEFT  -1000
+#define K_RIGHT -2000
 #endif
 
 #ifdef GTK2_SUPPORT
-- 
1.8.1.1.361.gec3ae6e

