Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaEUTeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:34:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:50744 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:34:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf: delete unused variable tmp to fix new build warning
Date: Wed, 21 May 2014 15:33:07 -0400
Message-Id: <1400700787-11759-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3a497f48637e2aac17eabb84a17f8ac5216028fc [tip:perf/core]
("perf: Simplify perf_event_exit_task_context()") deleted the
code that was using tmp but not the declaration of it, causing:

kernel/events/core.c:7434:35: warning: unused variable ‘tmp’ [-Wunused-variable]

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 49ac18c..244d70a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7432,7 +7432,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
-- 
1.8.2.3

