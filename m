Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaDXQLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:11:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:20211 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758711AbaDXQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:52 -0400
Message-Id: <20140424160850.605723925@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [for-next][PATCH 2/7] ktest: Some cleanup for improving readability
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ktest-Some-cleanup-for-improving-readability.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <satoru.takeuchi@gmail.com>

Some cleanup for improving readability as follows.

  - Initialize $ktest_config at its definition.
  - Put parentheses around the `config-file' argument in the usage message
    because it's a optional one.
  - Rename get_ktest_config{,s} to more descriptive get_mandatory_config{,s}.

Link: http://lkml.kernel.org/r/87fvmr30kb.wl%satoru.takeuchi@gmail.com

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f731ef6..c34f0de 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -72,7 +72,7 @@ my %default = (
     "IGNORE_UNUSED"		=> 0,
 );
 
-my $ktest_config;
+my $ktest_config = "ktest.conf";
 my $version;
 my $have_version = 0;
 my $machine;
@@ -521,7 +521,7 @@ sub read_ync {
     return read_prompt 1, $prompt;
 }
 
-sub get_ktest_config {
+sub get_mandatory_config {
     my ($config) = @_;
     my $ans;
 
@@ -552,29 +552,29 @@ sub get_ktest_config {
     }
 }
 
-sub get_ktest_configs {
-    get_ktest_config("MACHINE");
-    get_ktest_config("BUILD_DIR");
-    get_ktest_config("OUTPUT_DIR");
+sub get_mandatory_configs {
+    get_mandatory_config("MACHINE");
+    get_mandatory_config("BUILD_DIR");
+    get_mandatory_config("OUTPUT_DIR");
 
     if ($newconfig) {
-	get_ktest_config("BUILD_OPTIONS");
+	get_mandatory_config("BUILD_OPTIONS");
     }
 
     # options required for other than just building a kernel
     if (!$buildonly) {
-	get_ktest_config("POWER_CYCLE");
-	get_ktest_config("CONSOLE");
+	get_mandatory_config("POWER_CYCLE");
+	get_mandatory_config("CONSOLE");
     }
 
     # options required for install and more
     if ($buildonly != 1) {
-	get_ktest_config("SSH_USER");
-	get_ktest_config("BUILD_TARGET");
-	get_ktest_config("TARGET_IMAGE");
+	get_mandatory_config("SSH_USER");
+	get_mandatory_config("BUILD_TARGET");
+	get_mandatory_config("TARGET_IMAGE");
     }
 
-    get_ktest_config("LOCALVERSION");
+    get_mandatory_config("LOCALVERSION");
 
     return if ($buildonly);
 
@@ -582,7 +582,7 @@ sub get_ktest_configs {
 
     if (!defined($rtype)) {
 	if (!defined($opt{"GRUB_MENU"})) {
-	    get_ktest_config("REBOOT_TYPE");
+	    get_mandatory_config("REBOOT_TYPE");
 	    $rtype = $entered_configs{"REBOOT_TYPE"};
 	} else {
 	    $rtype = "grub";
@@ -590,16 +590,16 @@ sub get_ktest_configs {
     }
 
     if ($rtype eq "grub") {
-	get_ktest_config("GRUB_MENU");
+	get_mandatory_config("GRUB_MENU");
     }
 
     if ($rtype eq "grub2") {
-	get_ktest_config("GRUB_MENU");
-	get_ktest_config("GRUB_FILE");
+	get_mandatory_config("GRUB_MENU");
+	get_mandatory_config("GRUB_FILE");
     }
 
     if ($rtype eq "syslinux") {
-	get_ktest_config("SYSLINUX_LABEL");
+	get_mandatory_config("SYSLINUX_LABEL");
     }
 }
 
@@ -1089,7 +1089,7 @@ sub read_config {
     $test_case = __read_config $config, \$test_num;
 
     # make sure we have all mandatory configs
-    get_ktest_configs;
+    get_mandatory_configs;
 
     # was a test specified?
     if (!$test_case) {
@@ -3858,7 +3858,7 @@ sub make_warnings_file {
     success $i;
 }
 
-$#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl config-file\n";
+$#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl [config-file]\n";
 
 if ($#ARGV == 0) {
     $ktest_config = $ARGV[0];
@@ -3868,8 +3868,6 @@ if ($#ARGV == 0) {
 	    exit 0;
 	}
     }
-} else {
-    $ktest_config = "ktest.conf";
 }
 
 if (! -f $ktest_config) {
-- 
1.8.5.3


