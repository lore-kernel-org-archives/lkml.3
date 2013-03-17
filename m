Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3CQGlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 02:41:49 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49389 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3CQGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 02:41:47 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-ide@vger.kernel.org
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: ata: use resource_size()
Date: Sun, 17 Mar 2013 08:41:35 +0200
Message-Id: <1363502495-22087-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the resource_size() function instead of explicit computation.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/ata/pata_octeon_cf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index ff2e57f..6f797a4 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -19,6 +19,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <scsi/scsi_host.h>
+#include <linux/ioport.h>
 
 #include <asm/byteorder.h>
 #include <asm/octeon/octeon.h>
@@ -926,7 +927,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 			goto free_cf_port;
 		}
 		cs1 = devm_ioremap_nocache(&pdev->dev, res_cs1->start,
-					   res_cs1->end - res_cs1->start + 1);
+					   resource_size(res_cs1));
 
 		if (!cs1)
 			goto free_cf_port;
-- 
1.7.9.5

