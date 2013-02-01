Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936Ab3BAKwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:52:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3BAKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:52:31 -0500
Date: Fri, 1 Feb 2013 02:52:12 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-34b9564373a9e1d8c33d07824fae228a381d1803@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-15-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-15-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/browser:
  Trim column header string when event group enabled
Git-Commit-ID: 34b9564373a9e1d8c33d07824fae228a381d1803
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:52:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34b9564373a9e1d8c33d07824fae228a381d1803
Gitweb:     http://git.kernel.org/tip/34b9564373a9e1d8c33d07824fae228a381d1803
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:48 -0300

perf gtk/browser: Trim column header string when event group enabled

When event group feature is enabled, each column header is expanded to
match with the whole group column width.  But this is not needed for
GTK+ browser since ti usually use variable-width fonts.  So trim it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-15-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index c87a98c..caa554b 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -170,7 +170,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 		fmt->header(&hpp);
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, s,
+							    -1, ltrim(s),
 							    renderer, "markup",
 							    col_idx++, NULL);
 	}
