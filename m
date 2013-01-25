Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3AYL7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:59:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3AYL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:59:16 -0500
Date: Fri, 25 Jan 2013 03:58:50 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-08aa9cce6bf3ecdfa386cf0a0be842855eac3e7d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1358845787-1350-14-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-14-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move ltrim() to util/string.c
Git-Commit-ID: 08aa9cce6bf3ecdfa386cf0a0be842855eac3e7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:58:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08aa9cce6bf3ecdfa386cf0a0be842855eac3e7d
Gitweb:     http://git.kernel.org/tip/08aa9cce6bf3ecdfa386cf0a0be842855eac3e7d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:49 -0300

perf tools: Move ltrim() to util/string.c

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
