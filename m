Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaGNKGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:06:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:42003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbaGNKFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434675"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 30/41] perf tools: Add option macro OPT_CALLBACK_OPTARG
Date: Mon, 14 Jul 2014 13:02:54 +0300
Message-Id: <1405332185-4050-31-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an option macro that is the same as
OPT_CALLBACK except that the argument is
optional and it is possible to associate
additional data with it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-options.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index d8dac8a..b59ba85 100644
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
1.8.3.2

