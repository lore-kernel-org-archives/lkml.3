Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3DWH51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:57:27 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:14590
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755251Ab3DWH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:57:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLP7FA-02-409-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 4/4] perf tools: Add hardware breakpoint address mask test cases
Date: Tue, 23 Apr 2013 02:57:05 -0500
Message-ID: <1366703825-19373-5-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/tests/parse-events.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 88e2f44..f9c7666 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -372,6 +372,38 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_breakpoint_rw(evlist);
 }
 
+static int test__checkevent_breakpoint_addrmask(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong bp_addr_mask", 1 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint(evlist);
+}
+
+static int test__checkevent_breakpoint_addrmask_x(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong bp_addr_mask", 1 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
+static int
+test__checkevent_breakpoint_addrmask_rw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong bp_addr_mask", 1 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -1187,6 +1219,19 @@ static struct evlist_test test__events[] = {
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
 	},
+	[38] = {
+		.name  = "mem:0/1",
+		.check = test__checkevent_breakpoint_addrmask,
+	},
+
+	[39] = {
+		.name  = "mem:0/1:x",
+		.check = test__checkevent_breakpoint_addrmask_x,
+	},
+	[40] = {
+		.name  = "mem:0/1:rw:uk",
+		.check = test__checkevent_breakpoint_addrmask_rw_modifier,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.7.9.5


