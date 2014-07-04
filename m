Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031028AbaGDWYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:24:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870AbaGDWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:23:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 43/46] Documentation/SubmittingPatches: describe the Fixes: tag
Date: Fri,  4 Jul 2014 15:19:47 -0700
Message-Id: <20140704221604.254046699@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit 8401aa1f59975c03eeebd3ac6d264cbdfe9af5de upstream.

Update the SubmittingPatches process to include howto about the new
'Fixes:' tag to be used when a patch fixes an issue in a previous commit
(found by git-bisect for example).

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/SubmittingPatches |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -131,6 +131,20 @@ If you cannot condense your patch set in
 then only post say 15 or so at a time and wait for review and integration.
 
 
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
 
 4) Style check your changes.
 
@@ -420,7 +434,7 @@ person it names.  This tag documents tha
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -475,6 +489,12 @@ idea was not posted in a public forum. T
 idea reporters, they will, hopefully, be inspired to help us again in the
 future.
 
+A Fixes: tag indicates that the patch fixes an issue in a previous commit. It
+is used to make it easy to determine where a bug originated, which can help
+review a bug fix. This tag also assists the stable kernel team in determining
+which stable kernel versions should receive your fix. This is the preferred
+method for indicating a bug fixed by the patch. See #2 above for more details.
+
 
 15) The canonical patch format
 


