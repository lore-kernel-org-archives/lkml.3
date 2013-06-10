Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3FJWWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:22:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51060 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754318Ab3FJWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:59 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] checkpatch: Don't warn on blank lines before/after braces as often
Date: Mon, 10 Jun 2013 15:20:46 -0700
Message-Id: <5ecb8652e185176a1b21afcd041ee10e1de06868.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check to make sure the blank lines aren't comment lines like:

bool foo(bool bar)
{
	/* Don't warn on a leading comment */
	return !bar;
	/* Don't warn on a trailing comment either */
}

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4ad4052..c43be81 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3258,11 +3258,11 @@ sub process {
 		}
 
 # check for unnecessary blank lines around braces
-		if (($line =~ /^.\s*}\s*$/ && $prevline =~ /^.\s*$/)) {
+		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
 		}
-		if (($line =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
+		if (($rawline =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

