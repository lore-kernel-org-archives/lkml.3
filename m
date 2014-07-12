Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaGLTZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:25:13 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:46359 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaGLTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:25:10 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] scripts/get_maintainer: increase threshold for --follow to reduce time
Date: Sat, 12 Jul 2014 15:25:28 -0400
Message-Id: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_maintainer tries to follow files with a matching threshold of default 50%.
This is not really necessary as we do not change a file and move it in the same
commit usually. Increasing the threshold to 90% should be sufficient.

I encountered this on a recent commit where I was touching 12 files. Time take
dropped from 24 sec to 12 sec after this change. It can be reduced further by
increasing the threshold, but I think 90% is sufficient.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 scripts/get_maintainer.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index d701627..bc4a69e 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -98,7 +98,7 @@ my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-e ".git")',
     "find_signers_cmd" =>
-	"git log --no-color --follow --since=\$email_git_since " .
+	"git log --no-color --follow -M90 --since=\$email_git_since " .
 	    '--numstat --no-merges ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
-- 
1.9.1

