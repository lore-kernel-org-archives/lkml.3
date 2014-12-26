Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaLZOwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:52:19 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17526 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaLZOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895452"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/27] [media] s2255drv: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:33 +0100
Message-Id: <1419604558-29743-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.function = f;
-t.data = d;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/s2255/s2255drv.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index de55e96..0f3c34d 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2274,9 +2274,7 @@ static int s2255_probe(struct usb_interface *interface,
 		dev_err(&interface->dev, "Could not find bulk-in endpoint\n");
 		goto errorEP;
 	}
-	init_timer(&dev->timer);
-	dev->timer.function = s2255_timer;
-	dev->timer.data = (unsigned long)dev->fw_data;
+	setup_timer(&dev->timer, s2255_timer, (unsigned long)dev->fw_data);
 	init_waitqueue_head(&dev->fw_data->wait_fw);
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		struct s2255_vc *vc = &dev->vc[i];

