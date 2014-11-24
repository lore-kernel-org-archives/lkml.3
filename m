Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaKXNWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:22:52 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaKXNUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:47 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done upon WL shutdown
Date: Mon, 24 Nov 2014 14:20:33 +0100
Message-Id: <1416835236-25185-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1416835236-25185-1-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...otherwise the deferred work might run after datastructures
got freed and corrupt memory.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7f135df..cb2e571 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 void ubi_wl_close(struct ubi_device *ubi)
 {
 	dbg_wl("close the WL sub-system");
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	flush_work(&ubi->fm_work);
+#endif
 	shutdown_work(ubi);
 	protection_queue_destroy(ubi);
 	tree_destroy(&ubi->used);
-- 
1.8.4.5

