Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbaD3PdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759132AbaD3PdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] perf tools: Use LDFLAGS instead of ALL_LDFLAGS
Date: Wed, 30 Apr 2014 17:32:45 +0200
Message-Id: <1398871971-381-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer use ALL_LDFLAGS, Replacing with LDFLAGS.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1398675770-3109-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e969233..895edd3 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -589,7 +589,7 @@ $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
 	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
 
 $(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) -o $@ -shared $(ALL_LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
+	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-- 
1.8.3.1

