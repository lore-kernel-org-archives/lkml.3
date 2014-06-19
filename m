Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859AbaFSVOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:34238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965822AbaFSVOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:44 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/11] perf bench mem: The -o and -n options are mutually exclusive
Date: Thu, 19 Jun 2014 18:13:52 -0300
Message-Id: <1403212433-2714-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

 -o, --only-prefault   Show only the result with page faults before mem*
 -n, --no-prefault     Show only the result without page faults before mem*

Makes no sense to call together. Applies to both memset and memcpy.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1402942467-10671-8-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c | 5 +++++
 tools/perf/bench/mem-memset.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5ce71d3b72cf..e622c3e96efc 100644
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
index 9af79d2b18e5..2a65468619f0 100644
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
1.9.3

