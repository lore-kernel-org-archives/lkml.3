Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3AYMMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:12:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3AYMMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:12:01 -0500
Date: Fri, 25 Jan 2013 04:11:47 -0800
From: tip-bot for Tom Zanussi <tom.zanussi@linux.intel.com>
Message-ID: <tip-1de7b7e89d16e3daf32fb3b6f214d038ab2ed879@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, tom.zanussi@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, tom.zanussi@linux.intel.com
In-Reply-To: <e7a7637d5df9df86887c3bff7683574665ec5360.1358527965.git.tom.zanussi@linux.intel.com>
References: <e7a7637d5df9df86887c3bff7683574665ec5360.1358527965.git.tom.zanussi@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Remove workqueue-stats script
Git-Commit-ID: 1de7b7e89d16e3daf32fb3b6f214d038ab2ed879
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:11:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1de7b7e89d16e3daf32fb3b6f214d038ab2ed879
Gitweb:     http://git.kernel.org/tip/1de7b7e89d16e3daf32fb3b6f214d038ab2ed879
Author:     Tom Zanussi <tom.zanussi@linux.intel.com>
AuthorDate: Fri, 18 Jan 2013 13:51:28 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:53 -0300

perf script: Remove workqueue-stats script

The tracepoints used by the workqueue-stats script no longer exist so
trying to run the script results in:

  # perf script record workqueue-stats
  invalid or unsupported event: 'workqueue:workqueue_creation'
  Run 'perf list' for a list of valid events

So remove the script until it can be reworked using the new workqueue
tracepoints.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/e7a7637d5df9df86887c3bff7683574665ec5360.1358527965.git.tom.zanussi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script-python.txt    |   2 -
 tools/perf/scripts/perl/bin/workqueue-stats-record |   2 -
 tools/perf/scripts/perl/bin/workqueue-stats-report |   3 -
 tools/perf/scripts/perl/workqueue-stats.pl         | 129 ---------------------
 4 files changed, 136 deletions(-)

diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index a4027f2..9f1f054 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -336,7 +336,6 @@ scripts listed by the 'perf script -l' command e.g.:
 ----
 root@tropicana:~# perf script -l
 List of available trace scripts:
-  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
   wakeup-latency                       system-wide min/max/avg wakeup latency
   rw-by-file <comm>                    r/w activity for a program, by file
   rw-by-pid                            system-wide r/w activity
@@ -402,7 +401,6 @@ should show a new entry for your script:
 ----
 root@tropicana:~# perf script -l
 List of available trace scripts:
-  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
   wakeup-latency                       system-wide min/max/avg wakeup latency
   rw-by-file <comm>                    r/w activity for a program, by file
   rw-by-pid                            system-wide r/w activity
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
deleted file mode 100644
index 8edda90..0000000
--- a/tools/perf/scripts/perl/bin/workqueue-stats-record
+++ /dev/null
@@ -1,2 +0,0 @@
-#!/bin/bash
-perf record -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
deleted file mode 100644
index 6d91411..0000000
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ /dev/null
@@ -1,3 +0,0 @@
-#!/bin/bash
-# description: workqueue stats (ins/exe/create/destroy)
-perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/workqueue-stats.pl
diff --git a/tools/perf/scripts/perl/workqueue-stats.pl b/tools/perf/scripts/perl/workqueue-stats.pl
deleted file mode 100644
index a8eaff5..0000000
--- a/tools/perf/scripts/perl/workqueue-stats.pl
+++ /dev/null
@@ -1,129 +0,0 @@
-#!/usr/bin/perl -w
-# (c) 2009, Tom Zanussi <tzanussi@gmail.com>
-# Licensed under the terms of the GNU GPL License version 2
-
-# Displays workqueue stats
-#
-# Usage:
-#
-#   perf record -c 1 -f -a -R -e workqueue:workqueue_creation -e
-#     workqueue:workqueue_destruction -e workqueue:workqueue_execution
-#     -e workqueue:workqueue_insertion
-#
-#   perf script -p -s tools/perf/scripts/perl/workqueue-stats.pl
-
-use 5.010000;
-use strict;
-use warnings;
-
-use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
-use lib "./Perf-Trace-Util/lib";
-use Perf::Trace::Core;
-use Perf::Trace::Util;
-
-my @cpus;
-
-sub workqueue::workqueue_destruction
-{
-    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
-	$common_pid, $common_comm,
-	$thread_comm, $thread_pid) = @_;
-
-    $cpus[$common_cpu]{$thread_pid}{destroyed}++;
-    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
-}
-
-sub workqueue::workqueue_creation
-{
-    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
-	$common_pid, $common_comm,
-	$thread_comm, $thread_pid, $cpu) = @_;
-
-    $cpus[$common_cpu]{$thread_pid}{created}++;
-    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
-}
-
-sub workqueue::workqueue_execution
-{
-    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
-	$common_pid, $common_comm,
-	$thread_comm, $thread_pid, $func) = @_;
-
-    $cpus[$common_cpu]{$thread_pid}{executed}++;
-    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
-}
-
-sub workqueue::workqueue_insertion
-{
-    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
-	$common_pid, $common_comm,
-	$thread_comm, $thread_pid, $func) = @_;
-
-    $cpus[$common_cpu]{$thread_pid}{inserted}++;
-    $cpus[$common_cpu]{$thread_pid}{comm} = $thread_comm;
-}
-
-sub trace_end
-{
-    print "workqueue work stats:\n\n";
-    my $cpu = 0;
-    printf("%3s %6s %6s\t%-20s\n", "cpu", "ins", "exec", "name");
-    printf("%3s %6s %6s\t%-20s\n", "---", "---", "----", "----");
-    foreach my $pidhash (@cpus) {
-	while ((my $pid, my $wqhash) = each %$pidhash) {
-	    my $ins = $$wqhash{'inserted'} || 0;
-	    my $exe = $$wqhash{'executed'} || 0;
-	    my $comm = $$wqhash{'comm'} || "";
-	    if ($ins || $exe) {
-		printf("%3u %6u %6u\t%-20s\n", $cpu, $ins, $exe, $comm);
-	    }
-	}
-	$cpu++;
-    }
-
-    $cpu = 0;
-    print "\nworkqueue lifecycle stats:\n\n";
-    printf("%3s %6s %6s\t%-20s\n", "cpu", "created", "destroyed", "name");
-    printf("%3s %6s %6s\t%-20s\n", "---", "-------", "---------", "----");
-    foreach my $pidhash (@cpus) {
-	while ((my $pid, my $wqhash) = each %$pidhash) {
-	    my $created = $$wqhash{'created'} || 0;
-	    my $destroyed = $$wqhash{'destroyed'} || 0;
-	    my $comm = $$wqhash{'comm'} || "";
-	    if ($created || $destroyed) {
-		printf("%3u %6u %6u\t%-20s\n", $cpu, $created, $destroyed,
-		       $comm);
-	    }
-	}
-	$cpu++;
-    }
-
-    print_unhandled();
-}
-
-my %unhandled;
-
-sub print_unhandled
-{
-    if ((scalar keys %unhandled) == 0) {
-	return;
-    }
-
-    print "\nunhandled events:\n\n";
-
-    printf("%-40s  %10s\n", "event", "count");
-    printf("%-40s  %10s\n", "----------------------------------------",
-	   "-----------");
-
-    foreach my $event_name (keys %unhandled) {
-	printf("%-40s  %10d\n", $event_name, $unhandled{$event_name});
-    }
-}
-
-sub trace_unhandled
-{
-    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
-	$common_pid, $common_comm) = @_;
-
-    $unhandled{$event_name}++;
-}
