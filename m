Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3BZTrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:47:14 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58502 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3BZTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:47:13 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, dwmw2@infradead.org
Subject: [PATCH] mtd: maps: Remove redundant NULL check before kfree
Date: Wed, 27 Feb 2013 01:16:56 +0530
Message-Id: <1361908016-3110-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/mtd/maps/ck804xrom.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index 586a1c7..0455166 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -308,8 +308,7 @@ static int ck804xrom_init_one(struct pci_dev *pdev,
 
  out:
 	/* Free any left over map structures */
-	if (map)
-		kfree(map);
+	kfree(map);
 
 	/* See if I have any map structures */
 	if (list_empty(&window->maps)) {
-- 
1.7.9.5

