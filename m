Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaGJITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:19:18 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:57383 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaGJITI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:19:08 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Subject: [PATCH v7 31/33] net: slcan - set name assign type
Date: Thu, 10 Jul 2014 10:17:36 +0200
Message-Id: <1404980258-30853-32-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Names are given by the first available SLCAN channel, so order
of device creation matters.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org
---
 drivers/net/can/slcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index acb5b92..99f2534 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -529,7 +529,7 @@ static struct slcan *slc_alloc(dev_t line)
 		return NULL;
 
 	sprintf(name, "slcan%d", i);
-	dev = alloc_netdev(sizeof(*sl), name, NET_NAME_UNKNOWN, slc_setup);
+	dev = alloc_netdev(sizeof(*sl), name, NET_NAME_ENUM, slc_setup);
 	if (!dev)
 		return NULL;
 
-- 
1.9.3

