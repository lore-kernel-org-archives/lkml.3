Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbaELCPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:15:33 -0400
Received: from 1wt.eu ([62.212.114.60]:34440 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbaELBl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:58 -0400
Message-Id: <20140512003202.419117768@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Korsgaard <peter@korsgaard.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 043/143] dm9601: fix IFF_ALLMULTI handling
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

[ Upstream commit bf0ea6380724beb64f27a722dfc4b0edabff816e ]

Pass-all-multicast is controlled by bit 3 in RX control, not bit 2
(pass undersized frames).

Reported-by: Joseph Chang <joseph_chang@davicom.com.tw>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/usb/dm9601.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 9a6eede..498681a 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -382,7 +382,7 @@ static void dm9601_set_multicast(struct net_device *net)
 	if (net->flags & IFF_PROMISC) {
 		rx_ctl |= 0x02;
 	} else if (net->flags & IFF_ALLMULTI || net->mc_count > DM_MAX_MCAST) {
-		rx_ctl |= 0x04;
+		rx_ctl |= 0x08;
 	} else if (net->mc_count) {
 		struct dev_mc_list *mc_list = net->mc_list;
 		int i;
-- 
1.7.12.2.21.g234cd45.dirty



