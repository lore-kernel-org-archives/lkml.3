Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaANF0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:26:02 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51192 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaANF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:00 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-85-52d4ca666c2a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 01/24] perf tools: Remove symbol_conf.use_callchain check
Date: Tue, 14 Jan 2014 14:25:34 +0900
Message-Id: <1389677157-30513-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine__resolve_callchain() is called only if symbol_conf.
use_callchain is set so no need to check it again.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0130279aac51..ded74590b92f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1314,8 +1314,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 				*root_al = al;
 				callchain_cursor_reset(&callchain_cursor);
 			}
-			if (!symbol_conf.use_callchain)
-				break;
 		}
 
 		err = callchain_cursor_append(&callchain_cursor,
-- 
1.7.11.7

