Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaK3MPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:15:40 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaK3MPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:37 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] UBI: Fastmap: Enhance fastmap checking
Date: Sun, 30 Nov 2014 13:15:24 +0100
Message-Id: <1417349728-9070-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349728-9070-1-git-send-email-richard@nod.at>
References: <1417349728-9070-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't update the fastmap upon detach if fastmap checking is enabled.
This is poor men's power cut testing feature. :-)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 3c999e5..12f4776 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1114,8 +1114,11 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_msg(ubi, "detaching mtd%d", ubi->mtd->index);
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	/* If we don't write a new fastmap at detach time we lose all
-	 * EC updates that have been made since the last written fastmap. */
-	ubi_update_fastmap(ubi);
+	 * EC updates that have been made since the last written fastmap.
+	 * In case of fastmap debugging we omit the update to simulate an
+	 * unclean shutdown. */
+	if (!ubi_dbg_chk_fastmap(ubi))
+		ubi_update_fastmap(ubi);
 #endif
 	/*
 	 * Before freeing anything, we have to stop the background thread to
-- 
1.8.4.5

