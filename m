Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaAOBsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:48:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaAOBpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:45 -0500
X-AuditID: 9c930197-b7b7cae000000e34-5d-52d5e84692d0
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/17] tools lib traceevent: Unregister handler when function plugin unloaded
Date: Wed, 15 Jan 2014 10:45:31 +0900
Message-Id: <1389750340-15965-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function handler should be unregistered when the plugin unloaded
otherwise it'll try to access invalid memory.

Cc: Jiri Olsa <jolsa@redhat.com>
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

