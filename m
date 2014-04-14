Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaDNOyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:54:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46643 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaDNOyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:54:17 -0400
Date: Mon, 14 Apr 2014 07:54:04 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-40ba93e3aa001246110320edbe8cf2eb488c1fe7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        artagnon@gmail.com, tglx@linutronix.de
In-Reply-To: <1395964219-22173-2-git-send-email-artagnon@gmail.com>
References: <1395964219-22173-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Set more defaults in the 'numa'
  suite
Git-Commit-ID: 40ba93e3aa001246110320edbe8cf2eb488c1fe7
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

Commit-ID:  40ba93e3aa001246110320edbe8cf2eb488c1fe7
Gitweb:     http://git.kernel.org/tip/40ba93e3aa001246110320edbe8cf2eb488c1fe7
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 27 Mar 2014 19:50:17 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:58 +0200

perf bench: Set more defaults in the 'numa' suite

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
