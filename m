Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaK3MQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:16:27 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14390 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaK3MPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:39 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] UBI: Fastmap: Make self_check_eba() depend on fastmap self checking
Date: Sun, 30 Nov 2014 13:15:27 +0100
Message-Id: <1417349728-9070-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349728-9070-1-git-send-email-richard@nod.at>
References: <1417349728-9070-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...instead of generic self checking.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 40e6bf6..9bc70eb 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1458,7 +1458,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		goto out_wl;
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
-	if (ubi->fm && ubi_dbg_chk_gen(ubi)) {
+	if (ubi->fm && ubi_dbg_chk_fastmap(ubi)) {
 		struct ubi_attach_info *scan_ai;
 
 		scan_ai = alloc_ai();
-- 
1.8.4.5

