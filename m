Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3LRWUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:20:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3LRVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.4 13/31] usb: gadget: composite: reset delayed_status on reset_config
Date: Wed, 18 Dec 2013 13:08:21 -0800
Message-Id: <20131218210523.168723468@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 2bac51a1827a18821150ed8c9f9752c02f9c2b02 upstream.

The delayed_status value is used to keep track of status response
packets on ep0. It needs to be reset or the set_config function would
still delay the answer, if the usb device got unplugged while waiting
for setup_continue to be called.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/composite.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -584,6 +584,7 @@ static void reset_config(struct usb_comp
 		bitmap_zero(f->endpoints, 32);
 	}
 	cdev->config = NULL;
+	cdev->delayed_status = 0;
 }
 
 static int set_config(struct usb_composite_dev *cdev,


