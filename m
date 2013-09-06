Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750769Ab3IFFfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:35:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54367 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3IFFfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:35:31 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-4d-522969a1752c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: Free strlist in strlist__delete()
Date: Fri,  6 Sep 2013 14:35:26 +0900
Message-Id: <1378445726-10877-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems strlist never deleted after allocated.  AFAICS every strlist
is allocated dynamically, just free it in the _delete() function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/strlist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index eabdce0a2daa..11593d899eb2 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -155,8 +155,10 @@ out_error:
 
 void strlist__delete(struct strlist *slist)
 {
-	if (slist != NULL)
+	if (slist != NULL) {
 		rblist__delete(&slist->rblist);
+		free(slist);
+	}
 }
 
 struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx)
-- 
1.7.11.7

