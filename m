Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab3DATTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311Ab3DATTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:19:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/27] perf tools: Fix tab vs spaces issue in Makefile ifdef/endif
Date: Mon,  1 Apr 2013 21:18:25 +0200
Message-Id: <1364843930-17974-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unmatched spaces/tabs Makefile indentation could make the
Makefile fails. While the tabed line could be considered
sometimes as follow up for rule command, the mixed space
tab meses up with makefile if conditions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
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
1.7.11.7

