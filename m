Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbaDXQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:08:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:8996 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758514AbaDXQIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:51 -0400
Message-Id: <20140424160850.450820777@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [for-next][PATCH 1/7] ktest: add 2nd parameter of run_command() to set the redirect target
 file
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ktest-add-2nd-parameter-of-run_command-to-set-the-re.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <satoru.takeuchi@gmail.com>

If we'd like to set the redirect target file of run_command(),
we should define $redirect before calling this function and should undef it
after calling this function. Since it's user-unfriendly, add 2nd parameter of
run_command() for this purpose.

Link: http://lkml.kernel.org/r/87vbvwokq8.wl%satoru.takeuchi@gmail.com

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 4063156..f731ef6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -149,7 +149,6 @@ my $bisect_ret_abort;
 my $bisect_ret_default;
 my $in_patchcheck = 0;
 my $run_test;
-my $redirect;
 my $buildlog;
 my $testlog;
 my $dmesg;
@@ -1529,7 +1528,7 @@ sub fail {
 }
 
 sub run_command {
-    my ($command) = @_;
+    my ($command, $redirect) = @_;
     my $dolog = 0;
     my $dord = 0;
     my $pid;
@@ -2265,9 +2264,7 @@ sub build {
     # Run old config regardless, to enforce min configurations
     make_oldconfig;
 
-    $redirect = "$buildlog";
-    my $build_ret = run_command "$make $build_options";
-    undef $redirect;
+    my $build_ret = run_command "$make $build_options", $buildlog;
 
     if (defined($post_build)) {
 	# Because a post build may change the kernel version
@@ -2360,9 +2357,7 @@ sub child_run_test {
     $poweroff_on_error = 0;
     $die_on_failure = 1;
 
-    $redirect = "$testlog";
-    run_command $run_test or $failed = 1;
-    undef $redirect;
+    run_command $run_test, $testlog or $failed = 1;
 
     exit $failed;
 }
-- 
1.8.5.3


