Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3FQRfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:35:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3FQRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>, Paul Taysom <taysom@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 49/84] eCryptfs: Check return of filemap_write_and_wait during fsync
Date: Mon, 17 Jun 2013 10:30:53 -0700
Message-Id: <1371490288-23167-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit bc5abcf7e411b889f73ea2a90439071a0f451011 upstream.

Error out of ecryptfs_fsync() if filemap_write_and_wait() fails.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Taysom <taysom@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ecryptfs/file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 4f9a25e..9d5dd5c 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -296,7 +296,12 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	filemap_write_and_wait(file->f_mapping);
+	int rc;
+
+	rc = filemap_write_and_wait(file->f_mapping);
+	if (rc)
+		return rc;
+
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
-- 
1.8.1.2

