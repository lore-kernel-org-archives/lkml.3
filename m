Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIXIz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:55:59 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61274 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaIXIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:55:55 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, davem@davemloft.net, angus@agibson.me,
        tklauser@distanz.ch, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Remove unnecessary OOM message
Date: Wed, 24 Sep 2014 09:54:41 +0100
Message-Id: <1411548882-10639-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
References: <1411506437.29268.13.camel@joe-AO725>
 <1411548882-10639-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f5459ec..cd90831 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2418,10 +2418,8 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	rfd->len = len;
 
 	skb = dev_alloc_skb(rfd->len + 2);
-	if (!skb) {
-		dev_err(&adapter->pdev->dev, "Couldn't alloc an SKB for Rx\n");
+	if (!skb)
 		return NULL;
-	}
 
 	adapter->netdev->stats.rx_bytes += rfd->len;
 
-- 
1.7.10.4

