Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3A0Lf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 06:35:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:6612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619Ab3A0Lf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 06:35:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,546,1355126400"; 
   d="scan'208";a="195575834"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: apw@canonical.com
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH] checkpatch.pl: Fix warnings on code comments
Date: Sun, 27 Jan 2013 03:35:39 -0800
Message-Id: <1359286539-18395-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit:
commit 058806007450489bb8f457b275e5cb5c946320c1
Author: Joe Perches <joe@perches.com>
Date:   Thu Oct 4 17:13:35 2012 -0700

checkpatch: check networking specific block comment style

Produces warnings on code comments which follow the Linux coding style
guide.  While the desired code comment style for networking my differ
from the rest of the kernel, both styles should be permitted.

This patch reverts a portion of the commit to allow multi-line code
comments to use either style.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
---
 scripts/checkpatch.pl | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d2c7df..d3ffec5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1878,13 +1878,6 @@ sub process {
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
-		    $prevrawline =~ /^\+[ \t]*$/) {
-			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
-			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
-		}
-
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $rawline !~ m@^\+[ \t]*\*/[ \t]*$@ &&	#trailing */
 		    $rawline !~ m@^\+.*/\*.*\*/[ \t]*$@ &&	#inline /*...*/
 		    $rawline !~ m@^\+.*\*{2,}/[ \t]*$@ &&	#trailing **/
-- 
1.7.11.7

