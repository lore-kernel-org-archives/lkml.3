Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3AZTYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 14:24:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40492 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754060Ab3AZTYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 14:24:21 -0500
Message-ID: <1359228259.2079.30.camel@joe-AO722>
Subject: [PATCH] gro: Fix kcalloc argument order
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 26 Jan 2013 11:24:19 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First number, then size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/gro_cells.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/gro_cells.h b/include/net/gro_cells.h
index e5062c9..734d9b5 100644
--- a/include/net/gro_cells.h
+++ b/include/net/gro_cells.h
@@ -73,8 +73,8 @@ static inline int gro_cells_init(struct gro_cells *gcells, struct net_device *de
 	int i;
 
 	gcells->gro_cells_mask = roundup_pow_of_two(netif_get_num_default_rss_queues()) - 1;
-	gcells->cells = kcalloc(sizeof(struct gro_cell),
-				gcells->gro_cells_mask + 1,
+	gcells->cells = kcalloc(gcells->gro_cells_mask + 1,
+				sizeof(struct gro_cell),
 				GFP_KERNEL);
 	if (!gcells->cells)
 		return -ENOMEM;


