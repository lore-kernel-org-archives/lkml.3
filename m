Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3CRWIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:08:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37607 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab3CRWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:06:47 -0400
X-Sasl-enc: 3W/1ZO+uDmxPGqjWhnIzB0z1MV87dRKD9UChBqmFxptn 1363644407
From: Alan Ott <alan@signal11.us>
To: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 2/4] mrf24j40: Warn if transmit interrupts timeout
Date: Mon, 18 Mar 2013 18:06:41 -0400
Message-Id: <1363644403-11003-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1363644403-11003-1-git-send-email-alan@signal11.us>
References: <1363644403-11003-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue a warning if a transmit complete interrupt doesn't happen in time.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 3106895..582c0a3 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -362,6 +362,7 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 	if (ret == -ERESTARTSYS)
 		goto err;
 	if (ret == 0) {
+		dev_warn(printdev(devrec), "Timeout waiting for TX interrupt\n");
 		ret = -ETIMEDOUT;
 		goto err;
 	}
-- 
1.7.11.2

