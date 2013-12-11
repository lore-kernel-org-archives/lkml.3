Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3LKMjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:60200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3LKMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280216"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 22/71] perf tools: Add option macro OPT_CALLBACK_OPTARG
Date: Wed, 11 Dec 2013 14:36:34 +0200
Message-Id: <1386765443-26966-23-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option macro that is the same as
OPT_CALLBACK except that the argument is
optional and it is possible to associate
additional data with it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-options.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index cbf0149..aec0afb 100644
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
1.8.5.1

