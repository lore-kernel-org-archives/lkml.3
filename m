Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaFDOyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaFDOyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:54:49 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Prettify the tags/TAGS/cscope targets output
Date: Wed,  4 Jun 2014 16:54:36 +0200
Message-Id: <1401893676-32205-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tags/TAGS/cscope targets to the quiet family.

  $ make tags cscope
  BUILD:   Doing 'make -j4' parallel build
  GEN      tags

  $ make cscope
  BUILD:   Doing 'make -j4' parallel build
  GEN      cscope

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 5c17739..90b3aa7 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -820,15 +820,15 @@ TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
 TAG_FILES= ../../include/uapi/linux/perf_event.h
 
 TAGS:
-	$(RM) TAGS
+	$(QUIET_GEN)$(RM) TAGS; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs etags -a $(TAG_FILES)
 
 tags:
-	$(RM) tags
+	$(QUIET_GEN)$(RM) tags; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs ctags -a $(TAG_FILES)
 
 cscope:
-	$(RM) cscope*
+	$(QUIET_GEN)$(RM) cscope*; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
 ### Detect prefix changes
-- 
1.8.3.1

