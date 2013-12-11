Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3LKDD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:03:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:59371 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3LKDD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:03:26 -0500
Message-ID: <52A7D5C3.6010300@huawei.com>
Date: Wed, 11 Dec 2013 11:02:27 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <sfrench@samba.org>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] fs: cifs: new helper: file_inode(file)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 fs/cifs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 7749230..45cb59b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -85,7 +85,7 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 		goto out_fput;
 	}

-	src_inode = src_file.file->f_dentry->d_inode;
+	src_inode = file_inode(src_file.file);

 	/*
 	 * Note: cifs case is easier than btrfs since server responsible for
-- 
1.8.2.2

