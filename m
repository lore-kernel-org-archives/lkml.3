Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaCAFoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:44:06 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60117 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaCAFoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:44:04 -0500
From: vinayakm.list@gmail.com
To: rob@landley.net, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vinayak Menon <vinayakm.list@gmail.com>
Subject: [PATCH] Documentation/trace/postprocess/trace-pagealloc-postprocess.pl: fix the traceevent regex
Date: Sat,  1 Mar 2014 11:13:46 +0530
Message-Id: <1393652626-2927-1-git-send-email-vinayakm.list@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinayak Menon <vinayakm.list@gmail.com>

The script fails, when irq, preempt and lockdep fields (field 3 below)
are printed in the trace output.

Example entry:
worker/0:0-4  [000] ...1  1155.972338: mm_page_alloc:

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
---
 .../postprocess/trace-pagealloc-postprocess.pl     |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
index 0a120aa..94efc7f 100644
--- a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
@@ -84,7 +84,7 @@ my $regex_fragdetails;
 
 # Static regex used. Specified like this for readability and for use with /o
 #                      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
-my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])(\s*[dX.][Nnp.][Hhs.][0-9a-fA-F.]*|)\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
 my $regex_statname = '[-0-9]*\s\((.*)\).*';
 my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';
 
@@ -195,7 +195,7 @@ EVENT_PROCESS:
 	while ($traceevent = <STDIN>) {
 		if ($traceevent =~ /$regex_traceevent/o) {
 			$process_pid = $1;
-			$tracepoint = $4;
+			$tracepoint = $5;
 
 			if ($opt_read_procstat || $opt_prepend_parent) {
 				$process_pid =~ /(.*)-([0-9]*)$/;
@@ -215,7 +215,7 @@ EVENT_PROCESS:
 
 			# Unnecessary in this script. Uncomment if required
 			# $cpus = $2;
-			# $timestamp = $3;
+			# $timestamp = $4;
 		} else {
 			next;
 		}
@@ -236,7 +236,7 @@ EVENT_PROCESS:
 		} elsif ($tracepoint eq "mm_page_alloc_extfrag") {
 
 			# Extract the details of the event now
-			$details = $5;
+			$details = $6;
 
 			my ($page, $pfn);
 			my ($alloc_order, $fallback_order, $pageblock_order);
-- 
1.7.6

