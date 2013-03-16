Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3CQJLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 05:11:05 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55735 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3CQJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 05:11:02 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: ata: Use resource_size function
Date: Sat, 16 Mar 2013 16:32:11 +0200
Message-Id: <1363444332-379-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size function instead of explicit computation.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/ata/pata_octeon_cf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index ff2e57f..e73bef3 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -926,7 +926,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 			goto free_cf_port;
 		}
 		cs1 = devm_ioremap_nocache(&pdev->dev, res_cs1->start,
-					   res_cs1->end - res_cs1->start + 1);
+					   resource_size(res_cs1));
 
 		if (!cs1)
 			goto free_cf_port;
-- 
1.7.9.5

