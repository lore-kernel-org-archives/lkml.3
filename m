Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3IUJa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 05:30:26 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:56327 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3IUJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 05:30:24 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] usb: gadget: mv_u3d_core: fix memory leaks
Date: Sat, 21 Sep 2013 12:30:15 +0300
Message-Id: <1379755816-21822-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trb_hw is NULL, trb should be free'd before return.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/usb/gadget/mv_u3d_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index 561b30e..4d31177 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -310,6 +310,7 @@ static struct mv_u3d_trb *mv_u3d_build_trb_one(struct mv_u3d_req *req,
 	 */
 	trb_hw = dma_pool_alloc(u3d->trb_pool, GFP_ATOMIC, dma);
 	if (!trb_hw) {
+		kfree(trb);
 		dev_err(u3d->dev,
 			"%s, dma_pool_alloc fail\n", __func__);
 		return NULL;
@@ -454,6 +455,7 @@ static int mv_u3d_req_to_trb(struct mv_u3d_req *req)
 
 		trb_hw = kcalloc(trb_num, sizeof(*trb_hw), GFP_ATOMIC);
 		if (!trb_hw) {
+			kfree(trb);
 			dev_err(u3d->dev,
 					"%s, trb_hw alloc fail\n", __func__);
 			return -ENOMEM;
-- 
1.7.9.5

