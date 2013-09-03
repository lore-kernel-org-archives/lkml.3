Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab3ICQg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:36:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3ICQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/58] can: pcan_usb: fix wrong memcpy() bytes length
Date: Tue,  3 Sep 2013 09:23:11 -0700
Message-Id: <1378225442-20654-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 3c322a56b01695df15c70bfdc2d02e0ccd80654e upstream.

Fix possibly wrong memcpy() bytes length since some CAN records received from
PCAN-USB could define a DLC field in range [9..15].
In that case, the real DLC value MUST be used to move forward the record pointer
but, only 8 bytes max. MUST be copied into the data field of the struct
can_frame object of the skb given to the network core.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 25723d8..925ab8e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -649,7 +649,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, rec_len);
+		memcpy(cf->data, mc->ptr, cf->can_dlc);
 		mc->ptr += rec_len;
 	}
 
-- 
1.8.1.2

