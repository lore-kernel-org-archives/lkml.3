Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3FGWWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:22:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56583 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3FGWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:22:27 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 1/4] perf: move setup_list from symbol.c to strlist.c
Date: Fri,  7 Jun 2013 16:22:11 -0600
Message-Id: <1370643734-9579-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code move only; no functional changes

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/strlist.c |   15 +++++++++++++++
 tools/perf/util/strlist.h |    2 ++
 tools/perf/util/symbol.c  |   14 --------------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index eabdce0..faa0e0f 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -170,3 +170,18 @@ struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx)
 
 	return snode;
 }
+
+int setup_list(struct strlist **list, const char *list_str,
+		              const char *list_name)
+{
+	if (list_str == NULL)
+		return 0;
+
+	*list = strlist__new(true, list_str);
+	if (!*list) {
+		pr_err("problems parsing %s list\n", list_name);
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 5c7f870..a5f433c 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -16,6 +16,8 @@ struct strlist {
 	bool	       dupstr;
 };
 
+int setup_list(struct strlist **list, const char *list_str,
+	       const char *list_name);
 struct strlist *strlist__new(bool dupstr, const char *slist);
 void strlist__delete(struct strlist *slist);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8cf3b54..3ef8be8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1164,20 +1164,6 @@ out_fail:
 	return -1;
 }
 
-static int setup_list(struct strlist **list, const char *list_str,
-		      const char *list_name)
-{
-	if (list_str == NULL)
-		return 0;
-
-	*list = strlist__new(true, list_str);
-	if (!*list) {
-		pr_err("problems parsing %s list\n", list_name);
-		return -1;
-	}
-	return 0;
-}
-
 static bool symbol__read_kptr_restrict(void)
 {
 	bool value = false;
-- 
1.7.10.1

