Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3AOWfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:43327 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab3AOWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:34:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Covici <covici@ccs.covici.com>
Subject: [ 174/221] USB: Increase reset timeout.
Date: Tue, 15 Jan 2013 10:51:41 -0800
Message-Id: <20130115185010.616823613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2460,7 +2460,7 @@ static unsigned hub_is_wusb(struct usb_h
 #define HUB_SHORT_RESET_TIME	10
 #define HUB_BH_RESET_TIME	50
 #define HUB_LONG_RESET_TIME	200
-#define HUB_RESET_TIMEOUT	500
+#define HUB_RESET_TIMEOUT	800
 
 static int hub_port_reset(struct usb_hub *hub, int port1,
 			struct usb_device *udev, unsigned int delay, bool warm);


