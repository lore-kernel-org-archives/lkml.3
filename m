Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3HZH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:58:36 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:50274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HZH6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:58:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] debugfs: provide debugfs_create_x64() when disabled
Date: Mon, 26 Aug 2013 09:58:30 +0200
Message-Id: <1377503910-6919-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 15b0beaa332b3923cc ("Add x64 support to debugfs") added
debugfs_create_x64(), but forgot to provide it when debugfs is
disabled, causing problems when code tries to use it even then.
Provide the appropriate static inline.

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/debugfs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index d68b4ea..263489d 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -192,6 +192,13 @@ static inline struct dentry *debugfs_create_x32(const char *name, umode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_x64(const char *name, umode_t mode,
+						struct dentry *parent,
+						u64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_size_t(const char *name, umode_t mode,
 				     struct dentry *parent,
 				     size_t *value)
-- 
1.8.4.rc3

