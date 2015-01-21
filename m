Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbbAURBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:01:55 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:46839 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbbAURBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:01:46 -0500
From: Sergey Dyasly <dserrg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergey Dyasly <dserrg@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v2] checkpatch: add check for the buggy while_each_thread()
Date: Wed, 21 Jan 2015 20:01:22 +0300
Message-Id: <1421859682-7047-1-git-send-email-dserrg@gmail.com>
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
Changes since v1:
- Added "\s*" to the regular expression
- Limited commit id to 12 digits
- "Prefer to use" --> "Consider using"
- Moved check to the end of the file

 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..d48f7b2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5259,6 +5259,12 @@ sub process {
 				}
 			}
 		}
+
+# Check for the buggy while_each_thread()
+		if ($line =~ /\bwhile_each_thread\s*\(/) {
+			WARN("WHILE_EACH_THREAD",
+			     "Consider using for_each_thread() instead of the buggy while_each_thread(). See commit 0c740d0afc3b for details.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
2.2.2

