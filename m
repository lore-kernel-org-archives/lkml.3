Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbAROY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:24:27 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62470 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbAROY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:24:26 -0500
From: Sergey Dyasly <dserrg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergey Dyasly <dserrg@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: add check for the buggy while_each_thread()
Date: Sun, 18 Jan 2015 17:24:00 +0300
Message-Id: <1421591040-4892-1-git-send-email-dserrg@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now it's preferable to use for_each_thread() instead of while_each_thread().
Add a check to checkpatch.pl in order to prevent any new usages of the buggy
while_each_thread() when possible.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..0c5cc0b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3255,6 +3255,12 @@ sub process {
 			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
 		}
 
+# Check for the buggy while_each_thread()
+		if ($line =~ /\bwhile_each_thread\(/) {
+			WARN("WHILE_EACH_THREAD",
+			     "Prefer to use for_each_thread() instead of the buggy while_each_thread(). See commit 0c740d0afc3bff0a097ad03a1c8df92757516f5c for details.\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
-- 
2.2.2

