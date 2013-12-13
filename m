Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3LMKrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:47:45 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:50318 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3LMKrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:47:43 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, balbi@ti.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] usb: musb: ux500_dma: fix potential NULL dereference error
Date: Fri, 13 Dec 2013 10:47:28 +0000
Message-Id: <1386931648-1540-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static checker warning: "drivers/usb/musb/ux500_dma.c:335
ux500_dma_controller_start()
         error: potential NULL dereference 'param_array'."

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500_dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 3700e97..9aad00f 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -336,7 +336,9 @@ static int ux500_dma_controller_start(struct ux500_dma_controller *controller)
 							    data ?
 							    data->dma_filter :
 							    NULL,
-							    param_array[ch_num]);
+							    param_array ?
+							    param_array[ch_num] :
+							    NULL);
 
 			if (!ux500_channel->dma_chan) {
 				ERR("Dma pipe allocation error dir=%d ch=%d\n",
-- 
1.8.3.2

