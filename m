Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaG1I2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:28:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaG1I2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:28:05 -0400
Date: Mon, 28 Jul 2014 01:27:45 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-33bf7481971a622a2b8c8aaa0e5e61a6eaeecd71@git.kernel.org>
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
In-Reply-To: <1406300177-31805-18-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-18-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Always force PERF_RECORD_FINISHED_ROUND event
Git-Commit-ID: 33bf7481971a622a2b8c8aaa0e5e61a6eaeecd71
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

Commit-ID:  33bf7481971a622a2b8c8aaa0e5e61a6eaeecd71
Gitweb:     http://git.kernel.org/tip/33bf7481971a622a2b8c8aaa0e5e61a6eaeecd71
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 25 Jul 2014 16:56:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jul 2014 12:13:05 -0300

perf record: Always force PERF_RECORD_FINISHED_ROUND event

The PERF_RECORD_FINISHED_ROUND synthetic record governs queue flushing
in reporting, so it needs to be stored for any kind of event.

The lack of such periodic flushing made the tools use more memory than
needed, as the reordering was being done only after processing all
events.  This was the case when no tracepoints were in the mix.

Forcing the PERF_RECORD_FINISHED_ROUND event to be stored for all event
types.

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
Link: http://lkml.kernel.org/r/1406300177-31805-18-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..4a1a542 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -250,8 +250,7 @@ static int record__mmap_read_all(struct record *rec)
 		}
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
+	rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
 
 out:
 	return rc;
