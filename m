Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaA3OfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:35:25 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:56142 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaA3OfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:35:20 -0500
From: Richard Genoud <richard.genoud@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/2] checkpatch: Fix detection of git repository
Date: Thu, 30 Jan 2014 15:34:57 +0100
Message-Id: <1391092497-6567-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1391092497-6567-1-git-send-email-richard.genoud@gmail.com>
References: <1391092497-6567-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since git v1.7.7, the .git directory can be a file when, for example,
the kernel is a submodule of another git super project.
So, the check "-d .git" is not working anymore in this case.
Using a more generic check like "-e .git" corrects this behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0ea2a1e24ade..464dcef79b35 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -471,7 +471,7 @@ sub seed_camelcase_includes {
 
 	$camelcase_seeded = 1;
 
-	if (-d ".git") {
+	if (-e ".git") {
 		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
@@ -499,7 +499,7 @@ sub seed_camelcase_includes {
 		return;
 	}
 
-	if (-d ".git") {
+	if (-e ".git") {
 		$files = `git ls-files "include/*.h"`;
 		@include_files = split('\n', $files);
 	}
-- 
1.8.5

