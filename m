Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIXT3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:29:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58703 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbaIXT2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:28:04 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 09/10] tools/perf: Document parameterized and symbolic events
Date: Wed, 24 Sep 2014 12:27:23 -0700
Message-Id: <1411586844-21381-10-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-7182-0000-0000-0000008A51D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Changelog[v6]:
	- [Sukadev Bhattiprolu]: Update documentation of perf-list and
	  perf-record; Added documentation for perf-stat.

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-list.txt   | 13 +++++++++++++
 tools/perf/Documentation/perf-record.txt | 12 ++++++++++++
 tools/perf/Documentation/perf-stat.txt   | 20 ++++++++++++++++----
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..c405da24 100644
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
+  hv_gpci/dtbp_ptitc,starting_index=?/
+
+This means that when provided as an event, a value for 'starting_index' must
+also be supplied. For example:
+
+  perf stat -C 0 -e 'hv_gpci/dtbp_ptitc,starting_index=0x2/' ...
+
 OPTIONS
 -------
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d460049..a6a2f9c 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,6 +33,18 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
+	- a symbolically formed PMU event like 'pmu/param1=0x3,param2/' where
+	  'param1', 'param2', etc are defined as formats for the PMU in
+	  /sys/bus/event_sources/devices/<pmu>/format/*.
+
+	- a symbolically formed event like 'pmu/config=M,config1=N,config3=K/'
+
+          where M, N, K are numbers (in decimal, hex, octal format). Acceptable
+          values for each of 'config', 'config1' and 'config2' are defined by
+          corresponding entries in /sys/bus/event_sources/devices/<pmu>/format/*
+          param1 and param2 are defined as formats for the PMU in:
+	  /sys/bus/event_sources/devices/<pmu>/format/*
+
         - a hardware breakpoint event in the form of '\mem:addr[:access]'
           where addr is the address in memory you want to break in.
           Access is the memory access type (read, write, execute) it can
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 29ee857..04e150d 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -25,10 +25,22 @@ OPTIONS
 
 -e::
 --event=::
-	Select the PMU event. Selection can be a symbolic event name
-	(use 'perf list' to list all events) or a raw PMU
-	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	Select the PMU event. Selection can be:
+
+	- a symbolic event name (use 'perf list' to list all events)
+
+	- a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
+	  hexadecimal event descriptor.
+
+	- a symbolically formed event like 'pmu/param1=0x3,param2/' where
+	  param1 and param2 are defined as formats for the PMU in
+	  /sys/bus/event_sources/devices/<pmu>/format/*
+
+	- a symbolically formed event like 'pmu/config=M,config1=N,config2=K/'
+	  where M, N, K are numbers (in decimal, hex, octal format).
+	  Acceptable values for each of 'config', 'config1' and 'config2'
+	  parameters are defined by corresponding entries in
+	  /sys/bus/event_sources/devices/<pmu>/format/*
 
 -i::
 --no-inherit::
-- 
1.8.3.1

