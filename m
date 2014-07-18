Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbaGRE1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:27:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaGRE1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:08 -0400
Date: Thu, 17 Jul 2014 21:26:13 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-ea8e08a16a1e6566be3f775c0bd351fa52ab6b9d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-31-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-31-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add option macro OPT_CALLBACK_OPTARG
Git-Commit-ID: ea8e08a16a1e6566be3f775c0bd351fa52ab6b9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea8e08a16a1e6566be3f775c0bd351fa52ab6b9d
Gitweb:     http://git.kernel.org/tip/ea8e08a16a1e6566be3f775c0bd351fa52ab6b9d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:54 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:36 -0300

perf tools: Add option macro OPT_CALLBACK_OPTARG

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
