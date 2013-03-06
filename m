Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3CFXTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:19:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:40671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab3CFXTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:19:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="210035711"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, tools: Fix compilation without newt support
Date: Wed,  6 Mar 2013 15:19:17 -0800
Message-Id: <1362611957-4358-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1362611957-4358-1-git-send-email-andi@firstfloor.org>
References: <1362611957-4358-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix

builtin-annotate.c: In function ‘hists__find_annotations’:
builtin-annotate.c:161:4: error: duplicate case value
builtin-annotate.c:154:4: error: previously used here

and

builtin-report.c:479:15: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
builtin-report.c:479:15: note: each undeclared identifier is reported only once for each function it appears in
builtin-report.c: In function ‘cmd_report’:
builtin-report.c:823:13: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)

by changing the values of the fallback K_LEFT, K_RIGHT and adding a
dummy K_SWITCH_INPUT_DATA too

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/hist.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3862468..a8d7284 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,8 +208,9 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 	return 0;
 }
 
-#define K_LEFT -1
-#define K_RIGHT -2
+#define K_LEFT -10
+#define K_RIGHT -20
+#define K_SWITCH_INPUT_DATA -30
 #endif
 
 #ifdef GTK2_SUPPORT
-- 
1.7.7.6

