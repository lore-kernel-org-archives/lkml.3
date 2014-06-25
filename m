Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaFYFwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:52:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:52:28 -0400
Date: Tue, 24 Jun 2014 22:52:08 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-424e9634887842ac59c1d06d3264aaeb18853c0b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1402942467-10671-8-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-8-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench mem:
  The -o and -n options are mutually exclusive
Git-Commit-ID: 424e9634887842ac59c1d06d3264aaeb18853c0b
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

Commit-ID:  424e9634887842ac59c1d06d3264aaeb18853c0b
Gitweb:     http://git.kernel.org/tip/424e9634887842ac59c1d06d3264aaeb18853c0b
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 16 Jun 2014 11:14:25 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:16 -0300

perf bench mem: The -o and -n options are mutually exclusive

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
 
