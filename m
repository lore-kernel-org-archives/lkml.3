Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438Ab3E3QJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:09:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442Ab3E3QC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/66] perf tools: Fix tab vs spaces issue in Makefile ifdef/endif
Date: Thu, 30 May 2013 19:00:47 +0300
Message-Id: <1369929699-8724-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Unmatched spaces/tabs Makefile indentation could make the
Makefile fails. While the tabed line could be considered
sometimes as follow up for rule command, the mixed space
tab meses up with makefile if conditions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1366796273-4780-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b0f164b..c8fb0fd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -90,7 +90,7 @@ endif
 
 # Treat warnings as errors unless directed not to
 ifneq ($(WERROR),0)
-	CFLAGS_WERROR := -Werror
+  CFLAGS_WERROR := -Werror
 endif
 
 ifeq ("$(origin DEBUG)", "command line")
@@ -819,10 +819,10 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-        ifdef HAVE_CPLUS_DEMANGLE
+	ifdef HAVE_CPLUS_DEMANGLE
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-        else
+	else
 		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
 		ifeq ($(has_bfd),y)
-- 
1.8.1.4

