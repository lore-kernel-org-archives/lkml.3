Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387AbaGQQR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:17:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:52520 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934874AbaGQQOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:33 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/33] perf tools: Add option macro OPT_CALLBACK_OPTARG
Date: Thu, 17 Jul 2014 13:12:24 -0300
Message-Id: <1405613555-23380-23-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option macro that is the same as OPT_CALLBACK except that the
argument is optional and it is possible to associate additional data
with it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-31-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index d8dac8ac5f37..b59ba858e73d 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -98,6 +98,7 @@ struct option {
 	parse_opt_cb *callback;
 	intptr_t defval;
 	bool *set;
+	void *data;
 };
 
 #define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
@@ -131,6 +132,10 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
 	.value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d,\
 	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
+#define OPT_CALLBACK_OPTARG(s, l, v, d, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), \
+	  .value = (v), (a), .help = (h), .callback = (f), \
+	  .flags = PARSE_OPT_OPTARG, .data = (d) }
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
-- 
1.9.3

