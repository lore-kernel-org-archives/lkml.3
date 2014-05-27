Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaE0QaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaE0Q3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:29:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/7] perf report: Add mem-mode documentation to report command
Date: Tue, 27 May 2014 12:28:04 -0400
Message-Id: <1401208087-181977-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mem-mode sorting types and mem-mode itself to perf-report documentation.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/Documentation/perf-report.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 09af662..bea1c83 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -98,6 +98,21 @@ OPTIONS
 	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
 	and symbol_to, see '--branch-stack'.
 
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
@@ -236,6 +251,13 @@ OPTIONS
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
1.7.11.7

