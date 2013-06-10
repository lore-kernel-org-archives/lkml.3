Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3FJWWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:22:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51894 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754256Ab3FJWWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:22:33 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] checkpatch: Move test for space before semicolon after operator spacing
Date: Mon, 10 Jun 2013 15:20:50 -0700
Message-Id: <fa92d99b165b46fc2a7283b1e80f4da9ee1f4dc0.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving this test allows the --fix option to work better.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9696be5..5989415 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2646,16 +2646,6 @@ sub process {
 			}
 		}
 
-# check for whitespace before a non-naked semicolon
-		if ($line =~ /^\+.*\S\s+;/) {
-			if (WARN("SPACING",
-				 "space prohibited before semicolon\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$linenr - 1] =~
-				    s/^(\+.*\S)\s+;/$1;/;
-			}
-		}
-
 # Check operator spacing.
 		if (!($line=~/\#\s*include/)) {
 			my $fixed_line = "";
@@ -2920,6 +2910,16 @@ sub process {
 
 		}
 
+# check for whitespace before a non-naked semicolon
+		if ($line =~ /^\+.*\S\s+;/) {
+			if (WARN("SPACING",
+				 "space prohibited before semicolon\n" . $herecurr) &&
+			    $fix) {
+				1 while $fixed[$linenr - 1] =~
+				    s/^(\+.*\S)\s+;/$1;/;
+			}
+		}
+
 # check for multiple assignments
 		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
 			CHK("MULTIPLE_ASSIGNMENTS",
-- 
1.8.1.2.459.gbcd45b4.dirty

