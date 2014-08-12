Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaHLGkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:40:53 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41249 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaHLGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 07/13] perf kvm: Move call to symbol__init() after creating session
Date: Tue, 12 Aug 2014 15:40:39 +0900
Message-Id: <1407825645-24586-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7ccceadcd9f8..31f4802f908f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1072,6 +1072,8 @@ static int read_events(struct perf_kvm_stat *kvm)
 		return -EINVAL;
 	}
 
+	symbol__init();
+
 	if (!perf_session__has_traces(kvm->session, "kvm record"))
 		return -EINVAL;
 
@@ -1201,8 +1203,6 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		NULL
 	};
 
-	symbol__init();
-
 	if (argc) {
 		argc = parse_options(argc, argv,
 				     kvm_events_report_options,
-- 
2.0.0

