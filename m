Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3BOQmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:42:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3BOQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:42:03 -0500
Date: Fri, 15 Feb 2013 08:39:16 -0800
From: tip-bot for Vinson Lee <vlee@twitter.com>
Message-ID: <tip-85df3b3769222894e9692b383c7af124b7721086@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, penberg@kernel.org,
        namhyung@gmail.com, jolsa@redhat.com, tglx@linutronix.de,
        vlee@twitter.com, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        namhyung@gmail.com, jolsa@redhat.com, tglx@linutronix.de,
        lizefan@huawei.com, vlee@twitter.com
In-Reply-To: <1360792138-29186-1-git-send-email-vlee@twitter.com>
References: <1360792138-29186-1-git-send-email-vlee@twitter.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build with bison 2.3 and older.
Git-Commit-ID: 85df3b3769222894e9692b383c7af124b7721086
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:39:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85df3b3769222894e9692b383c7af124b7721086
Gitweb:     http://git.kernel.org/tip/85df3b3769222894e9692b383c7af124b7721086
Author:     Vinson Lee <vlee@twitter.com>
AuthorDate: Wed, 13 Feb 2013 13:48:58 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 16:12:34 -0300

perf tools: Fix build with bison 2.3 and older.

The %name-prefix "prefix" syntax is not available on bison 2.3 and
older. Substitute with the -p "prefix" command-line option for
compatibility with older versions of bison.

This patch fixes this build error with older versions of bison.

    CC util/sysfs.o
    BISON util/pmu-bison.c
util/pmu.y:2.14-24: syntax error, unexpected string, expecting =
make: *** [util/pmu-bison.c] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Tested-by: Li Zefan <lizefan@huawei.com>
Cc: stable@vger.kernel.org # 3.4+
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1360792138-29186-1-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            | 4 ++--
 tools/perf/util/parse-events.y | 1 -
 tools/perf/util/pmu.y          | 1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b90528d..a2108ca 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -296,13 +296,13 @@ $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-event
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
 
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
 $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4de2fdc..afc44c1 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,5 +1,4 @@
 %pure-parser
-%name-prefix "parse_events_"
 %parse-param {void *_data}
 %parse-param {void *scanner}
 %lex-param {void* scanner}
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index ec89804..bfd7e85 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -1,5 +1,4 @@
 
-%name-prefix "perf_pmu_"
 %parse-param {struct list_head *format}
 %parse-param {char *name}
 
