Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaALSeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:34:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaALSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:34:14 -0500
Date: Sun, 12 Jan 2014 10:33:54 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b7248defce917acce74b338d69c2b8f600370213@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-3-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Making QUIET_(CLEAN|INSTAL)
  variables global
Git-Commit-ID: b7248defce917acce74b338d69c2b8f600370213
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:34:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7248defce917acce74b338d69c2b8f600370213
Gitweb:     http://git.kernel.org/tip/b7248defce917acce74b338d69c2b8f600370213
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:08 -0300

perf tools: Making QUIET_(CLEAN|INSTAL) variables global

Moving QUIET_(CLEAN|INSTAL) variables into:

  tools/scripts/Makefile.include

to be usable by other tools. The change to use them in libtraceevent is
in following patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak | 7 -------
 tools/scripts/Makefile.include  | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index f168deb..4d985e0 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,10 +178,3 @@ endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
-
-ifneq ($(findstring $(MAKEFLAGS),s),s)
-  ifneq ($(V),1)
-    QUIET_CLEAN		= @printf '  CLEAN    %s\n' $1;
-    QUIET_INSTALL	= @printf '  INSTALL  %s\n' $1;
-  endif
-endif
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ee76544..e4cfbed 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -76,5 +76,8 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
 		+@echo	       '  DESCEND  '$(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
+
+	QUIET_CLEAN    = @printf '  CLEAN    %s\n' $1;
+	QUIET_INSTALL  = @printf '  INSTALL  %s\n' $1;
   endif
 endif
