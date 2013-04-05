Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3DEB1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:27:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765988Ab3DEB0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:26:46 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-0b-515e2852e262
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/8] perf sort: Cleanup sort__has_sym setting
Date: Fri,  5 Apr 2013 10:26:36 +0900
Message-Id: <1365125198-8334-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The sort__has_sym variable is set only if a symbol-related sort key
was added.  Since branch stack and memory sort dimensions are
separated, it doesn't need to be checked from common dimension.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index e4388cbda8ce..55217be009bb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1015,10 +1015,7 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym ||
-			   sd->entry == &sort_sym_from ||
-			   sd->entry == &sort_sym_to ||
-			   sd->entry == &sort_mem_daddr_sym) {
+		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
 		}
 
-- 
1.7.11.7

