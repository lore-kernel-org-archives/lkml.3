Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3JKVAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:00:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3JKThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Chang <joseph_chang@davicom.com.tw>,
        Peter Korsgaard <peter@korsgaard.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/48] dm9601: fix IFF_ALLMULTI handling
Date: Fri, 11 Oct 2013 12:36:22 -0700
Message-Id: <20131011193638.918557290@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

[ Upstream commit bf0ea6380724beb64f27a722dfc4b0edabff816e ]

Pass-all-multicast is controlled by bit 3 in RX control, not bit 2
(pass undersized frames).

Reported-by: Joseph Chang <joseph_chang@davicom.com.tw>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/dm9601.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -384,7 +384,7 @@ static void dm9601_set_multicast(struct
 		rx_ctl |= 0x02;
 	} else if (net->flags & IFF_ALLMULTI ||
 		   netdev_mc_count(net) > DM_MAX_MCAST) {
-		rx_ctl |= 0x04;
+		rx_ctl |= 0x08;
 	} else if (!netdev_mc_empty(net)) {
 		struct netdev_hw_addr *ha;
 


