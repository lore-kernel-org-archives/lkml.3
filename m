Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465Ab3DIRWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:22:44 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:34941
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934666Ab3DIRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:22:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML008Q-01-1UE-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/5] perf tools: Add breakpoint address mask test case to tests/parse-events
Date: Tue, 9 Apr 2013 12:21:53 -0500
Message-ID: <1365528113-5458-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
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
 tools/perf/tests/parse-events.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 88e2f44..1ade502 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -372,6 +372,32 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_breakpoint_rw(evlist);
 }
 
+static int test__checkevent_breakpoint_rw_addrmsk(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong bp_addr_mask",
+			0 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
+static int test__checkevent_breakpoint_x_addrmsk_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:x:0:k"));
+	TEST_ASSERT_VAL("wrong bp_addr_mask",
+			0 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -1187,6 +1213,14 @@ static struct evlist_test test__events[] = {
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
 	},
+	[38] = {
+		.name  = "mem:0:rw:0",
+		.check = test__checkevent_breakpoint_rw_addrmsk,
+	},
+	[39] = {
+		.name  = "mem:0:x:0:k",
+		.check = test__checkevent_breakpoint_x_addrmsk_modifier,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.7.9.5


