Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3CRVIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:08:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3CRVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cristian Bercaru <B43982@freescale.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/48] bridging: fix rx_handlers return code
Date: Mon, 18 Mar 2013 14:08:52 -0700
Message-Id: <20130318210813.368298885@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3230,6 +3230,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
+			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;


