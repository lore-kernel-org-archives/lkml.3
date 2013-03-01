Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3CAT4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:56:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3CATqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vinson Lee <vlee@twitter.com>, Li Zefan <lizefan@huawei.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 43/46] perf tools: Fix build with bison 2.3 and older.
Date: Fri,  1 Mar 2013 11:45:31 -0800
Message-Id: <20130301194436.775798614@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinson Lee <vlee@twitter.com>

commit 85df3b3769222894e9692b383c7af124b7721086 upstream.

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1360792138-29186-1-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile            |    4 ++--
 tools/perf/util/parse-events.y |    1 -
 tools/perf/util/pmu.y          |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -241,13 +241,13 @@ $(OUTPUT)util/parse-events-flex.c: util/
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
 
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
 $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,5 +1,4 @@
 
-%name-prefix "parse_events_"
 %parse-param {struct list_head *list_all}
 %parse-param {struct list_head *list_event}
 %parse-param {int *idx}
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -1,5 +1,4 @@
 
-%name-prefix "perf_pmu_"
 %parse-param {struct list_head *format}
 %parse-param {char *name}
 


