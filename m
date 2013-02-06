Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab3BFTu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:58 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50572 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3BFTuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:50 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 53/77] mtd: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:25 -0800
Message-Id: <1360179649-22465-54-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/mtdcore.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index ec794a7..61d5f56 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -349,13 +349,8 @@ int add_mtd_device(struct mtd_info *mtd)
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
 
-	do {
-		if (!idr_pre_get(&mtd_idr, GFP_KERNEL))
-			goto fail_locked;
-		error = idr_get_new(&mtd_idr, mtd, &i);
-	} while (error == -EAGAIN);
-
-	if (error)
+	i = idr_alloc(&mtd_idr, mtd, 0, 0, GFP_KERNEL);
+	if (i < 0)
 		goto fail_locked;
 
 	mtd->index = i;
-- 
1.8.1

