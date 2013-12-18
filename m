Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3LRFWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:22:16 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56165 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3LRFVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:33 -0500
X-AuditID: 9c93017d-b7c5eae000004296-32-52b130d936de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 14/18] perf ui/gtk: Add support to accumulated hist stat
Date: Wed, 18 Dec 2013 14:21:22 +0900
Message-Id: <1387344086-12744-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Print accumulated stat of a hist entry if requested.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 2ca66cc1160f..70ed0d5e1b94 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -98,11 +98,25 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+static u64 he_get_acc_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat_acc->_field;						\
+}										\
+										\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+				       struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
+{										\
+	return __hpp__color_fmt(hpp, he, he_get_acc_##_field);			\
+}
+
 __HPP_COLOR_PERCENT_FN(overhead, period)
 __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
 __HPP_COLOR_PERCENT_FN(overhead_us, period_us)
 __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
 __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period)
 
 #undef __HPP_COLOR_PERCENT_FN
 
@@ -121,6 +135,8 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				perf_gtk__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				perf_gtk__hpp_color_overhead_acc;
 }
 
 static void callchain_list__sym_name(struct callchain_list *cl,
-- 
1.7.11.7

