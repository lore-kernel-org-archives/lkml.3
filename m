Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab3GRUJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:09:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41519 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413Ab3GRTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/76] tools lib traceevent: Add page_size field to pevent
Date: Thu, 18 Jul 2013 16:49:09 -0300
Message-Id: <1374177003-3706-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The page size of traced system can be different than current system's
because the recorded data file might be analyzed in a different machine.
In this case we should use original page size of traced system when
accessing the data file, so this information needs to be saved.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 39f0c1d..c37b202 100644
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
1.8.1.4

