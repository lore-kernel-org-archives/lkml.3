Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbbALHnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:43:45 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:51420 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:43:42 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <davem@davemloft.net>
CC: <claudiu.manoil@freescale.com>, <peter.senna@gmail.com>,
        <shemminger@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] gianfar: correct the bad expression while writing bit-pattern
Date: Mon, 12 Jan 2015 13:13:16 +0530
Message-ID: <1421048596-22639-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch correct the bad expression while writing the
bit-pattern from software's buffer to hardware registers.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 3e1a9c1..1ccca72 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1586,7 +1586,7 @@ static int gfar_write_filer_table(struct gfar_private *priv,
 		return -EBUSY;
 
 	/* Fill regular entries */
-	for (; i < MAX_FILER_IDX - 1 && (tab->fe[i].ctrl | tab->fe[i].ctrl);
+	for (; i < MAX_FILER_IDX - 1 && ( i < tab->fe[i].ctrl);
 	     i++)
 		gfar_write_filer(priv, i, tab->fe[i].ctrl, tab->fe[i].prop);
 	/* Fill the rest with fall-troughs */
-- 
1.7.11.7

