Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaJBDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:09:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35229 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJBDI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:08:57 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/5] perf report: Set callchain_param.record_mode for future use
Date: Thu,  2 Oct 2014 12:08:51 +0900
Message-Id: <1412219335-17417-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
References: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally the callchain_param.record_mode is used only for record path.
But as it might need to prepare something for dwarf unwinding, setup
this info for perf report too.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ac145fae0521..495168e73d4a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -257,6 +257,12 @@ static int report__setup_sample_type(struct report *rep)
 		}
 	}
 
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain) {
+		if (sample_type & PERF_SAMPLE_REGS_USER)
+			callchain_param.record_mode = CALLCHAIN_DWARF;
+		else
+			callchain_param.record_mode = CALLCHAIN_FP;
+	}
 	return 0;
 }
 
-- 
2.1.0

