Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaI2WVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:21:03 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaI2WU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:20:59 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL shutdown
Date: Tue, 30 Sep 2014 00:20:45 +0200
Message-Id: <1412029248-22454-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412029248-22454-1-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
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
index 20f491713..dc01b1f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -2029,6 +2029,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 void ubi_wl_close(struct ubi_device *ubi)
 {
 	dbg_wl("close the WL sub-system");
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	flush_work(&ubi->fm_work);
+#endif
 	cancel_pending(ubi);
 	protection_queue_destroy(ubi);
 	tree_destroy(&ubi->used);
-- 
2.1.0

