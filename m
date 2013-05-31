Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3EaRpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:45:17 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44216 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3EaRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:45:14 -0400
Message-ID: <51A8E1A7.3080403@gmail.com>
Date: Fri, 31 May 2013 12:45:11 -0500
From: Jason Hrycay <jhrycay@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk.kim@samsung.com,
        jason.hrycay@motorola.com, C.Fries@motorola.com
Subject: f2fs: handle errors from get_node_page calls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add check for error pointers returned from get_node_page in order to
avoid dereferencing a bad address on the next use.

Signed-off-by: Jason Hrycay <jason.hrycay@motorola.com>
---
 fs/f2fs/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 0b02dce..ae61f35 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -218,6 +218,8 @@ int f2fs_getxattr(struct inode *inode, int
name_index, const char *name,
 		return -ENODATA;

 	page = get_node_page(sbi, fi->i_xattr_nid);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
 	base_addr = page_address(page);

 	list_for_each_xattr(entry, base_addr) {
@@ -268,6 +270,8 @@ ssize_t f2fs_listxattr(struct dentry *dentry, char
*buffer, size_t buffer_size)
 		return 0;

 	page = get_node_page(sbi, fi->i_xattr_nid);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
 	base_addr = page_address(page);

 	list_for_each_xattr(entry, base_addr) {
-- 
1.8.0
