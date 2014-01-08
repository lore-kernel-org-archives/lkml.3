Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaAHIrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:47:07 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48061 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaAHIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:39 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-f5-52cd106d9a17
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 03/28] perf tools: Remove symbol_conf.use_callchain check
Date: Wed,  8 Jan 2014 17:46:08 +0900
Message-Id: <1389170793-21926-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
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
index a98538dc465a..4dcc89490858 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1313,8 +1313,6 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 				*root_al = al;
 				callchain_cursor_reset(&callchain_cursor);
 			}
-			if (!symbol_conf.use_callchain)
-				break;
 		}
 
 		err = callchain_cursor_append(&callchain_cursor,
-- 
1.7.11.7

