Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaAOBsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:48:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53517 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaAOBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:47 -0500
X-AuditID: 9c930197-b7b7cae000000e34-63-52d5e847e968
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/17] tools lib traceevent: Unregister handler when kmem plugin unloaded
Date: Wed, 15 Jan 2014 10:45:33 +0900
Message-Id: <1389750340-15965-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kmem handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_kmem.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 7115c8037ea8..70650ff48d78 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -70,3 +70,25 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				      call_site_handler, NULL);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_event_handler(pevent, -1, "kmem", "kfree",
+					call_site_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
+					call_site_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
+					call_site_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+					call_site_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kmem",
+					"kmem_cache_alloc_node",
+					call_site_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+					call_site_handler, NULL);
+}
-- 
1.7.11.7

