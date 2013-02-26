Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3BZFC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:02:28 -0500
Received: from ozlabs.org ([203.10.76.45]:51792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3BZFCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:02:25 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: acme@infradead.org
Cc: <linux-kernel@vger.kernel.org>, feng.tang@intel.com, namhyung.kim@lge.com,
        namhyung@kernel.org
Subject: [PATCH 2/2] perf report: Fix build with NO_NEWT=1
Date: Tue, 26 Feb 2013 16:02:03 +1100
Message-Id: <1361854923-1814-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/hist.h |    1 +
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
1.7.10.4

