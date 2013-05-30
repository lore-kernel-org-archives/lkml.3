Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718Ab3E3QC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442Ab3E3QCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/66] perf tools: Fix bug in isupper() and islower()
Date: Thu, 30 May 2013 19:00:34 +0300
Message-Id: <1369929699-8724-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

One of the reasons 'perf test' is failing on Power appears to be due to
a bug in isupper().

isupper(c) and islower(c) should be checking 'c' against the mask 0x20.
Instead they are checking sane_ctype[c] which causes isupper() to be
true for lower case letters.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20130329192950.GA9312@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a45710b..7a484c9 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -221,8 +221,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
-#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
+#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
-- 
1.8.1.4

