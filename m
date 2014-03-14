Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaCNVag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53968 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaCNVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/16] perf mem: Clarify load-latency in documentation
Date: Fri, 14 Mar 2014 18:29:58 -0300
Message-Id: <1394832610-17818-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clarify in the documentation that 'perf mem report' reports use-latency,
not load/store-latency on Intel systems.

This often causes confusion with users.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393596135-4227-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-mem.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 888d51137fbe..1d78a4064da4 100644
--- a/tools/perf/Documentation/perf-mem.txt
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -18,6 +18,10 @@ from it, into perf.data. Perf record options are accepted and are passed through
 "perf mem -t <TYPE> report" displays the result. It invokes perf report with the
 right set of options to display a memory access profile.
 
+Note that on Intel systems the memory latency reported is the use-latency,
+not the pure load (or store latency). Use latency includes any pipeline
+queueing delays in addition to the memory subsystem latency.
+
 OPTIONS
 -------
 <command>...::
-- 
1.8.1.4

