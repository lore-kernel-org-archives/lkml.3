Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967009AbaCUAx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:53:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965554AbaCUAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 130/149] can: flexcan: flexcan_remove(): add missing netif_napi_del()
Date: Thu, 20 Mar 2014 17:04:53 -0700
Message-Id: <20140321000441.461431723@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d96e43e8fce28cf97df576a07af9d65657a41a6f upstream.

This patch adds the missing netif_napi_del() to the flexcan_remove() function.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1143,9 +1143,10 @@ static int flexcan_probe(struct platform
 static int flexcan_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
+	struct flexcan_priv *priv = netdev_priv(dev);
 
 	unregister_flexcandev(dev);
-
+	netif_napi_del(&priv->napi);
 	free_candev(dev);
 
 	return 0;


