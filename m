Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3IYSbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:31:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3IYSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:17 -0400
Date: Wed, 25 Sep 2013 11:30:51 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-384c671e33a7ddf905f2c60b433b9883f0e5a605@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1379900700-5186-4-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Add mmap2 handler
Git-Commit-ID: 384c671e33a7ddf905f2c60b433b9883f0e5a605
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:30:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  384c671e33a7ddf905f2c60b433b9883f0e5a605
Gitweb:     http://git.kernel.org/tip/384c671e33a7ddf905f2c60b433b9883f0e5a605
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 22 Sep 2013 19:44:58 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Sep 2013 14:15:51 -0300

perf trace: Add mmap2 handler

5c5e854b changed perf_event__synthesize_mmap_events to generate MMAP2
events. Since perf-trace does not have a handler for it it dies with a
segfault when trying to process files:

perf trace -i /tmp/perf.data
Segmentation fault

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fd48534..71aa3e3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1055,6 +1055,7 @@ static int trace__replay(struct trace *trace)
 
 	trace->tool.sample	  = trace__process_sample;
 	trace->tool.mmap	  = perf_event__process_mmap;
+	trace->tool.mmap2	  = perf_event__process_mmap2;
 	trace->tool.comm	  = perf_event__process_comm;
 	trace->tool.exit	  = perf_event__process_exit;
 	trace->tool.fork	  = perf_event__process_fork;
