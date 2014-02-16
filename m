Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBPU3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:29:43 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:40992 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaBPU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:29:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVACEfAVNbsll+/2dsb2JhbABZKIJegkJ9E7xuAgKBDxd0glMTHCMYgQI3iAkBykOPAR2EIgEDiUaOZQGSI4M6Lw
Date: Sun, 16 Feb 2014 20:31:01 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs: xattr: Don't display attributes without read access
Message-Id: <20140216203101.bf432a8b7b40703197a91462@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any user can display extented attribute names without read
access.

eg: attr -l <filename>

This patch checks inode_permission in listxattr common
function before executing vfs_listxattr.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 3377dff..d26b280 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -543,6 +543,10 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	char *klist = NULL;
 	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
 
+	error = inode_permission(d->d_inode, MAY_READ);
+	if (error)
+		return error;
+
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
-- 
1.8.1.4

