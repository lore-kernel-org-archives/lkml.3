Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaAOUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:35:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaAOUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf tools: Remove symbol_conf.use_callchain check
Date: Wed, 15 Jan 2014 17:33:08 -0300
Message-Id: <1389817991-8145-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The machine__resolve_callchain() is called only if symbol_conf.
use_callchain is set so no need to check it again.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1389677157-30513-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

