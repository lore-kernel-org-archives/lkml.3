Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3AXSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:44:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3AXSoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:44:30 -0500
Date: Thu, 24 Jan 2013 10:43:52 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-cyggwys0bz5kqdowwvfd8h72@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Fix period symbol_conf.field_sep display
Git-Commit-ID: c0d246b85fc7d42688d7a5d999ea671777caf65b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:43:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0d246b85fc7d42688d7a5d999ea671777caf65b
Gitweb:     http://git.kernel.org/tip/c0d246b85fc7d42688d7a5d999ea671777caf65b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 20 Oct 2012 22:14:10 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:05 -0300

perf hists: Fix period symbol_conf.field_sep display

Currently we don't properly display hist data with symbol_conf.field_sep
separator. We need to display either space or separator.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-cyggwys0bz5kqdowwvfd8h72@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0a5281f..6e639b5 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -472,11 +472,15 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
+		/*
+		 * If there's no field_sep, we still need
+		 * to display initial '  '.
+		 */
 		if (!sep || !first) {
 			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
 			advance_hpp(hpp, ret);
+		} else
 			first = false;
-		}
 
 		if (color && fmt->color)
 			ret = fmt->color(hpp, he);
