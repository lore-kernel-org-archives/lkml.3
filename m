Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3KZIjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:39:41 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:14423 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KZIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:39:36 -0500
From: Rui Xiang <rui.xiang@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 2/2] romfs: remove an redundant if condition in romfs_readpage
Date: Tue, 26 Nov 2013 16:39:09 +0800
Message-ID: <1385455149-20752-2-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1385455149-20752-1-git-send-email-rui.xiang@huawei.com>
References: <1385455149-20752-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here ret always equals 0, so SetPageUptodate directly.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/romfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index d841878..b5e4ad4 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -129,8 +129,7 @@ static int romfs_readpage(struct file *file, struct page *page)
 
 	if (fillsize < PAGE_SIZE)
 		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
-	if (ret == 0)
-		SetPageUptodate(page);
+	SetPageUptodate(page);
 
 	flush_dcache_page(page);
 	kunmap(page);
-- 
1.8.2.2


