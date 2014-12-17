Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaLQHgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:36:13 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63907 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaLQHgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:36:12 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch: enable MAINTAINERS warning only for --strict,--subjective
Date: Tue, 16 Dec 2014 23:35:32 -0800
Message-Id: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rule which delivers this warning is very prone to errors:

  "added, moved or deleted file(s), does MAINTAINERS need updating?"

so it should not be enabled by default.

The current checkpatch rule doesn't check:
 1. whether other patches in the same series update MAINTAINERS
 2. whether MAINTAINERS already contains a sufficient entry (e.g., with
    an appropriate wildcard pattern)

Given that #1 is impossible to fix and #2 is highly subjective (what's
"appropriate"? is the subsystem maintainer fine with maintaining a new
small driver? or should the driver author be adding himself/herself for
a niche driver?), I'd be just as happy to remove this rule entirely.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d60c07b..7057d1f54947 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2189,7 +2189,7 @@ sub process {
 		}
 
 # Check for added, moved or deleted files
-		if (!$reported_maintainer_file && !$in_commit_log &&
+		if ($check && !$reported_maintainer_file && !$in_commit_log &&
 		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
 		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
 		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
-- 
1.9.1

