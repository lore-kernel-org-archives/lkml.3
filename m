Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3LCRIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:08:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22871 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754397Ab3LCRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:08:34 -0500
Message-Id: <20131203170833.244210240@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 12:07:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [for-next][PATCH 1/2] ktest: Make the signal to terminate the console configurable
References: <20131203170722.102711563@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Make-the-signal-to-terminate-the-console-confi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <satoru.takeuchi@gmail.com>

 Currently ktest sends SIGINT to terminate the console.
 However, there are consoles which do not exit by this signal, for example,
 in my case, "virsh console <guest OS>". In such case, ktest is blocked in
 close_console(). It prevents this automate test.

This patch adds new option CLOSE_CONSOLE_SIGNAL which mean the
signal to terminate the console. Since its default value is "INT",
the original behavior isn't changed.

Link: http://lkml.kernel.org/r/87zjol8pl5.wl%satoru.takeuchi@gmail.com

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0d7fd8b..5dc5704 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -25,6 +25,7 @@ my %default = (
     "TEST_TYPE"			=> "build",
     "BUILD_TYPE"		=> "randconfig",
     "MAKE_CMD"			=> "make",
+    "CLOSE_CONSOLE_SIGNAL"	=> "INT",
     "TIMEOUT"			=> 120,
     "TMP_DIR"			=> "/tmp/ktest/\${MACHINE}",
     "SLEEP_TIME"		=> 60,	# sleep time between tests
@@ -163,6 +164,7 @@ my $timeout;
 my $booted_timeout;
 my $detect_triplefault;
 my $console;
+my $close_console_signal;
 my $reboot_success_line;
 my $success_line;
 my $stop_after_success;
@@ -285,6 +287,7 @@ my %option_map = (
     "TIMEOUT"			=> \$timeout,
     "BOOTED_TIMEOUT"		=> \$booted_timeout,
     "CONSOLE"			=> \$console,
+    "CLOSE_CONSOLE_SIGNAL"	=> \$close_console_signal,
     "DETECT_TRIPLE_FAULT"	=> \$detect_triplefault,
     "SUCCESS_LINE"		=> \$success_line,
     "REBOOT_SUCCESS_LINE"	=> \$reboot_success_line,
@@ -1296,7 +1299,7 @@ sub close_console {
     my ($fp, $pid) = @_;
 
     doprint "kill child process $pid\n";
-    kill 2, $pid;
+    kill $close_console_signal, $pid;
 
     print "closing!\n";
     close($fp);
-- 
1.8.4.rc3


