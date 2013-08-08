Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab3HHB44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:56:56 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38241 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3HHB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:56:51 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 2/2] perf kvm: Update documentation with live command
Date: Wed,  7 Aug 2013 21:56:39 -0400
Message-Id: <1375926999-75129-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
References: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update perf-kvm documentation with new live subcommand. Add -p/--pid option
for perf-kvm-stat-report as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-kvm.txt |   46 +++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 326f2cb..ac84db2 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -13,6 +13,7 @@ SYNOPSIS
 	{top|record|report|diff|buildid-list}
 'perf kvm' [--host] [--guest] [--guestkallsyms=<path> --guestmodules=<path>
 	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat}
+'perf kvm stat [record|report|live] [<options>]
 
 DESCRIPTION
 -----------
@@ -50,6 +51,10 @@ There are a couple of variants of perf kvm:
   'perf kvm stat report' reports statistical data which includes events
   handled time, samples, and so on.
 
+  'perf kvm stat live' reports statistical data in a live mode (similar to
+  record + report but with statistical data updated live at a given display
+  rate).
+
 OPTIONS
 -------
 -i::
@@ -85,13 +90,50 @@ STAT REPORT OPTIONS
 --vcpu=<value>::
        analyze events which occures on this vcpu. (default: all vcpus)
 
---events=<value>::
-       events to be analyzed. Possible values: vmexit, mmio, ioport.
+--event=<value>::
+       event to be analyzed. Possible values: vmexit, mmio, ioport.
        (default: vmexit)
 -k::
 --key=<value>::
        Sorting key. Possible values: sample (default, sort by samples
        number), time (sort by average time).
+-p::
+--pid=::
+    Analyze events only for given process ID(s) (comma separated list).
+
+STAT LIVE OPTIONS
+-----------------
+-d::
+--display::
+        Time in seconds between display updates
+
+-m::
+--mmap-pages=::
+    Number of mmap data pages. Must be a power of two.
+
+-a::
+--all-cpus::
+        System-wide collection from all CPUs.
+
+-p::
+--pid=::
+    Analyze events only for given process ID(s) (comma separated list).
+
+--vcpu=<value>::
+       analyze events which occures on this vcpu. (default: all vcpus)
+
+
+--event=<value>::
+       event to be analyzed. Possible values: vmexit, mmio, ioport.
+       (default: vmexit)
+
+-k::
+--key=<value>::
+       Sorting key. Possible values: sample (default, sort by samples
+       number), time (sort by average time).
+
+--duration=<value>::
+       Show events other than HLT that take longer than duration usecs.
 
 SEE ALSO
 --------
-- 
1.7.10.1

