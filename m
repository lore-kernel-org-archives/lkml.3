Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3FJWVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55824 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575Ab3FJWVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:18 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] checkpatch: Warn when networking block comment lines don't start with *
Date: Mon, 10 Jun 2013 15:20:41 -0700
Message-Id: <3abbc63b78a1eb970695f98a6239a1081a2cebb2.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some block comments in network are written as:

	/* block comment line 1
	   block comment line 2
	 */

Emit a warning on the "block comment line 2" because it should be

	/* block comment line 1
	 * block comment line 2
	 */

This warning is only emitted on the second line of a block comment.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3922d0..576139a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1898,6 +1898,14 @@ sub process {
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $prevrawline =~ /^\+[ \t]*\/\*/ &&		#starting /*
+		    $prevrawline !~ /\*\/[ \t]*$/ &&		#no trailing */
+		    $rawline !~ /^\+[ \t]*\*/) {		#no leading *
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments start with * on subsequent lines\n" . $hereprev);
+		}
+
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
-- 
1.8.1.2.459.gbcd45b4.dirty

