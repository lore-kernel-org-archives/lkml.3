Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaDWNsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:48:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55999 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbaDWNq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:46:59 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Al Viro <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/2] ext4: Fix up the .write callback to use new_sync_write
Date: Wed, 23 Apr 2014 16:46:46 +0300
Message-ID: <1398260806-19340-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
References: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other filesystems has been updated but ext4 has been left out and since
ext4 does not provide aio_write callback we have kernel crash in
do_sync_write()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f48a1c2838b6..708aad768199 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -587,7 +587,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read		= new_sync_read,
-	.write		= do_sync_write,
+	.write		= new_sync_write,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
-- 
1.9.2

