Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3AXUOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:15 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54101
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab3AXUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 65/74] perf tests: Use ARRAY_SIZE() were applicable
Date: Thu, 24 Jan 2013 17:08:14 -0300
Message-Id: <1359058103-31645-66-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.8.1.1.361.gec3ae6e

