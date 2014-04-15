Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaDONHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaDONHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:07:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf tools: Instead of redirecting flex output, use -o
Date: Tue, 15 Apr 2014 15:07:06 +0200
Message-Id: <1397567226-27516-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
References: <1397567226-27516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

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
-- 
1.8.3.1

