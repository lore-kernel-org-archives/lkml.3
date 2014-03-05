Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaCEOiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbaCEOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Joel Uckelman <joel@lightboxtechnologies.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vinson Lee <vlee@twopensource.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 28/62] perf tools: Fix cache event name generation
Date: Wed,  5 Mar 2014 14:36:32 +0000
Message-Id: <1394030226-26652-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit 275ef3878f698941353780440fec6926107a320b upstream.

If the event name is specified with all 3 components, the last one
overwrites the previous one during the name composing within the
parse_events_add_cache function.

Fixing this by properly adjusting the string index.

Reported-by: Joel Uckelman <joel@lightboxtechnologies.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joel Uckelman <joel@lightboxtechnologies.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LPU-Reference: 20120905175133.GA18352@krava.brq.redhat.com
[ committer note: Remove the newline fix, done already in 42e1fb7 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d2006bd..5f99cec 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -420,7 +420,7 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	for (i = 0; (i < 2) && (op_result[i]); i++) {
 		char *str = op_result[i];
 
-		snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
+		n += snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
 
 		if (cache_op == -1) {
 			cache_op = parse_aliases(str, hw_cache_op,
-- 
1.9.0

