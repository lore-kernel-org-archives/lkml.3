Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab3CRWHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:07:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37607 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab3CRWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:06:48 -0400
X-Sasl-enc: +cY4kJEeQti0d2awD6xdkeQDRdSW7RhF3IlZ23pU7iTF 1363644408
From: Alan Ott <alan@signal11.us>
To: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 4/4] mrf24j40: Fix byte-order of IEEE address
Date: Mon, 18 Mar 2013 18:06:43 -0400
Message-Id: <1363644403-11003-5-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1363644403-11003-1-git-send-email-alan@signal11.us>
References: <1363644403-11003-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load the 64-bit Extended (IEEE) address into the hardware in the proper
byte order.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index b4f9b67..0ca8f88 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -478,7 +478,7 @@ static int mrf24j40_filter(struct ieee802154_dev *dev,
 		int i;
 		for (i = 0; i < 8; i++)
 			write_short_reg(devrec, REG_EADR0+i,
-					filt->ieee_addr[i]);
+					filt->ieee_addr[7-i]);
 
 #ifdef DEBUG
 		printk(KERN_DEBUG "Set long addr to: ");
-- 
1.7.11.2

