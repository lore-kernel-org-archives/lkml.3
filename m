Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaDVSeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:34:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaDVSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:34:10 -0400
Date: Tue, 22 Apr 2014 11:33:52 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-7c2f8164e5415ef48954f6929f4acae5764afdb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1397674818-27054-1-git-send-email-jolsa@redhat.com>
References: <1397674818-27054-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix pmu object compilation error
Git-Commit-ID: 7c2f8164e5415ef48954f6929f4acae5764afdb4
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

Commit-ID:  7c2f8164e5415ef48954f6929f4acae5764afdb4
Gitweb:     http://git.kernel.org/tip/7c2f8164e5415ef48954f6929f4acae5764afdb4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 16 Apr 2014 20:49:02 +0200
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Tue, 22 Apr 2014 17:39:09 +0200

perf tools: Fix pmu object compilation error

After applying some patches got another shadowing error:

  CC       util/pmu.o
util/pmu.c: In function ‘pmu_alias_terms’:
util/pmu.c:287:35: error: declaration of ‘clone’ shadows a global declaration [-Werror=shadow]

Renaming clone to cloned.

Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397674818-27054-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..7a811eb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -284,17 +284,17 @@ static int pmu_aliases(const char *name, struct list_head *head)
 static int pmu_alias_terms(struct perf_pmu_alias *alias,
 			   struct list_head *terms)
 {
-	struct parse_events_term *term, *clone;
+	struct parse_events_term *term, *cloned;
 	LIST_HEAD(list);
 	int ret;
 
 	list_for_each_entry(term, &alias->terms, list) {
-		ret = parse_events_term__clone(&clone, term);
+		ret = parse_events_term__clone(&cloned, term);
 		if (ret) {
 			parse_events__free_terms(&list);
 			return ret;
 		}
-		list_add_tail(&clone->list, &list);
+		list_add_tail(&cloned->list, &list);
 	}
 	list_splice(&list, terms);
 	return 0;
