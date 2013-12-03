Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3LCBj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:39:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8496 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3LCBjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:39:24 -0500
Message-ID: <529D3627.1000205@huawei.com>
Date: Tue, 3 Dec 2013 09:38:47 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: add necessary Null check in sysfs_do_create_link_sd
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While target_sd or sd are null, it won't need sysfs_put and
should return -ENOENT directly. Here add null check for
target_sd and sd.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/sysfs/symlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 3ae3f1b..d69b786 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -83,8 +83,10 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 	return 0;
 
  out_put:
-	sysfs_put(target_sd);
-	sysfs_put(sd);
+	if (target_sd)
+		sysfs_put(target_sd);
+	if (sd)
+		sysfs_put(sd);
 	return error;
 }
 
-- 
1.8.2.2

