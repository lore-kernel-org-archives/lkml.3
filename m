Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbaLLIRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:17:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaLLIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:16:58 -0500
Date: Fri, 12 Dec 2014 00:16:36 -0800
From: tip-bot for Tom Huynh <tipbot@zytor.com>
Message-ID: <tip-e641f696ebe4514efac00d1f4a485a06c8e94eea@git.kernel.org>
Cc: jolsa@kernel.org, mingo@kernel.org, acme@redhat.com,
        tom.huynh@freescale.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@redhat.com, a.p.zijlstra@chello.nl,
        kim.phillips@freescale.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, mmullins@mmlx.us
Reply-To: tom.huynh@freescale.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, mingo@redhat.com, jolsa@kernel.org,
        mingo@kernel.org, acme@redhat.com, hpa@zytor.com, mmullins@mmlx.us,
        tglx@linutronix.de, a.p.zijlstra@chello.nl, kim.phillips@freescale.com,
        paulus@samba.org
In-Reply-To: <1417541842-9747-1-git-send-email-tom.huynh@freescale.com>
References: <1417541842-9747-1-git-send-email-tom.huynh@freescale.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists browser:
  Change print format from %lu to %PRIu64
Git-Commit-ID: e641f696ebe4514efac00d1f4a485a06c8e94eea
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

Commit-ID:  e641f696ebe4514efac00d1f4a485a06c8e94eea
Gitweb:     http://git.kernel.org/tip/e641f696ebe4514efac00d1f4a485a06c8e94eea
Author:     Tom Huynh <tom.huynh@freescale.com>
AuthorDate: Tue, 2 Dec 2014 11:37:22 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:32 -0300

perf hists browser: Change print format from %lu to %PRIu64

The nr_events variable in tools/perf/ui/browsers/hists.c is of type u64,
so the print format (%lu) causes 'perf report' to show 0 event count
when running with 32-bit userspace without redirection.

This patch fixes that problem by printing nr_events as PRIu64.

Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: Matt Mullins <mmullins@mmlx.us>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1417541842-9747-1-git-send-email-tom.huynh@freescale.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 502daff..e6bb04b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1252,7 +1252,7 @@ static int hists__browser_title(struct hists *hists,
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
-			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   "Samples: %lu%c of event '%s', Event count (approx.): %" PRIu64,
 			   nr_samples, unit, ev_name, nr_events);
 
 
