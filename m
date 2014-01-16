Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaAPCfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:35:02 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58256 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaAPCbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:22 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-cc-52d744779a99
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/12] tools lib traceevent: Unregister handler when function plugin unloaded
Date: Thu, 16 Jan 2014 11:31:09 +0900
Message-Id: <1389839478-5887-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function handler should be unregistered when the plugin unloaded
otherwise it'll try to access invalid memory.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_function.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 39461485f9a7..80ba4ff1fe84 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -148,6 +148,9 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 {
 	int i, x;
 
+	pevent_unregister_event_handler(pevent, -1, "ftrace", "function",
+					function_handler, NULL);
+
 	for (i = 0; i <= cpus; i++) {
 		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
 			free(fstack[i].stack[x]);
-- 
1.7.11.7

