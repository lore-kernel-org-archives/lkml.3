Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3FXNKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:10:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:25371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3FXNKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="321686421"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 03/15] perf tools: fix missing 'finished_round'
Date: Mon, 24 Jun 2013 16:16:00 +0300
Message-Id: <1372079772-20803-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, perf inject should "repipe" all events
including 'finished_round'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index fb341f1..c9270d9 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -404,6 +404,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		= perf_event__repipe_attr,
 			.event_type	= perf_event__repipe_event_type_synth,
 			.tracing_data	= perf_event__repipe_op2_synth,
+			.finished_round	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
 		},
 		.input_name  = "-",
-- 
1.7.11.7

