Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab3BFWNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:13:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab3BFWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:13:10 -0500
Date: Wed, 6 Feb 2013 14:12:50 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-89bb67ff935d461544fed87174bb13dcc4bac673@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1359971803-2343-2-git-send-email-jolsa@redhat.com>
References: <1359971803-2343-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix perf_evsel::exclude_GH handling
Git-Commit-ID: 89bb67ff935d461544fed87174bb13dcc4bac673
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:12:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89bb67ff935d461544fed87174bb13dcc4bac673
Gitweb:     http://git.kernel.org/tip/89bb67ff935d461544fed87174bb13dcc4bac673
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 4 Feb 2013 10:56:42 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:27 -0300

perf tools: Fix perf_evsel::exclude_GH handling

Let the perf_evsel::exclude_GH only prevent the reset of exclude_host
and exclude_guest attributes in case they were already set.

We cannot reset their values to 0, because they might have other
defaults set by event_attr_init.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359971803-2343-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4e0f5c2..c84f48c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -699,14 +699,6 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
 
-	/*
-	 * We are here for group and 'GH' was not set as event
-	 * modifier and whatever event/group modifier override
-	 * default 'GH' setup.
-	 */
-	if (evsel && !exclude_GH)
-		eH = eG = 0;
-
 	memset(mod, 0, sizeof(*mod));
 
 	while (*str) {
