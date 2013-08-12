Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3HLKT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:19:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab3HLKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:19:44 -0400
Date: Mon, 12 Aug 2013 03:19:06 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-42ee8c61cb1b7fe7b7ad5071bfb3c609cb0620ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375473947-64285-2-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: move CONSOLE_CLEAR to header file
Git-Commit-ID: 42ee8c61cb1b7fe7b7ad5071bfb3c609cb0620ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42ee8c61cb1b7fe7b7ad5071bfb3c609cb0620ca
Gitweb:     http://git.kernel.org/tip/42ee8c61cb1b7fe7b7ad5071bfb3c609cb0620ca
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:39 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:26 -0300

perf top: move CONSOLE_CLEAR to header file

For use with kvm-live mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375473947-64285-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 2 --
 tools/perf/util/top.h    | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bbf4635..9101f7c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -238,8 +238,6 @@ out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static const char		CONSOLE_CLEAR[] = "[H[2J";
-
 static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 						     struct addr_location *al,
 						     struct perf_sample *sample)
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index df46be9..b554ffc 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -39,6 +39,8 @@ struct perf_top {
 	float		   min_percent;
 };
 
+#define CONSOLE_CLEAR "[H[2J"
+
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
 #endif /* __PERF_TOP_H */
