Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab3CZQM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:12:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964943Ab3CZPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cristian Bercaru <B43982@freescale.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/150] bridging: fix rx_handlers return code
Date: Tue, 26 Mar 2013 15:19:04 +0000
Message-Id: <1364311249-14454-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Bercaru <B43982@freescale.com>

commit 3bc1b1add7a8484cc4a261c3e128dbe1528ce01f upstream.

The frames for which rx_handlers return RX_HANDLER_CONSUMED are no longer
counted as dropped. They are counted as successfully received by
'netif_receive_skb'.

This allows network interface drivers to correctly update their RX-OK and
RX-DRP counters based on the result of 'netif_receive_skb'.

Signed-off-by: Cristian Bercaru <B43982@freescale.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3ad746b..097dd07 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3227,6 +3227,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
+			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;
-- 
1.8.1.2

