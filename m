Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3HOHzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3HOHze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:55:34 -0400
Date: Thu, 15 Aug 2013 00:54:55 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-9a6d316692d59c4400a66b01db675abac432b4b2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375926999-75129-2-git-send-email-dsahern@gmail.com>
References: <1375926999-75129-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Update documentation with live command
Git-Commit-ID: 9a6d316692d59c4400a66b01db675abac432b4b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:55:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a6d316692d59c4400a66b01db675abac432b4b2
Gitweb:     http://git.kernel.org/tip/9a6d316692d59c4400a66b01db675abac432b4b2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 21:56:39 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:05 -0300

perf kvm: Update documentation with live command

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
