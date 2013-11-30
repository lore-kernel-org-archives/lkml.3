Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3K3MxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:53:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3K3MxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:20 -0500
Date: Sat, 30 Nov 2013 04:52:48 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-3bfe5f81fc8f87bf822f3da36927cfc549f3b3db@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384806771-2945-6-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Export setup_list
Git-Commit-ID: 3bfe5f81fc8f87bf822f3da36927cfc549f3b3db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:52:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bfe5f81fc8f87bf822f3da36927cfc549f3b3db
Gitweb:     http://git.kernel.org/tip/3bfe5f81fc8f87bf822f3da36927cfc549f3b3db
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 18 Nov 2013 13:32:48 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:38 -0300

perf tools: Export setup_list

Used in upcoming patches (perf sched timehist command).

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 +-
 tools/perf/util/symbol.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f55c18d..ce9ce10 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1749,7 +1749,7 @@ out_fail:
 	return -1;
 }
 
-static int setup_list(struct strlist **list, const char *list_str,
+int setup_list(struct strlist **list, const char *list_str,
 		      const char *list_name)
 {
 	if (list_str == NULL)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ad13c5d..f1031a1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -274,4 +274,7 @@ void kcore_extract__delete(struct kcore_extract *kce);
 int kcore_copy(const char *from_dir, const char *to_dir);
 int compare_proc_modules(const char *from, const char *to);
 
+int setup_list(struct strlist **list, const char *list_str,
+	       const char *list_name);
+
 #endif /* __PERF_SYMBOL */
