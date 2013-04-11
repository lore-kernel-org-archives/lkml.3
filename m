Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935611Ab3DKMGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:06:08 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64950 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935410Ab3DKMFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:05:41 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-dc-5166a7122d82
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
Date: Thu, 11 Apr 2013 21:04:57 +0900
Message-Id: <1365681898-19897-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's for saving the page size of traced system.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 39f0c1dca915..c37b2026d04a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -400,6 +400,7 @@ struct pevent {
 
 	int cpus;
 	int long_size;
+	int page_size;
 
 	struct cmdline *cmdlines;
 	struct cmdline_list *cmdlist;
@@ -621,6 +622,16 @@ static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
 	pevent->long_size = long_size;
 }
 
+static inline int pevent_get_page_size(struct pevent *pevent)
+{
+	return pevent->page_size;
+}
+
+static inline void pevent_set_page_size(struct pevent *pevent, int _page_size)
+{
+	pevent->page_size = _page_size;
+}
+
 static inline int pevent_is_file_bigendian(struct pevent *pevent)
 {
 	return pevent->file_bigendian;
-- 
1.7.11.7

