Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3KAJ3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:29:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61497 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KAJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:29:48 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 3/4] perf tools: record min_timestamp of samples queue in ordered_samples
Date: Fri,  1 Nov 2013 17:29:05 +0800
Message-Id: <1383298146-3860-4-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a field 'min_timestamp' in struct ordered_samples to record the minimial
timestamp of the samples in ordered_samples->samples.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/session.c |    3 +++
 tools/perf/util/session.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 193bb6a..4e9dd66 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -708,6 +708,9 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	new->file_offset = file_offset;
 	new->event = event;
 
+	if (list_empty(&os->samples) || os->min_timestamp > timestamp)
+		os->min_timestamp = timestamp;
+
 	__queue_event(new, s);
 
 	return 0;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c9a6c27..7d411b9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -18,6 +18,7 @@ struct ordered_samples {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
+	u64			min_timestamp;
 	struct list_head	samples;
 	struct list_head	sample_cache;
 	struct list_head	to_free;
-- 
1.7.8.rc2.5.g815b

