Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CLXxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:53:51 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:52120 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3CLXxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:53:50 -0400
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: maxin.john@enea.com, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: ipu: ipu_idmac: Fix section mismatch
Date: Tue, 12 Mar 2013 20:53:37 -0300
Message-Id: <1363132417-15273-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit 84c1e63c12 (dma: Remove erroneous __exit and __exit_p() references)
the following section mismatch happens:

WARNING: drivers/built-in.o(.text+0x20f94): Section mismatch in reference from the function ipu_remove() to the function .exit.text:ipu_idmac_exit()
The function ipu_remove() references a function in an exit section.
Often the function ipu_idmac_exit() has valid usage outside the exit section
and the fix is to remove the __exit annotation of ipu_idmac_exit.

Remove the '__exit' annotation from ipu_idmac_exit in order to fix it. 

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index d6d5d7e..d39c2cd 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1642,7 +1642,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	return dma_async_device_register(&idmac->dma);
 }
 
-static void __exit ipu_idmac_exit(struct ipu *ipu)
+static void ipu_idmac_exit(struct ipu *ipu)
 {
 	int i;
 	struct idmac *idmac = &ipu->idmac;
-- 
1.7.9.5

