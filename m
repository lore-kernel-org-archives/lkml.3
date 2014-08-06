Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaHFEoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:44:11 -0400
Received: from s87.loopia.se ([194.9.94.112]:34353 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaHFEoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:44:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 12/15] usb: musb: ux500: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:43:55 -0700
Message-Id: <1407300235-401-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/usb/musb/ux500_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 9aad00f..221faed 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -96,7 +96,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 	struct musb *musb = ux500_channel->controller->private_data;
 
 	dev_dbg(musb->controller,
-		"packet_sz=%d, mode=%d, dma_addr=0x%llu, len=%d is_tx=%d\n",
+		"packet_sz=%d, mode=%d, dma_addr=0x%llx, len=%d is_tx=%d\n",
 		packet_sz, mode, (unsigned long long) dma_addr,
 		len, ux500_channel->is_tx);
 
-- 
2.0.0.526.g5318336

