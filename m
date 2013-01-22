Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3AVJLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:11:08 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3AVJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:11:03 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-fb-50fe57a0fab0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 13/19] perf tools: Move ltrim() to util/string.c
Date: Tue, 22 Jan 2013 18:09:41 +0900
Message-Id: <1358845787-1350-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we have ltrim() implementation in builtin-script.c move it to the
more generic location of util/string.c so that it can be used from
other places.

Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c | 12 ------------
 tools/perf/util/string.c    | 18 ++++++++++++++++++
 tools/perf/util/util.h      |  1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3314ef2ec83e..fee4c9a8aee5 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -909,18 +909,6 @@ static const char *ends_with(const char *str, const char *suffix)
 	return NULL;
 }
 
-static char *ltrim(char *str)
-{
-	int len = strlen(str);
-
-	while (len && isspace(*str)) {
-		len--;
-		str++;
-	}
-
-	return str;
-}
-
 static int read_script_info(struct script_desc *desc, const char *filename)
 {
 	char line[BUFSIZ], *p;
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 346707df04b9..29c7b2cb2521 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -332,6 +332,24 @@ char *strxfrchar(char *s, char from, char to)
 }
 
 /**
+ * ltrim - Removes leading whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Return pointer to the first non-whitespace character in @s.
+ */
+char *ltrim(char *s)
+{
+	int len = strlen(s);
+
+	while (len && isspace(*s)) {
+		len--;
+		s++;
+	}
+
+	return s;
+}
+
+/**
  * rtrim - Removes trailing whitespace from @s.
  * @s: The string to be stripped.
  *
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index ec5de5e3330c..09b4c26b71aa 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,6 +265,7 @@ bool is_power_of_2(unsigned long n)
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
+char *ltrim(char *s);
 char *rtrim(char *s);
 
 void dump_stack(void);
-- 
1.7.11.7

