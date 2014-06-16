Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbaFPSQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:16:55 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:48133 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaFPSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:16:53 -0400
X-CheckPoint: {539F3494-B-2100090A-C0000000}
Message-ID: <201406161816.s5GIGptF028053@farm-0039.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 16 Jun 2014 13:14:05 -0400
Subject: [PATCH v2] net: tile: fix unused variable warning
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tobias Klauser <tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'i' is unused in tile_net_dev_init() after commit d581ebf5a1f
("net: tile: Use helpers from linux/etherdevice.h to check/set MAC").

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
v2: includes previous commit's summary line as suggested by Sergei Shtylyov.

 drivers/net/ethernet/tile/tilegx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 14389f841d43..4c70360967c2 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -2191,7 +2191,6 @@ static void tile_net_setup(struct net_device *dev)
 static void tile_net_dev_init(const char *name, const uint8_t *mac)
 {
 	int ret;
-	int i;
 	struct net_device *dev;
 	struct tile_net_priv *priv;
 
-- 
1.8.3.1

