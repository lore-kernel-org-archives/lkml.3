Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaDORbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:31:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDORbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:31:04 -0400
Date: Tue, 15 Apr 2014 10:30:44 -0700
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-c9e87a472594fd237b2d19dcbe4a3424297f0b1a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cody@linux.vnet.ibm.com, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1396652539-2416-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1396652539-2416-1-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Instead of redirecting flex output,
  use -o
Git-Commit-ID: c9e87a472594fd237b2d19dcbe4a3424297f0b1a
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

Commit-ID:  c9e87a472594fd237b2d19dcbe4a3424297f0b1a
Gitweb:     http://git.kernel.org/tip/c9e87a472594fd237b2d19dcbe4a3424297f0b1a
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Mon, 14 Apr 2014 12:47:01 +0200
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Tue, 15 Apr 2014 13:57:21 +0200

perf tools: Instead of redirecting flex output, use -o

This gives us a real filename instead of having '<stdout>' show up all
over the place when debugging.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1396652539-2416-1-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile.perf | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 50d875d..e969233 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -192,13 +192,13 @@ endif
 export PERL_PATH
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
+	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
 	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
