Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FDFYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:24:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42115 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3FDFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:35 -0400
X-AuditID: 9c930179-b7c07ae000000e33-2e-51ad79213041
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/16] tools lib traceevent: Add page_size field to pevent
Date: Tue,  4 Jun 2013 14:20:20 +0900
Message-Id: <1370323231-14022-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The page size of traced system can be different than current system's
because the recorded data file might be analyzed in a different machine.
In this case we should use original page size of traced system when
accessing the data file, so this information needs to be saved.

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

