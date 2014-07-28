Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaG1I1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:27:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaG1I1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:27:32 -0400
Date: Mon, 28 Jul 2014 01:27:00 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f1dd1460a40894b00bbeacd753025e9251ec11bd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405893363-21967-2-git-send-email-jolsa@kernel.org>
References: <1405893363-21967-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Fix accounting of ordered samples queue
Git-Commit-ID: f1dd1460a40894b00bbeacd753025e9251ec11bd
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

Commit-ID:  f1dd1460a40894b00bbeacd753025e9251ec11bd
Gitweb:     http://git.kernel.org/tip/f1dd1460a40894b00bbeacd753025e9251ec11bd
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 20 Jul 2014 23:55:45 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jul 2014 16:40:47 -0300

perf session: Fix accounting of ordered samples queue

Properly account flushed samples within the ordered samples queue.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405893363-21967-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fab5838..88dfef7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -509,6 +509,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
+		os->nr_samples--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
@@ -521,8 +522,6 @@ static int flush_sample_queue(struct perf_session *s,
 			list_entry(head->prev, struct sample_queue, list);
 	}
 
-	os->nr_samples = 0;
-
 	return 0;
 }
 
