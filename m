Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbbATCnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:43:11 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34897 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbATCnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:43:10 -0500
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: das1800: prefer kmalloc_array over kmalloc with multiply
Date: Mon, 19 Jan 2015 20:42:49 -0600
Message-Id: <1421721769-28482-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch doesn't like kmalloc with multiply very much:
drivers/staging/comedi/drivers/das1800.c:1377: WARNING: Prefer kmalloc_array over kmalloc with multiply

So this patch swaps that use out for kmalloc_array instead.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 381ae94..13ed31c 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1374,7 +1374,7 @@ static int das1800_attach(struct comedi_device *dev,
 	if (dev->irq & it->options[2])
 		das1800_init_dma(dev, it);
 
-	devpriv->fifo_buf = kmalloc(FIFO_SIZE * sizeof(uint16_t), GFP_KERNEL);
+	devpriv->fifo_buf = kmalloc_array(FIFO_SIZE, sizeof(uint16_t), GFP_KERNEL);
 	if (!devpriv->fifo_buf)
 		return -ENOMEM;
 
-- 
2.2.2

