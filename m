Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935Ab3GSHpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:45:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934572Ab3GSHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:45:33 -0400
Date: Fri, 19 Jul 2013 00:45:03 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-0142dab01cd690f6e376f1fb4d4462beb054dfaf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1372793245-4136-5-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don'
 t free list head in parse_events__free_terms
Git-Commit-ID: 0142dab01cd690f6e376f1fb4d4462beb054dfaf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:45:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0142dab01cd690f6e376f1fb4d4462beb054dfaf
Gitweb:     http://git.kernel.org/tip/0142dab01cd690f6e376f1fb4d4462beb054dfaf
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 2 Jul 2013 13:27:23 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:14 -0300

perf tools: Don't free list head in parse_events__free_terms

Function should only be freeing the entries in the list in case of
failure, as those were allocated there, not the list_head itself.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1372793245-4136-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index ef72e98..bcf83ee 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1260,6 +1260,4 @@ void parse_events__free_terms(struct list_head *terms)
 
 	list_for_each_entry_safe(term, h, terms, list)
 		free(term);
-
-	free(terms);
 }
