Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3EaLqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:46:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaLq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:46:27 -0400
Date: Fri, 31 May 2013 04:46:04 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4d23322a0b8d0f40819dc02ea15a732a78b0a1c0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1355404152-16523-3-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Rename hist_entry__add_pair arguments
Git-Commit-ID: 4d23322a0b8d0f40819dc02ea15a732a78b0a1c0
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

Commit-ID:  4d23322a0b8d0f40819dc02ea15a732a78b0a1c0
Gitweb:     http://git.kernel.org/tip/4d23322a0b8d0f40819dc02ea15a732a78b0a1c0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 13 Dec 2012 14:09:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:02 +0300

perf hists: Rename hist_entry__add_pair arguments

The current logic is to attach pair to the leader hist_entry.

Arguments of hist_entry__add_pair function were placed the other way
round.. driving me crazy.

I.e. list_add_tail expects (new_node, head).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355404152-16523-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 51f1b5a..45ac84c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -117,10 +117,10 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist_entry__add_pair(struct hist_entry *he,
-					struct hist_entry *pair)
+static inline void hist_entry__add_pair(struct hist_entry *pair,
+					struct hist_entry *he)
 {
-	list_add_tail(&he->pairs.head, &pair->pairs.node);
+	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
 enum sort_mode {
