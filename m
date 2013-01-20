Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3ATHno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 02:43:44 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:48247 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808Ab3ATHnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 02:43:43 -0500
Message-ID: <50FBA02C.9030203@linux-ipv6.org>
Date: Sun, 20 Jan 2013 16:43:40 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire net: Ensure checksumming in upper layer.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is wrong to set skb->ip_summed to CHECKSUM_UNNECESSARY unless
the device has already checked it.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 drivers/firewire/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index e7a711f5..df6a1ca 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -520,7 +520,7 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
 	dev = netdev_priv(net);
 	/* Write metadata, and then pass to the receive level */
 	skb->dev = net;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;  /* don't check it */
+	skb->ip_summed = CHECKSUM_NONE;
 
 	/*
 	 * Parse the encapsulation header. This actually does the job of
-- 
1.7.9.5


