Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaDAKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:16:27 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:59498 "EHLO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaDAKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:16:25 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 7/7] usb: gadget: gr_udc: Use GFP_ATOMIC when allocating under held spinlock
Date: Tue,  1 Apr 2014 12:15:17 +0200
Message-Id: <1396347317-3861-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395933359-7109-8-git-send-email-andreas@gaisler.com>
References: <1395933359-7109-8-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As gr_ep_init must be called with dev->lock held, GFP_KERNEL must not be used.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Differences since v1: Fixed typo in commit message
 drivers/usb/gadget/gr_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 72458be..4966971 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -1990,8 +1990,8 @@ static int gr_ep_init(struct gr_udc *dev, int num, int is_in, u32 maxplimit)
 	INIT_LIST_HEAD(&ep->queue);
 
 	if (num == 0) {
-		_req = gr_alloc_request(&ep->ep, GFP_KERNEL);
-		buf = devm_kzalloc(dev->dev, PAGE_SIZE, GFP_DMA | GFP_KERNEL);
+		_req = gr_alloc_request(&ep->ep, GFP_ATOMIC);
+		buf = devm_kzalloc(dev->dev, PAGE_SIZE, GFP_DMA | GFP_ATOMIC);
 		if (!_req || !buf) {
 			/* possible _req freed by gr_probe via gr_remove */
 			return -ENOMEM;
-- 
1.7.10.4

