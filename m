Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3KAFrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:47:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50426 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KAFrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:47:06 -0400
X-IronPort-AV: E=Sophos;i="4.93,614,1378828800"; 
   d="scan'208";a="8918695"
Message-ID: <52733FE1.5020405@cn.fujitsu.com>
Date: Fri, 01 Nov 2013 13:45:05 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>,
        Russell King <rmk+kernel@arm.linux.org.uk>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] DRM: Armada: convert to use simple_open()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 13:45:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 13:45:14,
	Serialize complete at 2013/11/01 13:45:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes an open coded simple_open() function and replaces file
operations references to the function with simple_open() instead.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/gpu/drm/armada/armada_debugfs.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_debugfs.c b/drivers/gpu/drm/armada/armada_debugfs.c
index 612f375..471e456 100644
--- a/drivers/gpu/drm/armada/armada_debugfs.c
+++ b/drivers/gpu/drm/armada/armada_debugfs.c
@@ -95,15 +95,9 @@ static int armada_debugfs_write(struct file *file, const char __user *ptr,
 	return len;
 }
 
-static int armada_debugfs_reg_w_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static const struct file_operations fops_reg_w = {
 	.owner = THIS_MODULE,
-	.open = armada_debugfs_reg_w_open,
+	.open = simple_open,
 	.write = armada_debugfs_write,
 	.llseek = noop_llseek,
 };
-- 
1.8.3.1
