Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3KULBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:01:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3KULBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:01:49 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/22] tools lib traceevent: Add traceevent_host_bigendian function
Date: Thu, 21 Nov 2013 12:01:01 +0100
Message-Id: <1385031680-9014-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding traceevent_host_bigendian function to get host
endianity. It's used in following patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a288860..0ad7f6b 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -527,6 +527,15 @@ __data2host8(struct pevent *pevent, unsigned long long data)
 	__data2host8(pevent, __val);				\
 })
 
+static inline int traceevent_host_bigendian(void)
+{
+	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
+	unsigned int *ptr;
+
+	ptr = (unsigned int *)str;
+	return *ptr == 0x01020304;
+}
+
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
-- 
1.8.3.1

