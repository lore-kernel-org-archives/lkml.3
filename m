Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaGaOcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:32:39 -0400
Received: from mx02.posteo.de ([89.146.194.165]:40623 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750996AbaGaOci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:32:38 -0400
From: Martin Kepplinger <martink@posteo.de>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] mtd: use NULL instead of 0 for an address
Date: Thu, 31 Jul 2014 16:31:16 +0200
Message-Id: <1406817076-1072-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NULL instead of 0 when returning an address. This fixes a
sparse warning.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Sorry if this is only noise, I stumbled upon it and why not send it.
applies to next-20140731

 drivers/mtd/maps/pcmciamtd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index a3cfad3..af747af 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -89,7 +89,7 @@ static caddr_t remap_window(struct map_info *map, unsigned long to)
 
 	if (!pcmcia_dev_present(dev->p_dev)) {
 		pr_debug("device removed\n");
-		return 0;
+		return NULL;
 	}
 
 	offset = to & ~(dev->win_size-1);
-- 
1.7.10.4

