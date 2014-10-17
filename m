Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaJQOfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaJQOfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:35:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] scripts, checkpatch.pl, provide a better output message for commit id format errors
Date: Fri, 17 Oct 2014 10:34:55 -0400
Message-Id: <1413556495-12965-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I put together a patch with an incorrect format and the following error
was returned by checkpatch.pl:

ERROR: Please use 12 or more chars for the git commit ID like: 'Commit
09ec54429c6d ("clocksource: Move cycle_last validation to core code")'
Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108, clocksource: Move

The message is confusing.  Change it to request that the author use the
example commit ID format.

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..68312fa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2174,7 +2174,7 @@ sub process {
 			my $desc = 'commit description';
 		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
 			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			      "Please format the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
 		}
 
 # Check for added, moved or deleted files
-- 
1.7.9.3

