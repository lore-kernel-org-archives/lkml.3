Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3ARTvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:51:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:18655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3ARTvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:51:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="192745155"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 2/4] perf script: don't display trace info when invoking scripts
Date: Fri, 18 Jan 2013 13:51:26 -0600
Message-Id: <12ec084ef2870178915c907d16cd1dfa19fbb39e.1358527965.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1358527965.git.tom.zanussi@linux.intel.com>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only display the trace info if using the default event display.  When
invoking scripts we assume they have complete control of what's
displayed so we shouldn't unconditionally display the trace info, and
when generating scripts we don't expect to see trace info obscuring
the output message.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 tools/perf/builtin-script.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b363e7b..1bb305c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1487,7 +1487,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 	}
 
-	perf_session__fprintf_info(session, stdout, show_full_info);
+	if (!script_name && !generate_script_lang)
+		perf_session__fprintf_info(session, stdout, show_full_info);
 
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
-- 
1.7.11.4

