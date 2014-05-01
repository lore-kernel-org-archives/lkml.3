Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaEAGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:32:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEAGcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:32:17 -0400
Date: Wed, 30 Apr 2014 23:31:52 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e27a08f53d081b33c988db954008d879b2ab8b39@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1398675770-3109-1-git-send-email-jolsa@kernel.org>
References: <1398675770-3109-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use LDFLAGS instead of ALL_LDFLAGS
Git-Commit-ID: e27a08f53d081b33c988db954008d879b2ab8b39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e27a08f53d081b33c988db954008d879b2ab8b39
Gitweb:     http://git.kernel.org/tip/e27a08f53d081b33c988db954008d879b2ab8b39
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 27 Apr 2014 11:12:21 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 30 Apr 2014 16:48:39 +0200

perf tools: Use LDFLAGS instead of ALL_LDFLAGS

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
