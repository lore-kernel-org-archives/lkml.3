Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaFTUEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:04:53 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:41512 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaFTUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:04:52 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] checkpatch.pl: Also suggest 'else if' when if follows brace
Date: Fri, 20 Jun 2014 22:04:25 +0200
Message-Id: <1403294665-18344-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might help a kernel hacker think twice before blindly adding a
newline.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..e1924eb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3601,7 +3601,7 @@ sub process {
 # if should not continue a brace
 		if ($line =~ /}\s*if\b/) {
 			ERROR("TRAILING_STATEMENTS",
-			      "trailing statements should be on next line\n" .
+			      "trailing statements should be on next line (or did you mean 'else if'?)\n" .
 				$herecurr);
 		}
 # case and default should not have general statements after them
-- 
1.9.2

