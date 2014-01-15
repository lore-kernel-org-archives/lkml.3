Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaAOBqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:46:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaAOBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:50 -0500
X-AuditID: 9c930197-b7b7cae000000e34-71-52d5e8484c0b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 17/17] tools lib traceevent: Unregister handler when xen plugin unloaded
Date: Wed, 15 Jan 2014 10:45:40 +0900
Message-Id: <1389750340-15965-18-git-send-email-namhyung@kernel.org>
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
 tools/lib/traceevent/plugin_xen.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index e7794298f3a9..a65353f44302 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -128,3 +128,10 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_print_function(pevent,
+					 process_xen_hypercall_name,
+					 "xen_hypercall_name");
+}
-- 
1.7.11.7

