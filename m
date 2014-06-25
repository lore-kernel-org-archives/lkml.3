Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaFYFvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaFYFvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:36 -0400
Date: Tue, 24 Jun 2014 22:51:16 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-89632972e2c56356d1e227aac151cf4e7c2f30d6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1403178076-14072-4-git-send-email-jolsa@kernel.org>
References: <1403178076-14072-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Fix scrollbar refresh row index
Git-Commit-ID: 89632972e2c56356d1e227aac151cf4e7c2f30d6
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

Commit-ID:  89632972e2c56356d1e227aac151cf4e7c2f30d6
Gitweb:     http://git.kernel.org/tip/89632972e2c56356d1e227aac151cf4e7c2f30d6
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 19 Jun 2014 13:41:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:14 -0300

perf ui browser: Fix scrollbar refresh row index

The ui_browser__gotorc function needs offset from 'y' member, so the row
index has to begin with 0, which happens by accident in current code,
because we display only one header line.

The bug shows when we want to display more than 1 header lines like
columns headers in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403178076-14072-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3ccf6e1..9d2294e 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -279,7 +279,7 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 {
 	int height = browser->height, h = 0, pct = 0,
 	    col = browser->width,
-	    row = browser->y - 1;
+	    row = 0;
 
 	if (browser->nr_entries > 1) {
 		pct = ((browser->index * (browser->height - 1)) /
