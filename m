Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3IKFJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:09:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60655 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3IKFJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:36 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-68-522ffb0e0b30
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/9] perf annotate: Reuse path from the result of addr2line
Date: Wed, 11 Sep 2013 14:09:26 +0900
Message-Id: <1378876173-13363-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In the symbol__get_source_line(), path and src_line->path will have
same value, but they were allocated separately, and leaks one.
Just share path to src_line->path.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bfc5a27597d6..4f97ae3ec9c0 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1143,11 +1143,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		if (getline(&path, &line_len, fp) < 0 || !line_len)
 			goto next_close;
 
-		src_line->path = malloc(sizeof(char) * line_len + 1);
-		if (!src_line->path)
-			goto next_close;
-
-		strcpy(src_line->path, path);
+		src_line->path = path;
 		insert_source_line(&tmp_root, src_line);
 
 	next_close:
-- 
1.7.11.7

