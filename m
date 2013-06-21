Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161524Ab3FUOWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:22:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62949 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161425Ab3FUOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:22:07 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 7/8] perf record: add option to sample physical load/store addresses
Date: Fri, 21 Jun 2013 16:20:47 +0200
Message-Id: <1371824448-7306-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the --phys-addr option to perf record.
This is used with memory access sampling to capture physical
addresses. The option may be used in conjunction with -d, thereby
providing virtual and physical addresses for a memory access. This
is useful to disambiguate shared memory accesses between processes.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt | 4 ++++
 tools/perf/builtin-record.c              | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..ebf98c5 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -188,6 +188,10 @@ Enable weightened sampling. An additional weight is recorded per sample and can
 displayed with the weight and local_weight sort keys.  This currently works for TSX
 abort events and some memory events in precise mode on modern Intel CPUs.
 
+--phys_addr::
+Samples physical address for memory loads and stores. May be used in conjunction with
+the -d option when using memory access sampling (via perf mem).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fff985c..40bcede 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -932,6 +932,8 @@ const struct option record_options[] = {
 		    "per thread counts"),
 	OPT_BOOLEAN('d', "data", &record.opts.sample_address,
 		    "Sample addresses"),
+	OPT_BOOLEAN(0, "phys-addr", &record.opts.sample_phys_address,
+		    "Sample physical addresses"),
 	OPT_BOOLEAN('T', "timestamp", &record.opts.sample_time, "Sample timestamps"),
 	OPT_BOOLEAN('P', "period", &record.opts.period, "Sample period"),
 	OPT_BOOLEAN('n', "no-samples", &record.opts.no_samples,
-- 
1.8.1.2

