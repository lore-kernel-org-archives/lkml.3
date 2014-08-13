Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaHMWul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:55459 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbaHMWuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:39 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "naota@elisp.net" <naota@elisp.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/41] perf report: Set proper sort__mode for the branch option
Date: Wed, 13 Aug 2014 19:48:14 -0300
Message-Id: <1407970107-24540-29-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "naota@elisp.net" <naota@elisp.net>

When you specify "--branch-stack"("-b" for short) or
"--no-branch-stack", "branch_mode" variable is set to 1 or 0
respectively. However, the code is just checking if the variable is -1
or not, ignoring "branch_mode == 1" case. Thus "perf report -b" dose not
show its result with the branch sorted mode. This patch fix the problem.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87y4v1fylq.fsf@elisp.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b9e0fcac4d71..3da59a87ec7c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -730,7 +730,7 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack) {
+	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
 		sort__mode = SORT_MODE__BRANCH;
 		symbol_conf.cumulate_callchain = false;
 	}
-- 
1.9.3

