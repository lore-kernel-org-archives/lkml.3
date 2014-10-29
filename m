Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbaJ2Owa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:52:30 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbaJ2Ow3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:52:29 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>
Subject: [PATCH 2/2] UBI: rename_volumes: Use UBI_METAONLY
Date: Wed, 29 Oct 2014 15:52:18 +0100
Message-Id: <1414594338-14695-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414594338-14695-1-git-send-email-richard@nod.at>
References: <1414594338-14695-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using UBI_METAONLY in rename_volumes() it is now possible to rename
an UBI volume atomically while it is mounted.
This is useful for firmware upgrades.

Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Andrew Murray <amurray@embedded-bits.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 5f01edd..fcdf7b9 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -735,7 +735,7 @@ static int rename_volumes(struct ubi_device *ubi,
 			goto out_free;
 		}
 
-		re->desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_READWRITE);
+		re->desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_METAONLY);
 		if (IS_ERR(re->desc)) {
 			err = PTR_ERR(re->desc);
 			ubi_err("cannot open volume %d, error %d", vol_id, err);
-- 
1.8.4.5

