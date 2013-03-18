Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3CRWHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:07:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38864 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059Ab3CRWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:06:48 -0400
X-Sasl-enc: 3W/pfuG3FXtBHbLTgH4hHlb1MV87dRKD9UChBqmFxptn 1363644407
From: Alan Ott <alan@signal11.us>
To: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 3/4] mrf24j40: Increase max SPI speed to 10MHz
Date: Mon, 18 Mar 2013 18:06:42 -0400
Message-Id: <1363644403-11003-4-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1363644403-11003-1-git-send-email-alan@signal11.us>
References: <1363644403-11003-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon consulting the datasheet further, it does indicates a maximum speed
for SCK at 10MHz.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 582c0a3..b4f9b67 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -92,9 +92,8 @@ struct mrf24j40 {
 #define MRF24J40_READLONG(reg) (1 << 15 | (reg) << 5)
 #define MRF24J40_WRITELONG(reg) (1 << 15 | (reg) << 5 | 1 << 4)
 
-/* Maximum speed to run the device at. TODO: Get the real max value from
- * someone at Microchip since it isn't in the datasheet. */
-#define MAX_SPI_SPEED_HZ 1000000
+/* The datasheet indicates the theoretical maximum for SCK to be 10MHz */
+#define MAX_SPI_SPEED_HZ 10000000
 
 #define printdev(X) (&X->spi->dev)
 
-- 
1.7.11.2

