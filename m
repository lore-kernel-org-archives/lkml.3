Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaIIP2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:28:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55165 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaIIP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:28:03 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: akpm@linux-foundation.org, joe@perches.com, josh@joshtriplett.org,
        robh@kernel.org
Cc: linux-kernel@vger.kernel.org, Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] scripts: checkpatch.pl add warning for dummy label
Date: Tue,  9 Sep 2014 15:54:15 +0200
Message-Id: <1410270855-6639-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added new warning DUMMY_LABEL in checkpatch.pl. This warns
if return statement is encountered just after goto label target
like "out:". In such scenario it is best to call "return;" directly
instead of "goto out;"

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 scripts/checkpatch.pl | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b602ed2..399c2b5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3798,10 +3798,14 @@ sub process {
 		if ($sline =~ /^[ \+]}\s*$/ &&
 		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
 		    $linenr >= 3 &&
-		    $lines[$linenr - 3] =~ /^[ +]/ &&
-		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
-			WARN("RETURN_VOID",
-			     "void function return statements are not generally useful\n" . $hereprev);
+		    $lines[$linenr - 3] =~ /^[ +]/) {
+			if ($lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
+				WARN("RETURN_VOID",
+				     "void function return statements are not generally useful\n" . $hereprev);
+			} elsif ($lines[$linenr - 3] =~ /^[ +]\s*$Ident\s*:/) {
+				WARN("DUMMY_LABEL",
+				     "labels doing nothing are not generally useful\n" . $hereprev);
+			}
                }
 
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
-- 
1.9.1

