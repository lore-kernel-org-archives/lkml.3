Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbbAMF3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:29:09 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:61612 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbAMF3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:29:08 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <davem@davemloft.net>
CC: <claudiu.manoil@freescale.com>, <peter.senna@gmail.com>,
        <shemminger@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2] gianfar: correct the bad expression while writing bit-pattern
Date: Tue, 13 Jan 2015 10:58:58 +0530
Message-ID: <1421126938-16268-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <54B3D63B.1010608@cogentembedded.com>
References: <54B3D63B.1010608@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch correct the bad expression while writing the
bit-pattern from software's buffer to hardware registers.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
Changes in v2:
  - incorporated review comment as per Sergei. 

 drivers/net/ethernet/freescale/gianfar_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 3e1a9c1..347d5ee 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1586,7 +1586,7 @@ static int gfar_write_filer_table(struct gfar_private *priv,
 		return -EBUSY;
 
 	/* Fill regular entries */
-	for (; i < MAX_FILER_IDX - 1 && (tab->fe[i].ctrl | tab->fe[i].ctrl);
+	for (; i < MAX_FILER_IDX - 1 && i < tab->fe[i].ctrl);
 	     i++)
 		gfar_write_filer(priv, i, tab->fe[i].ctrl, tab->fe[i].prop);
 	/* Fill the rest with fall-troughs */
-- 
1.7.11.7

