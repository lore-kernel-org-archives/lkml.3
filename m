Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaB1Dkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:40:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:27925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaB1Dkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:40:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="483301117"
From: Aaron Brown <aaron.f.brown@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH] doc: update SubmittingPatches about the Fixed tag
Date: Thu, 27 Feb 2014 19:37:02 -0800
Message-Id: <1393558622-1392-1-git-send-email-aaron.f.brown@intel.com>
X-Mailer: git-send-email 1.8.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

This patch updates the SubmittingPatches process to include howto about
the new 'Fixed' tag to be used when a patch fixes an issue in a previous
commit (found by git-bisect for example).

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>
---
 Documentation/SubmittingPatches | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31..88a796c 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -119,6 +119,13 @@ Example:
 	platform_set_drvdata(), but left the variable "dev" unused,
 	delete it.
 
+If your patch fixes a bug in a specific commit, e.g. you found an issue using
+git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
+SHA-1 ID, and the one line summary.
+Example:
+
+	Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
+
 
 3) Separate your changes.
 
@@ -430,7 +437,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -485,6 +492,11 @@ idea was not posted in a public forum. That said, if we diligently credit our
 idea reporters, they will, hopefully, be inspired to help us again in the
 future.
 
+A Fixes: tag indicates that the patch fixes an issue in a previous commit. It
+is used to make it easy to determine where a bug originated, which can help
+review a bug fix. This is the preferred method for indicating a bug fixed by
+the patch. See #2 above for more details.
+
 
 15) The canonical patch format
 
-- 
1.8.5.GIT

