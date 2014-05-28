Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaE1A1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:27:37 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:38534 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaE1A1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:27:35 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/16] tools/perf: document parameterized events and note symbolically formed events
Date: Tue, 27 May 2014 17:22:04 -0700
Message-Id: <1401236684-10579-10-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 tools/perf/Documentation/perf-list.txt   | 13 +++++++++++++
 tools/perf/Documentation/perf-record.txt |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..626818b 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -89,6 +89,19 @@ raw encoding of 0x1A8 can be used:
 You should refer to the processor specific documentation for getting these
 details. Some of them are referenced in the SEE ALSO section below.
 
+PARAMETERIZED EVENTS
+--------------------
+
+Some pmu events listed by 'perf-list' will be displayed with '?' in them. For
+example:
+
+  hv_gpci/dtbp_ptitc,phys_processor_idx=?/
+
+This means that when provided as an event, a value for phys_processor_idx must
+also be supplied. For example:
+
+  perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...
+
 OPTIONS
 -------
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c71b0f3..c005180 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,6 +33,11 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+	- a symbolicly formed PMU event like 'pmu/value1=0x3,value2/' where
+	  'value1' and 'value2' are defined as formats in
+	  /sys/bus/event_sources/devices/pmu/format/* OR are one of 'config',
+	  'config1', 'config2'.
+
         - a hardware breakpoint event in the form of '\mem:addr[:access]'
           where addr is the address in memory you want to break in.
           Access is the memory access type (read, write, execute) it can
-- 
1.9.3

