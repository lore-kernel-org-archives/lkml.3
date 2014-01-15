Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaAOWke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaAOVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 007/166] usb: gadget: composite: reset delayed_status on reset_config
Date: Wed, 15 Jan 2014 13:50:21 -0800
Message-Id: <1389822780-4729-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 2bac51a1827a18821150ed8c9f9752c02f9c2b02 upstream.

The delayed_status value is used to keep track of status response
packets on ep0. It needs to be reset or the set_config function would
still delay the answer, if the usb device got unplugged while waiting
for setup_continue to be called.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/composite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 2a6bfe7..44fef44 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -556,6 +556,7 @@ static void reset_config(struct usb_composite_dev *cdev)
 		bitmap_zero(f->endpoints, 32);
 	}
 	cdev->config = NULL;
+	cdev->delayed_status = 0;
 }
 
 static int set_config(struct usb_composite_dev *cdev,
-- 
1.8.3.2

