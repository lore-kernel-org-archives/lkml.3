Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaAIK4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:56:17 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26792 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753528AbaAIKzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:55:25 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 6/6] usb: gadget: gr_udc: Return error code when trying to set ep.maxpacket > ep.maxpacket_limit
Date: Thu,  9 Jan 2014 11:54:18 +0100
Message-Id: <1389264858-32664-7-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make gr_ep_enable fail properly when a call requests a larger ep.maxpacket than
ep.maxpacket_limit.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/gr_udc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 55757fc..5423391 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -1548,6 +1548,10 @@ static int gr_ep_enable(struct usb_ep *_ep,
 	} else if (max == 0) {
 		dev_err(dev->dev, "Max payload cannot be set to 0\n");
 		return -EINVAL;
+	} else if (max > ep->ep.maxpacket_limit) {
+		dev_err(dev->dev, "Requested max payload %d > limit %d\n",
+			max, ep->ep.maxpacket_limit);
+		return -EINVAL;
 	}
 
 	spin_lock(&ep->dev->lock);
-- 
1.7.10.4

