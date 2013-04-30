Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab3D3H2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:28:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3D3H2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:28:47 -0400
Date: Tue, 30 Apr 2013 10:28:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] configfs: use capped length for ->store_attribute()
Message-ID: <20130430072813.GC7237@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The difference between "count" and "len" is that "len" is capped at
4095.  Changing it like this makes it match how sysfs_write_file() is
implemented.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static analysis patch.  I haven't found any store_attribute()
functions where this change makes a difference.

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 2b6cb23..1d1c41f 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -203,7 +203,7 @@ configfs_write_file(struct file *file, const char __user *buf, size_t count, lof
 	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, buffer, count);
+		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&buffer->mutex);
