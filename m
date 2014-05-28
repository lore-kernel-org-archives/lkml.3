Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaE1NVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaE1NVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:21:16 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 4/9] perf report: Add mem-mode documentation to report command
Date: Wed, 28 May 2014 15:20:57 +0200
Message-Id: <1401283262-16035-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401283262-16035-1-git-send-email-jolsa@kernel.org>
References: <1401283262-16035-1-git-send-email-jolsa@kernel.org>
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
index a1b5185..4986bde 100644
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
@@ -255,6 +270,13 @@ OPTIONS
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

