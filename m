Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3I1N4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:56:20 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62412 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3I1Nzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:32 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] UBI: Add some asserts to ubi_attach_fastmap()
Date: Sat, 28 Sep 2013 15:55:16 +0200
Message-Id: <1380376516-30144-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more paranioa asserts to make it easier to detect
implementation errors.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 4cfc8da..ead8613 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -826,6 +826,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list)
 		list_move_tail(&tmp_aeb->u.list, &ai->free);
 
+	ubi_assert(list_empty(&used));
+	ubi_assert(list_empty(&eba_orphans));
+	ubi_assert(list_empty(&free));
+
 	/*
 	 * If fastmap is leaking PEBs (must not happen), raise a
 	 * fat warning and fall back to scanning mode.
-- 
1.8.3.1

