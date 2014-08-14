Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaHNIuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:50:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaHNIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:50:00 -0400
Date: Thu, 14 Aug 2014 01:49:10 -0700
From: "tip-bot for naota@elisp.net" <tipbot@zytor.com>
Message-ID: <tip-edd114e213751c3274891f692be66eb65771f278@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <87y4v1fylq.fsf@elisp.net>
References: <87y4v1fylq.fsf@elisp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Set proper sort__mode for the branch option
Git-Commit-ID: edd114e213751c3274891f692be66eb65771f278
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edd114e213751c3274891f692be66eb65771f278
Gitweb:     http://git.kernel.org/tip/edd114e213751c3274891f692be66eb65771f278
Author:     naota@elisp.net <naota@elisp.net>
AuthorDate: Thu, 7 Aug 2014 00:04:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 17:13:48 -0300

perf report: Set proper sort__mode for the branch option

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
index b9e0fca..3da59a8 100644
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
