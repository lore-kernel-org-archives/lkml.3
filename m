Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3AXDoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:44:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3AXD2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 12/74] USB: Increase reset timeout.
Date: Thu, 24 Jan 2013 01:26:24 -0200
Message-Id: <1358998046-613-13-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index ba01327..0b408c6 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2390,7 +2390,7 @@ static unsigned hub_is_wusb(struct usb_hub *hub)
 #define HUB_SHORT_RESET_TIME	10
 #define HUB_BH_RESET_TIME	50
 #define HUB_LONG_RESET_TIME	200
-#define HUB_RESET_TIMEOUT	500
+#define HUB_RESET_TIMEOUT	800
 
 static int hub_port_reset(struct usb_hub *hub, int port1,
 			struct usb_device *udev, unsigned int delay, bool warm);
-- 
1.7.9.5

