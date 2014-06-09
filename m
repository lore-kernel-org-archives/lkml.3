Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaFIUDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaFIUDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:02 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/15] perf tools: Prettify the tags/TAGS/cscope targets output
Date: Mon,  9 Jun 2014 22:02:21 +0200
Message-Id: <1402344150-14860-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
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

Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401893676-32205-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ae20edf..9670a16 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -819,15 +819,15 @@ TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
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

