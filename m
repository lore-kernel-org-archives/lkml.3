Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3GOVSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:18:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:43181 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3GOVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:18:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rob Landley <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] Documentation: update git pull info in SubmittingPatches
Date: Mon, 15 Jul 2013 17:18:16 -0400
Message-ID: <1373923096-25674-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The info in this section was overdue for an update; it had manual
individual steps listed for collecting the information that a
pull request should contain, and no mention of having a proper
overall summary in the pull request that could be used for a
merge commit.

There are other chunks of this file that need updates to match
current git workflows, but giant wholesale updates are more likely
to get caught up in bike shedding discussions over small details,
so lets start somewhere and attack the problem piece-wise.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 6e97e73..6102da9 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -590,33 +590,32 @@ See more details on the proper patch format in the following
 references.
 
 
-16) Sending "git pull" requests  (from Linus emails)
-
-Please write the git repo address and branch name alone on the same line
-so that I can't even by mistake pull from the wrong branch, and so
-that a triple-click just selects the whole thing.
-
-So the proper format is something along the lines of:
-
-	"Please pull from
-
-		git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
-
-	 to get these changes:"
-
-so that I don't have to hunt-and-peck for the address and inevitably
-get it wrong (actually, I've only gotten it wrong a few times, and
-checking against the diffstat tells me when I get it wrong, but I'm
-just a lot more comfortable when I don't have to "look for" the right
-thing to pull, and double-check that I have the right branch-name).
-
-
-Please use "git diff -M --stat --summary" to generate the diffstat:
-the -M enables rename detection, and the summary enables a summary of
-new/deleted or renamed files.
-
-With rename detection, the statistics are rather different [...]
-because git will notice that a fair number of the changes are renames.
+16) Sending "git pull" requests
+
+For a long time now, the "git request-pull" command has existed,
+and gives a uniform pre-canned text with all the expected information
+within it.  Use this as the basis of your pull request e-mail, and
+prefix it with a sensible description of what the overall series
+of commits achieves.  Assume that this text will be used by the
+maintainer in their merge commit of your changes, and hence be part
+of the git history, just like the changelog of each commit.  Use
+the triple dash described above to separate the merge commit text
+in the top of your mail from the output from "git request-pull".
+
+You are strongly discouraged against manually creating your own
+pull request text.  Doing so just increases the odds of having
+a typo in the repo location, the branch name, or other missing
+information.  In addition to creating all the required text output,
+the command also validates that your commits are actually reachable
+at the specified location, ensuring you don't waste the maintainer's
+time with having to hunt around trying find the location that you
+really meant.
+
+Your mail subject should be prefixed with "[GIT PULL]" and also
+mention the subsystem it is for, and if possible a very brief
+theme of what the changes achieve, e.g.
+
+   "[GIT PULL] x86: Remove uniprocessor support"
 
 -----------------------------------
 SECTION 2 - HINTS, TIPS, AND TRICKS
-- 
1.8.1.2

