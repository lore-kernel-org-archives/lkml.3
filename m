Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaJGVR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:17:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17116 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754244AbaJGVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:17:04 -0400
Message-Id: <20141007211700.360345914@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 07 Oct 2014 17:16:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] ktest: Dont bother with bisect good or bad on replay
References: <20141007211631.365194240@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ktest-Don-t-bother-with-bisect-good-or-bad-on-replay.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If git bisect reply is being used in the bisect tests, don't bother
doing the git bisect good or git bisect bad calls. The git bisect
reply will override them anyway, and that's called immediately
after the other two. Going the git bisect (good|bad) is just a
waste of time.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c518b0fb6d01..bf1398180785 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2736,15 +2736,17 @@ sub bisect {
     run_command "git bisect start$start_files" or
 	dodie "could not start bisect";
 
-    run_command "git bisect good $good" or
-	dodie "could not set bisect good to $good";
-
-    run_git_bisect "git bisect bad $bad" or
-	dodie "could not set bisect bad to $bad";
-
     if (defined($replay)) {
 	run_command "git bisect replay $replay" or
 	    dodie "failed to run replay";
+    } else {
+
+	run_command "git bisect good $good" or
+	    dodie "could not set bisect good to $good";
+
+	run_git_bisect "git bisect bad $bad" or
+	    dodie "could not set bisect bad to $bad";
+
     }
 
     if (defined($start)) {
-- 
2.0.1


