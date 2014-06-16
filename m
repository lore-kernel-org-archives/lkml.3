Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaFPSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:28 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:1253 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaFPSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:23 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] perf bench: sched-messaging: Plug memleak
Date: Mon, 16 Jun 2014 11:14:22 -0700
Message-Id: <1402942467-10671-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly free the thread array ('pth_tab').

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/sched-messaging.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 096ef5a..b519ba4 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -351,6 +351,8 @@ int bench_sched_messaging(int argc, const char **argv,
 		usleep(100000);
 	}
 
+	free(pth_tab);
 	print_summary();
+
 	return 0;
 }
-- 
1.8.1.4

