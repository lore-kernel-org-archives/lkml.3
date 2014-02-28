Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaB1Gin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:38:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:56743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaB1Gil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="491347901"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org, yanmin_zhang@linux.intel.com
Subject: [PATCH] pstore: skip zero size persistent ram buffer in traverse
Date: Fri, 28 Feb 2014 14:38:21 +0800
Message-Id: <1393569501-14952-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

In ramoops_pstore_read, a valid prz pointer with zero size buffer will
break traverse of all persistent ram buffers. The latter buffer might
be lost.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/ram.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a5d0cab..929ea55 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -119,12 +119,12 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
 
 	prz = przs[i];
 
-	if (update) {
-		/* Update old/shadowed buffer. */
+	/* Update old/shadowed buffer. */
+	if (update)
 		persistent_ram_save_old(prz);
-		if (!persistent_ram_old_size(prz))
-			return NULL;
-	}
+
+	if (!persistent_ram_old_size(prz))
+		return NULL;
 
 	*typep = type;
 	*id = i;
-- 
1.8.3.2

