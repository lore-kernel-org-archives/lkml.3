Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab3CYBjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33790 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab3CYBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:04 -0400
Message-Id: <20130325010525.539960339@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Cristian Bercaru <B43982@freescale.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 012/104] bridging: fix rx_handlers return code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Bercaru <B43982@freescale.com>

[ Upstream commit 3bc1b1add7a8484cc4a261c3e128dbe1528ce01f ]

The frames for which rx_handlers return RX_HANDLER_CONSUMED are no longer
counted as dropped. They are counted as successfully received by
'netif_receive_skb'.

This allows network interface drivers to correctly update their RX-OK and
RX-DRP counters based on the result of 'netif_receive_skb'.

Signed-off-by: Cristian Bercaru <B43982@freescale.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3299,6 +3299,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
+			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;


