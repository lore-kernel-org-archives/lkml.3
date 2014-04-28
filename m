Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaD1JDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbaD1JDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:03:06 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Use LDFLAGS instead of ALL_LDFLAGS
Date: Mon, 28 Apr 2014 11:02:50 +0200
Message-Id: <1398675770-3109-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer use ALL_LDFLAGS, Replacing with LDFLAGS.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

