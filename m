Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3J2SJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3J2SJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Korsgaard <peter@korsgaard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 50/81] dm9601: fix IFF_ALLMULTI handling
Date: Tue, 29 Oct 2013 11:04:11 -0700
Message-Id: <1383069882-11437-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

[ Upstream commit bf0ea6380724beb64f27a722dfc4b0edabff816e ]

Pass-all-multicast is controlled by bit 3 in RX control, not bit 2
(pass undersized frames).

Reported-by: Joseph Chang <joseph_chang@davicom.com.tw>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/dm9601.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index d7e9944..c929122 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -303,7 +303,7 @@ static void dm9601_set_multicast(struct net_device *net)
 		rx_ctl |= 0x02;
 	} else if (net->flags & IFF_ALLMULTI ||
 		   netdev_mc_count(net) > DM_MAX_MCAST) {
-		rx_ctl |= 0x04;
+		rx_ctl |= 0x08;
 	} else if (!netdev_mc_empty(net)) {
 		struct netdev_hw_addr *ha;
 
-- 
1.8.1.2

