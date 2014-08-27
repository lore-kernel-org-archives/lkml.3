Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677AbaH0S1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:27:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbaH0S1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:27:54 -0400
From: Chris J Arges <chris.j.arges@canonical.com>
To: rostedt@goodmis.org
Cc: Chris J Arges <chris.j.arges@canonical.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ktest: add ability to skip during BISECT_MANUAL
Date: Wed, 27 Aug 2014 13:26:53 -0500
Message-Id: <1409164021-2136-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a manual bisect, a build can fail or a test can be inconclusive.
In these cases it would be helpful to be able to skip the test entirely.

Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 tools/testing/ktest/ktest.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 55ab700..72010f4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2336,15 +2336,17 @@ sub success {
 
 sub answer_bisect {
     for (;;) {
-	doprint "Pass or fail? [p/f]";
+	doprint "Pass, fail, or skip? [p/f/s]";
 	my $ans = <STDIN>;
 	chomp $ans;
 	if ($ans eq "p" || $ans eq "P") {
 	    return 1;
 	} elsif ($ans eq "f" || $ans eq "F") {
 	    return 0;
+	} elsif ($ans eq "s" || $ans eq "S") {
+	    return -1;
 	} else {
-	    print "Please answer 'P' or 'F'\n";
+	    print "Please answer 'p', 'f', or 's'\n";
 	}
     }
 }
-- 
1.9.1

