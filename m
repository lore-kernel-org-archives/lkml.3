Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaC0Eyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:54:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:50194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaC0Eyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="507896126"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 1/5] tracing: Make ftrace_event_field checking functions available
Date: Wed, 26 Mar 2014 23:54:03 -0500
Message-Id: <f440eed7d1cb26e3bdeb14e311ef60f41f14fb11.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make is_string_field() and is_function_field() accessible outside of
trace_event_filters.c for other users of ftrace_event_fields.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h               | 12 ++++++++++++
 kernel/trace/trace_events_filter.c | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 02b592f..26c55ff 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1012,6 +1012,18 @@ struct filter_pred {
 	unsigned short		right;
 };
 
+static inline bool is_string_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_DYN_STRING ||
+	       field->filter_type == FILTER_STATIC_STRING ||
+	       field->filter_type == FILTER_PTR_STRING;
+}
+
+static inline bool is_function_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_TRACE_FN;
+}
+
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_file *file,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8a86319..60a8e3f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -947,18 +947,6 @@ int filter_assign_type(const char *type)
 	return FILTER_OTHER;
 }
 
-static bool is_function_field(struct ftrace_event_field *field)
-{
-	return field->filter_type == FILTER_TRACE_FN;
-}
-
-static bool is_string_field(struct ftrace_event_field *field)
-{
-	return field->filter_type == FILTER_DYN_STRING ||
-	       field->filter_type == FILTER_STATIC_STRING ||
-	       field->filter_type == FILTER_PTR_STRING;
-}
-
 static int is_legal_op(struct ftrace_event_field *field, int op)
 {
 	if (is_string_field(field) &&
-- 
1.8.3.1

