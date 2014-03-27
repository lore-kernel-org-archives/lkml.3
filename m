Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbaC0XtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 19:49:24 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58390 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaC0XtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 19:49:20 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf bench: Set more defaults in the 'numa' suite
Date: Thu, 27 Mar 2014 19:50:17 -0400
Message-Id: <1395964219-22173-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently,

  $ perf bench numa mem

errors out with usage information. To make this more user-friendly, let
us provide a minimum set of default values required for a test
run. As an added bonus,

  $ perf bench all

now goes all the way to completion.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bench/numa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index d4c83c6..20697fb 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1593,6 +1593,10 @@ static void init_params(struct params *p, const char *name, int argc, const char
 	p->data_rand_walk		= true;
 	p->nr_loops			= -1;
 	p->init_random			= true;
+	p->mb_global_str		= "1";
+	p->nr_proc			= 1;
+	p->nr_threads			= 1;
+	p->nr_secs			= 5;
 }
 
 static int run_bench_numa(const char *name, const char **argv)
-- 
1.9.0.431.g014438b

