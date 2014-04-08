Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaDHJ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:26:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:58379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbaDHJ0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,816,1389772800"; 
   d="scan'208";a="516537965"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] doc: update SubmittingPatches about the Fixes tag
Date: Tue,  8 Apr 2014 02:25:35 -0700
Message-Id: <1396949135-27122-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

This patch updates the SubmittingPatches process to include howto about
the new 'Fixed' tag to be used when a patch fixes an issue in a previous
commit (found by git-bisect for example).

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/SubmittingPatches | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 2a8e89e..7e9abb8 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -132,6 +132,20 @@ Example:
 	platform_set_drvdata(), but left the variable "dev" unused,
 	delete it.
 
+If your patch fixes a bug in a specific commit, e.g. you found an issue using
+git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
+SHA-1 ID, and the one line summary.
+Example:
+
+	Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
+
+The following git-config settings can be used to add a pretty format for
+outputting the above style in the git log or git show commands
+
+	[core]
+		abbrev = 12
+	[pretty]
+		fixes = Fixes: %h (\"%s\")
 
 3) Separate your changes.
 
@@ -443,7 +457,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -498,6 +512,12 @@ idea was not posted in a public forum. That said, if we diligently credit our
 idea reporters, they will, hopefully, be inspired to help us again in the
 future.
 
+A Fixes: tag indicates that the patch fixes an issue in a previous commit. It
+is used to make it easy to determine where a bug originated, which can help
+review a bug fix. This tag also assists the stable kernel team in determining
+which stable kernel versions should receive your fix. This is the preferred
+method for indicating a bug fixed by the patch. See #2 above for more details.
+
 
 15) The canonical patch format
 
-- 
1.9.0

