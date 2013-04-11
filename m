Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3DKGzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:55:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45830 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3DKGzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:55:10 -0400
X-AuditID: 9c930179-b7b2aae000000518-2b-51665e4a7aff
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] tracing: Reset ftrace_graph_filter_enabled if count is zero
Date: Thu, 11 Apr 2013 15:55:02 +0900
Message-Id: <1365663302-2170-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365663302-2170-1-git-send-email-namhyung@kernel.org>
References: <1365663302-2170-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace_graph_count can be decreased with a "!" pattern, so that
the enabled flag should be updated too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index be2bcb7ab2f7..3b5ef16692c5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3779,7 +3779,11 @@ out:
 	if (fail)
 		return -EINVAL;
 
-	ftrace_graph_filter_enabled = 1;
+	if (*idx)
+		ftrace_graph_filter_enabled = 1;
+	else
+		ftrace_graph_filter_enabled = 0;
+
 	return 0;
 }
 
-- 
1.7.11.7

