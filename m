Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3EUGOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:14:49 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46119 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3EUGOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:46 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-8e-519b10d1314c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 7/7] perf gtk/hists: Set rules hint for the hist browser
Date: Tue, 21 May 2013 15:14:38 +0900
Message-Id: <1369116878-12489-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The 'rules' means that every second line of the tree view has a shaded
background, which makes it easier to see which cell belongs to which
row in the tree view.  It can be useful for a tree view that has a lot
of rows.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e161317236fe..b108d2fb1130 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -339,6 +339,8 @@ add:
 				 G_CALLBACK(on_row_activated), NULL);
 	}
 
+	gtk_tree_view_set_rules_hint(GTK_TREE_VIEW(view), TRUE);
+
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
 
-- 
1.7.11.7

