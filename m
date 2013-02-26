Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3BZFC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:02:27 -0500
Received: from ozlabs.org ([203.10.76.45]:60338 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3BZFCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:02:24 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: acme@infradead.org
Cc: <linux-kernel@vger.kernel.org>, feng.tang@intel.com, namhyung.kim@lge.com,
        namhyung@kernel.org
Subject: [PATCH 1/2] perf annotate: Fix build with NO_NEWT=1
Date: Tue, 26 Feb 2013 16:02:02 +1100
Message-Id: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/hist.h |    4 ++--
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
1.7.10.4

