Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbbA1VRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:17:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955AbbA1Uub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:31 -0500
Date: Wed, 28 Jan 2015 07:06:15 -0800
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-f9ab9c196d015f3bd8f6bd1c30785c5a49542323@git.kernel.org>
Cc: tglx@linutronix.de, jolsa@kernel.org, peterz@infradead.org,
        sukadev@linux.vnet.ibm.com, hbabu@us.ibm.com, paulus@samba.org,
        mpe@ellerman.id.au, dev@codyps.com, linux-kernel@vger.kernel.org,
        cody@linux.vnet.ibm.com, mingo@kernel.org, jolsa@redhat.com,
        acme@redhat.com, hpa@zytor.com
Reply-To: sukadev@linux.vnet.ibm.com, hbabu@us.ibm.com, jolsa@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, mingo@kernel.org,
        hpa@zytor.com, acme@redhat.com, jolsa@redhat.com, mpe@ellerman.id.au,
        paulus@samba.org, cody@linux.vnet.ibm.com, dev@codyps.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1420679633-28856-5-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1420679633-28856-5-git-send-email-sukadev@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Document parameterized and symbolic events
Git-Commit-ID: f9ab9c196d015f3bd8f6bd1c30785c5a49542323
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9ab9c196d015f3bd8f6bd1c30785c5a49542323
Gitweb:     http://git.kernel.org/tip/f9ab9c196d015f3bd8f6bd1c30785c5a49542323
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Wed, 7 Jan 2015 17:13:53 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:33 -0300

perf tools: Document parameterized and symbolic events

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1420679633-28856-5-git-send-email-sukadev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt   | 13 +++++++++++++
 tools/perf/Documentation/perf-record.txt | 12 ++++++++++++
 tools/perf/Documentation/perf-stat.txt   | 20 ++++++++++++++++----
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index cbb4f74..3e2aec9 100644
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
+This means that when provided as an event, a value for '?' must
+also be supplied. For example:
+
+  perf stat -C 0 -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...
+
 OPTIONS
 -------
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index af9a54e..7d8df2e 100644
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
+          /sys/bus/event_sources/devices/<pmu>/format/*
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
