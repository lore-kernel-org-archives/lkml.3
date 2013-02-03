Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3BCPW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:22:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab3BCOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:09 -0500
Message-Id: <20130203144644.843738847@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Covici <covici@ccs.covici.com>
Subject: [ 009/128] USB: Increase reset timeout.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 77c7f072c87fa951e9a74805febf26466f31170c upstream.

John's NEC 0.96 xHCI host controller needs a longer timeout for a warm
reset to complete.  The logs show it takes 650ms to complete the warm
reset, so extend the hub reset timeout to 800ms to be on the safe side.

This commit should be backported to kernels as old as 3.2, that contain
the commit 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore: refine
warm reset logic".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: John Covici <covici@ccs.covici.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 968ec37..b9ce5e8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2499,7 +2499,7 @@ static unsigned hub_is_wusb(struct usb_hub *hub)
 #define HUB_SHORT_RESET_TIME	10
 #define HUB_BH_RESET_TIME	50
 #define HUB_LONG_RESET_TIME	200
-#define HUB_RESET_TIMEOUT	500
+#define HUB_RESET_TIMEOUT	800
 
 static int hub_port_reset(struct usb_hub *hub, int port1,
 			struct usb_device *udev, unsigned int delay, bool warm);


