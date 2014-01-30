Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaA3OfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:35:17 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:54014 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaA3OfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:35:16 -0500
From: Richard Genoud <richard.genoud@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] get_maintainer: Fix detection of git repository
Date: Thu, 30 Jan 2014 15:34:56 +0100
Message-Id: <1391092497-6567-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since git v1.7.7, the .git directory can be a file when, for example,
the kernel is a submodule of another git super project.
So, the check "-d .git" is not working anymore in this case.
Using a more generic check like "-e .git" corrects this behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 scripts/get_maintainer.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 9c3986f4140c..41987885bd31 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -95,7 +95,7 @@ my %VCS_cmds;
 
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
-    "available" => '(which("git") ne "") && (-d ".git")',
+    "available" => '(which("git") ne "") && (-e ".git")',
     "find_signers_cmd" =>
 	"git log --no-color --follow --since=\$email_git_since " .
 	    '--numstat --no-merges ' .
-- 
1.8.5

