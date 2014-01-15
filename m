Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaAOBqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:46:55 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaAOBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:48 -0500
X-AuditID: 9c930197-b7b7cae000000e34-6d-52d5e8489940
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/17] tools lib traceevent: Unregister handler when cfg80211 plugin unloaded
Date: Wed, 15 Jan 2014 10:45:37 +0900
Message-Id: <1389750340-15965-15-git-send-email-namhyung@kernel.org>
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
 tools/lib/traceevent/plugin_cfg80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index dcab8e873c21..7b07d149557b 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -22,3 +22,10 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_print_function(pevent,
+					 process___le16_to_cpup,
+					 "__le16_to_cpup");
+}
-- 
1.7.11.7

