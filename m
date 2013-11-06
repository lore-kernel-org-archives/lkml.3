Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3KFOzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:55:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932134Ab3KFOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:00 -0500
Message-Id: <20131106145257.749914926@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jamie Iles <jamie.iles@oracle.com>
Subject: [for-next][PATCH 5/8] recordmcount.pl: Add support for __fentry__
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0011-recordmcount.pl-Add-support-for-__fentry__.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Iles <jamie.iles@oracle.com>

With gcc 4.6.0 the -mfentry feature places the function profiling call
at the start of the function. When this is used, the call is to
__fentry__ and not mcount.  This is required for Ksplice as the C
version of recordmcount doesn't insert section symbols for the
__mcount_loc section so we fall back to the perl version.

Based on 48bb5dc6cd9d30fe0d594947563da1f8bd9abada (ftrace: Make
recordmcount.c handle __fentry__).
Link: http://lkml.kernel.org/r/1383648129-10724-1-git-send-email-jamie.iles@oracle.com

Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a674fd5..d0da663 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -214,13 +214,13 @@ $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;
 $type = ".long";
 
 if ($arch eq "x86_64") {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
     $mcount_adjust = -1;
-- 
1.8.4.rc3


