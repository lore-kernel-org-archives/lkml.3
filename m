Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaFIUE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbaFIUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:05 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 11/15] perf report: Add mem-mode documentation to report command
Date: Mon,  9 Jun 2014 22:02:26 +0200
Message-Id: <1402344150-14860-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

Add mem-mode sorting types and mem-mode itself to perf-report documentation.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1400526833-141779-5-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index cefdf43..00fbfb6 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -117,6 +117,21 @@ OPTIONS
 	By default, every sort keys not specified in -F will be appended
 	automatically.
 
+	If --mem-mode option is used, following sort keys are also available
+	(incompatible with --branch-stack):
+	symbol_daddr, dso_daddr, locked, tlb, mem, snoop.
+
+	- symbol_daddr: name of data symbol being executed on at the time of sample
+	- dso_daddr: name of library or module containing the data being executed
+	on at the time of sample
+	- locked: whether the bus was locked at the time of sample
+	- tlb: type of tlb access for the data at the time of sample
+	- mem: type of memory access for the data at the time of sample
+	- snoop: type of snoop (if any) for the data at the time of sample
+
+	And default sort keys are changed to local_weight, mem, sym, dso,
+	symbol_daddr, dso_daddr, snoop, tlb, locked, see '--mem-mode'.
+
 -p::
 --parent=<regex>::
         A regex filter to identify parent. The parent is a caller of this
@@ -260,6 +275,13 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
+--mem-mode::
+	Use the data addresses of samples in addition to instruction addresses
+	to build the histograms.  To generate meaningful output, the perf.data
+	file must have been obtained using perf record -d -W and using a
+	special event -e cpu/mem-loads/ or -e cpu/mem-stores/. See
+	'perf mem' for simpler access.
+
 --percent-limit::
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
-- 
1.8.3.1

