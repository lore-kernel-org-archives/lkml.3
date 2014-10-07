Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaJGVRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:17:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:42971 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbaJGVRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:17:01 -0400
Message-Id: <20141007211700.052451355@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 07 Oct 2014 17:16:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 2/4] ktest: add ability to skip during BISECT_MANUAL
References: <20141007211631.365194240@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ktest-add-ability-to-skip-during-BISECT_MANUAL.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris J Arges <chris.j.arges@canonical.com>

When doing a manual bisect, a build can fail or a test can be inconclusive.
In these cases it would be helpful to be able to skip the test entirely.

Link: http://lkml.kernel.org/r/1409164021-2136-1-git-send-email-chris.j.arges@canonical.com

Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 3b7a180d9c0d..085452fa045b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2338,15 +2338,17 @@ sub success {
 
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
2.0.1


