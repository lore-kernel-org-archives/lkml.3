Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbbATJhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:37:17 -0500
Received: from bes.se.axis.com ([195.60.68.10]:44062 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbATJhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:37:08 -0500
From: Niklas Cassel <niklas.cassel@axis.com>
To: <dwmw2@infradead.org>
CC: <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Niklas Cassel <niklass@axis.com>
Subject: [PATCH] mtd: update ops->oobretlen in concat_write_oob
Date: Tue, 20 Jan 2015 10:35:32 +0100
Message-ID: <1421746532-25547-1-git-send-email-niklass@axis.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In concat_read_oob both retlen and oobretlen is updated.
concat_write_oob previously only updated retlen.

Signed-off-by: Niklas Cassel <niklass@axis.com>
---
 drivers/mtd/mtdconcat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdconcat.c b/drivers/mtd/mtdconcat.c
index b900056..d85c946 100644
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -311,7 +311,8 @@ concat_write_oob(struct mtd_info *mtd, loff_t to, struct mtd_oob_ops *ops)
 			devops.len = subdev->size - to;
 
 		err = mtd_write_oob(subdev, to, &devops);
-		ops->retlen += devops.oobretlen;
+		ops->retlen += devops.retlen;
+		ops->oobretlen += devops.oobretlen;
 		if (err)
 			return err;
 
-- 
2.1.4

