Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3HULr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:47:26 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42931 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3HULrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:47:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] usb: musb: ux500: Add check for NULL board data
Date: Wed, 21 Aug 2013 12:47:03 +0100
Message-Id: <1377085623-8773-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter's automatic Smatch checker found an anomaly in the ux500
MUSB driver, whereby board data was checked before use in all but one
occasion. It is believed that it needs to be checked every time.

Smatch complaint:
  drivers/usb/musb/ux500_dma.c:335 ux500_dma_controller_start()
         error: we previously assumed 'data' could be null (see line 313)

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500_dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index bfb7a65..679f511 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -339,7 +339,9 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 			if (!ux500_channel->dma_chan)
 				ux500_channel->dma_chan =
 					dma_request_channel(mask,
-							    data->dma_filter,
+							    data ?
+							    data->dma_filter :
+							    NULL,
 							    param_array[ch_num]);
 
 			if (!ux500_channel->dma_chan) {
-- 
1.8.1.2

