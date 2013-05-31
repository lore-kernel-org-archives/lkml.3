Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3EaLa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:30:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3EaLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:30:19 -0400
Date: Fri, 31 May 2013 04:29:20 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f9619d693a3aad365598ed5f718bd5883c7cb7f8@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        bp@alien8.de, namhyung@kernel.org, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, namhyung@kernel.org,
        mingo@elte.hu
In-Reply-To: <1366796273-4780-3-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix tab vs spaces issue in Makefile ifdef/endif
Git-Commit-ID: f9619d693a3aad365598ed5f718bd5883c7cb7f8
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

Commit-ID:  f9619d693a3aad365598ed5f718bd5883c7cb7f8
Gitweb:     http://git.kernel.org/tip/f9619d693a3aad365598ed5f718bd5883c7cb7f8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 24 Apr 2013 11:37:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:57 +0300

perf tools: Fix tab vs spaces issue in Makefile ifdef/endif

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
