Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaB1OC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:02:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:8266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaB1OC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:02:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,562,1389772800"; 
   d="scan'208";a="483589613"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        eranian@google.com
Subject: [PATCH 1/2] perf, tools, mem: Clarify load-latency in documentation
Date: Fri, 28 Feb 2014 06:02:14 -0800
Message-Id: <1393596135-4227-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393596135-4227-1-git-send-email-andi@firstfloor.org>
References: <1393596135-4227-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clarify in the documentation that perf mem report reports
use-latency, not load/store-latency on Intel systems.
This often causes confusion with users.

Cc: eranian@google.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-mem.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 888d511..1d78a40 100644
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
1.8.5.3

