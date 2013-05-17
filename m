Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3EQIcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:32:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46178 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3EQIcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:32:20 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 16:32:18 +0800
Message-ID: <CAPgLHd8p=oOOvOsqSGFGp2DSjDg9g_manEpcNThK7Z7hirKztA@mail.gmail.com>
Subject: [PATCH -next] UBI: fix error return code in ubi_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dedekind1@gmail.com, dwmw2@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the kmem_cache_create() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/ubi/build.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 8ff08ec..a444d04 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1243,8 +1243,10 @@ static int __init ubi_init(void)
 	ubi_wl_entry_slab = kmem_cache_create("ubi_wl_entry_slab",
 					      sizeof(struct ubi_wl_entry),
 					      0, 0, NULL);
-	if (!ubi_wl_entry_slab)
+	if (!ubi_wl_entry_slab) {
+		err = -ENOMEM;
 		goto out_dev_unreg;
+	}
 
 	err = ubi_debugfs_init();
 	if (err)

