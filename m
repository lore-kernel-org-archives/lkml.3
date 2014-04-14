Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaDNOXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbaDNOSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/17] perf bench: Set more defaults in the 'numa' suite
Date: Mon, 14 Apr 2014 16:17:36 +0200
Message-Id: <1397485061-17215-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Currently,

  $ perf bench numa mem

errors out with usage information. To make this more user-friendly, let
us provide a minimum set of default values required for a test
run. As an added bonus,

  $ perf bench all

now goes all the way to completion.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395964219-22173-2-git-send-email-artagnon@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.8.3.1

