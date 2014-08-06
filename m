Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaHFPE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:04:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34814 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaHFPEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:04:55 -0400
From: naota@elisp.net
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH] perf report: Set proper sort__mode for the branch option
Date: Thu, 07 Aug 2014 00:04:49 +0900
Message-ID: <87y4v1fylq.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you specify "--branch-stack"("-b" for short) or
"--no-branch-stack", "branch_mode" variable is set to 1 or 0
respectively. However, the code is just checking if the variable is -1
or not, ignoring "branch_mode == 1" case. Thus "perf report -b" dose not
show its result with the branch sorted mode. This patch fix the problem.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830b..94dcf2d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -719,7 +719,7 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack) {
+	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
 		sort__mode = SORT_MODE__BRANCH;
 		symbol_conf.cumulate_callchain = false;
 	}
-- 
2.0.2
