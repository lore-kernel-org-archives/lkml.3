Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3FJWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45555 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575Ab3FJWVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:10 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] checkpatch: Improve network block comment test and message
Date: Mon, 10 Jun 2013 15:20:40 -0700
Message-Id: <85056c45da320a3bdb64338fce045fba36c9e7a5.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the first line of the comment after a line
with just /* to better show where the defective
comment style is in the file.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2f61b5c..a3922d0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1891,8 +1891,8 @@ sub process {
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
-		    $prevrawline =~ /^\+[ \t]*$/) {
+		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
+		    $rawline =~ /^\+[ \t]*\*/) {
 			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

