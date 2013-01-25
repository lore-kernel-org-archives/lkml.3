Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3AYMFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:05:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3AYMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:05:17 -0500
Date: Fri, 25 Jan 2013 04:04:44 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-bp3wokafua1ecairau77jcy0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Use ARRAY_SIZE() were applicable
Git-Commit-ID: be651ed98dd362fa4151f49f917c74e9e8da88ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:04:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be651ed98dd362fa4151f49f917c74e9e8da88ac
Gitweb:     http://git.kernel.org/tip/be651ed98dd362fa4151f49f917c74e9e8da88ac
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Jan 2013 17:03:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:51 -0300

perf tests: Use ARRAY_SIZE() were applicable

We were using a homebrew equivalent, use the macro that is used
everywhere for this function.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bp3wokafua1ecairau77jcy0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/pmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index 6803ed1..12b322f 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -19,8 +19,6 @@ static struct test_format {
 	{ "krava23", "config2:28-29,38\n", },
 };
 
-#define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
-
 /* Simulated users input. */
 static struct parse_events_term test_terms[] = {
 	{
@@ -78,7 +76,6 @@ static struct parse_events_term test_terms[] = {
 		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 };
-#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events_term))
 
 /*
  * Prepare format directory data, exported by kernel
@@ -93,7 +90,7 @@ static char *test_format_dir_get(void)
 	if (!mkdtemp(dir))
 		return NULL;
 
-	for (i = 0; i < TEST_FORMATS_CNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(test_formats); i++) {
 		static char name[PATH_MAX];
 		struct test_format *format = &test_formats[i];
 		FILE *file;
@@ -130,14 +127,12 @@ static struct list_head *test_terms_list(void)
 	static LIST_HEAD(terms);
 	unsigned int i;
 
-	for (i = 0; i < TERMS_CNT; i++)
+	for (i = 0; i < ARRAY_SIZE(test_terms); i++)
 		list_add_tail(&test_terms[i].list, &terms);
 
 	return &terms;
 }
 
-#undef TERMS_CNT
-
 int test__pmu(void)
 {
 	char *format = test_format_dir_get();
