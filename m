Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3LSNJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:09:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3LSLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/208] usbnet: fix status interrupt urb handling
Date: Thu, 19 Dec 2013 11:51:49 +0000
Message-Id: <1387454106-19326-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 52f48d0d9aaa621ffa5e08d79da99a3f8c93b848 upstream.

Since commit 7b0c5f21f348a66de495868b8df0284e8dfd6bbf
"sierra_net: keep status interrupt URB active", sierra_net triggers
status interrupt polling before the net_device is opened (in order to
properly receive the sync message response).

To be able to receive further interrupts, the interrupt urb needs to be
re-submitted, so this patch removes the bogus check for netif_running().

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/usbnet.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 06ee82f..28f16ed 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -206,9 +206,6 @@ static void intr_complete (struct urb *urb)
 		break;
 	}
 
-	if (!netif_running (dev->net))
-		return;
-
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status != 0)
 		netif_err(dev, timer, dev->net,
-- 
1.8.3.2

