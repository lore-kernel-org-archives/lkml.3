Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaAPCce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:32:34 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46634 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaAPCbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:25 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-db-52d74478b27e
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/12] tools lib traceevent: Unregister handler when jbd2 plugin unloaded
Date: Thu, 16 Jan 2014 11:31:16 +0900
Message-Id: <1389839478-5887-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_jbd2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 2f93f81f0bac..0db714c721be 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -66,3 +66,12 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_print_function(pevent, process_jbd2_dev_to_name,
+					 "jbd2_dev_to_name");
+
+	pevent_unregister_print_function(pevent, process_jiffies_to_msecs,
+					 "jiffies_to_msecs");
+}
-- 
1.7.11.7

