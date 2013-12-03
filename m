Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3LCNKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:10:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab3LCNKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:10:16 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/28] tools lib traceevent: Add traceevent_host_bigendian function
Date: Tue,  3 Dec 2013 14:09:18 +0100
Message-Id: <1386076182-14484-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding traceevent_host_bigendian function to get host
endianity. It's used in following patches.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a288860..54273c0 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -23,6 +23,7 @@
 #include <stdbool.h>
 #include <stdarg.h>
 #include <regex.h>
+#include <string.h>
 
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((unused))
@@ -527,6 +528,15 @@ __data2host8(struct pevent *pevent, unsigned long long data)
 	__data2host8(pevent, __val);				\
 })
 
+static inline int traceevent_host_bigendian(void)
+{
+	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
+	unsigned int val;
+
+	memcpy(&val, str, 4);
+	return val == 0x01020304;
+}
+
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
-- 
1.8.3.1

