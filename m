Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3AXUfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:35:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3AXUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 69/74] perf script: Don't display trace info when invoking scripts
Date: Thu, 24 Jan 2013 17:08:18 -0300
Message-Id: <1359058103-31645-70-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Only display the trace info if using the default event display.  When
invoking scripts we assume they have complete control of what's
displayed so we shouldn't unconditionally display the trace info, and
when generating scripts we don't expect to see trace info obscuring the
output message.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/12ec084ef2870178915c907d16cd1dfa19fbb39e.1358527965.git.tom.zanussi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fee4c9a..92d4658 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1475,7 +1475,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 	}
 
-	perf_session__fprintf_info(session, stdout, show_full_info);
+	if (!script_name && !generate_script_lang)
+		perf_session__fprintf_info(session, stdout, show_full_info);
 
 	if (!no_callchain)
 		symbol_conf.use_callchain = true;
-- 
1.8.1.1.361.gec3ae6e

