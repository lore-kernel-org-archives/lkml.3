Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab3HOH56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3HOH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:57:54 -0400
Date: Thu, 15 Aug 2013 00:57:41 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-309b5185047c5309bbc576025f6c5e257edd9f69@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1376454732-83728-1-git-send-email-dsahern@gmail.com>
References: <1376454732-83728-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Fix compile failure on do_sort_something
Git-Commit-ID: 309b5185047c5309bbc576025f6c5e257edd9f69
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:57:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  309b5185047c5309bbc576025f6c5e257edd9f69
Gitweb:     http://git.kernel.org/tip/309b5185047c5309bbc576025f6c5e257edd9f69
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 13 Aug 2013 22:32:12 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Aug 2013 11:42:45 -0300

perf tests: Fix compile failure on do_sort_something

Commit b55ae0a9 added code-reading.c which fails to compile on Fedora 16
with compiler version:
$ gcc --version
gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)

Failure message is:

tests/code-reading.c: In function ‘do_sort_something’:
tests/code-reading.c:305:13: error: stack protector not protecting local variables: variable length buffer [-Werror=stack-protector]
cc1: all warnings being treated as errors
make: *** [/tmp/junk/tests/code-reading.o] Error 1
make: *** Waiting for unfinished jobs....

v2: as Adrian noticed changed sizeof to ARRAY_SIZE

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1376454732-83728-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/code-reading.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index eec1421..df9afd9 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -304,15 +304,14 @@ static int comp(const void *a, const void *b)
 
 static void do_sort_something(void)
 {
-	size_t sz = 40960;
-	int buf[sz], i;
+	int buf[40960], i;
 
-	for (i = 0; i < (int)sz; i++)
-		buf[i] = sz - i - 1;
+	for (i = 0; i < (int)ARRAY_SIZE(buf); i++)
+		buf[i] = ARRAY_SIZE(buf) - i - 1;
 
-	qsort(buf, sz, sizeof(int), comp);
+	qsort(buf, ARRAY_SIZE(buf), sizeof(int), comp);
 
-	for (i = 0; i < (int)sz; i++) {
+	for (i = 0; i < (int)ARRAY_SIZE(buf); i++) {
 		if (buf[i] != i) {
 			pr_debug("qsort failed\n");
 			break;
