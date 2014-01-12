Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaALSgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaALSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:42 -0500
Date: Sun, 12 Jan 2014 10:36:25 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-150e465ac99ed18fb9555c16e0def7ce01913a2a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1387516278-17024-3-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Print session information only if --stdio is given
Git-Commit-ID: 150e465ac99ed18fb9555c16e0def7ce01913a2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:36:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  150e465ac99ed18fb9555c16e0def7ce01913a2a
Gitweb:     http://git.kernel.org/tip/150e465ac99ed18fb9555c16e0def7ce01913a2a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 20 Dec 2013 14:11:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Dec 2013 13:36:41 -0300

perf report: Print session information only if --stdio is given

Move those print functions under "if (use_browser == 0)" so that they
don't interfere with TUI output.

Maybe they can handle other UIs later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1387516278-17024-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0c9ec3e..bf8dd2e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -469,15 +469,17 @@ static int __cmd_report(struct report *rep)
 		desc);
 	}
 
-	if (verbose > 3)
-		perf_session__fprintf(session, stdout);
+	if (use_browser == 0) {
+		if (verbose > 3)
+			perf_session__fprintf(session, stdout);
 
-	if (verbose > 2)
-		perf_session__fprintf_dsos(session, stdout);
+		if (verbose > 2)
+			perf_session__fprintf_dsos(session, stdout);
 
-	if (dump_trace) {
-		perf_session__fprintf_nr_events(session, stdout);
-		return 0;
+		if (dump_trace) {
+			perf_session__fprintf_nr_events(session, stdout);
+			return 0;
+		}
 	}
 
 	nr_samples = 0;
