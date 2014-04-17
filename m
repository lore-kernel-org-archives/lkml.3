Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaDQJ5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbaDQJ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:56:55 -0400
Date: Thu, 17 Apr 2014 02:56:34 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-105eb30f18197a217695eac4ddf87526f2cba867@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1397145720-8063-7-git-send-email-namhyung@kernel.org>
References: <1397145720-8063-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/tui: Add 'F'
  hotkey to toggle percentage output
Git-Commit-ID: 105eb30f18197a217695eac4ddf87526f2cba867
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

Commit-ID:  105eb30f18197a217695eac4ddf87526f2cba867
Gitweb:     http://git.kernel.org/tip/105eb30f18197a217695eac4ddf87526f2cba867
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 10 Feb 2014 11:20:10 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:04 +0200

perf ui/tui: Add 'F' hotkey to toggle percentage output

Add 'F' hotkey to toggle relative and absolute percentage of filtered
entries.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397145720-8063-7-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ad1147..4d41698 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1389,6 +1389,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"C             Collapse all callchains\n"			\
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
+	"F             Toggle percentage of filtered entries\n"		\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1494,6 +1495,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (env->arch)
 				tui__header_window(env);
 			continue;
+		case 'F':
+			symbol_conf.filter_relative ^= 1;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
