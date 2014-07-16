Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaGPKYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:24:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38701 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbaGPKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-83-53c6529c6cd4
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 12/12] usb: dwc2/gadget: avoid disabling ep0
Date: Wed, 16 Jul 2014 12:22:30 +0200
Message-id: <1405506150-16185-13-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd05QceCDRpfiFvMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKeNE8mb3gNmvFwR8/WRsY77F0MXJwSAiYSNzZEtzFyAlk
	iklcuLeerYuRi0NIYDqjxOXdJ1ggnHYmiTW7rrKDVLEJ6Ehs+T6BEcQWERCQWP/iEjtIEbPA
	CUaJjv8X2EASwgL2EjPfrGMFsVkEVCW27tsI1swr4CaxclEXI8Q6OYmTxyaD1XACxde8bgar
	ERJwlTi+bhnTBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw+uZ9A7GVQ0WhxgF
	OBiVeHg3hBwNFmJNLCuuzD3EKMHBrCTC6+B/LFiINyWxsiq1KD++qDQntfgQozQHi5I478FW
	60AhgfTEktTs1NSC1CKYLBMHp1QDY87kiRfLu1rzly6ZcW0G7w/mJR9Wfk/7Jx63d6s/j8+n
	Y8djV4av6ec2vWR+7dKxZa+V/fcvy3jCqnb8ksKhfab7WquuH3ztfYp9i/59O62pcXmfS0U4
	xW0Kd4ucj114+4+u9ard0+wrpe5/Ft68K5uxU/Lj7O1XV3Pkir+ZEeN6nvVmd4rxcS8lluKM
	REMt5qLiRACqv8EQKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Endpoint 0 should not be disabled, so we start loop counter from number 1.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 68b764e..3e4c3b9 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2930,7 +2930,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 		return -ENODEV;
 
 	/* all endpoints should be shutdown */
-	for (ep = 0; ep < hsotg->num_of_eps; ep++)
+	for (ep = 1; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
-- 
1.9.1

