Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaFPSPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:39 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:24164 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaFPSPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:36 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] perf bench: mem: -o and -n options are mutually exclusive
Date: Mon, 16 Jun 2014 11:14:25 -0700
Message-Id: <1402942467-10671-8-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -o, --only-prefault   Show only the result with page faults before mem*
 -n, --no-prefault     Show only the result without page faults before mem*

Makes no sense to call together. Applies to both memset and memcpy.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/mem-memcpy.c | 5 +++++
 tools/perf/bench/mem-memset.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5ce71d3..e622c3e 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -189,6 +189,11 @@ int bench_mem_memcpy(int argc, const char **argv,
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memcpy_usage, 0);
 
+	if (no_prefault && only_prefault) {
+		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
+		return 1;
+	}
+
 	if (use_cycle)
 		init_cycle();
 
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 9af79d2..2a65468 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -181,6 +181,11 @@ int bench_mem_memset(int argc, const char **argv,
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memset_usage, 0);
 
+	if (no_prefault && only_prefault) {
+		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
+		return 1;
+	}
+
 	if (use_cycle)
 		init_cycle();
 
-- 
1.8.1.4

