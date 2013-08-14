Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab3HNS3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:29:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203Ab3HNSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/21] perf kvm: Update documentation with live command
Date: Wed, 14 Aug 2013 15:24:56 -0300
Message-Id: <1376504715-28107-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Update perf-kvm documentation with new live subcommand. Add -p/--pid
option for perf-kvm-stat-report as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Requested-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375926999-75129-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt | 46 +++++++++++++++++++++++++++++++++--
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
1.8.1.4

