Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727AbaH1KG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:06:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:50036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847AbaH1KG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:06:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,417,1406617200"; 
   d="scan'208";a="591053018"
From: Chen LinX <linx.z.chen@intel.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, "Chen, LinX" <linx.z.chen@intel.com>,
        "He, Bo" <bo.he@intel.com>
Subject: [PATCH] debugfs: keep the old valid mode value when no explicity specify it
Date: Thu, 28 Aug 2014 18:09:09 +0800
Message-Id: <1409220549-15485-1-git-send-email-linx.z.chen@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen, LinX" <linx.z.chen@intel.com>

When mount debugfs with no mode specifed after it's mounted, the mount
point mode will change to default mode(0700) even the mount operation was fail,
this will cause some issues like can't get binder info in android. Here we can
keep the old valid mode if no explicity specify the mode value and also change
the mode value even the mount fails if the mode value is specified.

Change-Id: I591ce5328e9589adfc3d7317f04276bf0033202a
Signed-off-by: He, Bo <bo.he@intel.com>
Signed-off-by: Chen, LinX <linx.z.chen@intel.com>
---
 fs/debugfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c7c83ff..f1eb4b9 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -159,7 +159,8 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
 	kgid_t gid;
 	char *p;
 
-	opts->mode = DEBUGFS_DEFAULT_MODE;
+	if (opts->mode == 0)
+		opts->mode = DEBUGFS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
 		if (!*p)
-- 
1.7.9.5

