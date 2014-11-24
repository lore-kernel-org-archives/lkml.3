Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaKXPoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:44:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:55533 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170AbaKXPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:34 -0500
Message-Id: <20141124154332.253784964@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/5] ktest: Add name to running title
References: <20141124154251.345600733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ktest-Add-name-to-running-title.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of just showing the test type of test in the start of the
test, like this:

  RUNNING TEST 1 of 26 with option build defconfig

Add the name (if it is defined) as well, like this:

  RUNNING TEST 1 of 26 (arm64 aarch64-linux) with option build defconfig

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ea43dd2f2fd5..35b118a38c2f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4086,8 +4086,14 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     my $installme = "";
     $installme = " no_install" if ($no_install);
 
+    my $name = "";
+
+    if (defined($test_name)) {
+	$name = " ($test_name)";
+    }
+
     doprint "\n\n";
-    doprint "RUNNING TEST $i of $opt{NUM_TESTS} with option $test_type $run_type$installme\n\n";
+    doprint "RUNNING TEST $i of $opt{NUM_TESTS}$name with option $test_type $run_type$installme\n\n";
 
     if (defined($pre_test)) {
 	run_command $pre_test;
-- 
2.1.1


