Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaINR3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:29:49 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:44297 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaINR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:29:48 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 19:31:37 +0200
Message-Id: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 644e6ab..d4fe8ac 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -830,7 +830,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
 		char name[IFNAMSIZ];
 
 		dev->state &= ~PCAN_USB_STATE_CONNECTED;
-		strncpy(name, netdev->name, IFNAMSIZ);
+		strlcpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_netdev(netdev);
 		free_candev(netdev);
-- 
1.7.10.4

