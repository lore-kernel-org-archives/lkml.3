Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab3AXUPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:15:09 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54094
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab3AXUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 60/74] perf tools: Move ltrim() to util/string.c
Date: Thu, 24 Jan 2013 17:08:09 -0300
Message-Id: <1359058103-31645-61-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As we have ltrim() implementation in builtin-script.c move it to the
more generic location of util/string.c so that it can be used from other
places.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1358845787-1350-14-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 12 ------------
 tools/perf/util/string.c    | 18 ++++++++++++++++++
 tools/perf/util/util.h      |  1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3314ef2..fee4c9a 100644
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
index 346707d..29c7b2c 100644
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
index ec5de5e..09b4c26 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,6 +265,7 @@ bool is_power_of_2(unsigned long n)
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
+char *ltrim(char *s);
 char *rtrim(char *s);
 
 void dump_stack(void);
-- 
1.8.1.1.361.gec3ae6e

