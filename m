Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966545Ab3E2ThR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:37:17 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46306 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966222Ab3E2TdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:33:10 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/13] net: mv643xx_eth: add phy_node to platform_data struct
Date: Wed, 29 May 2013 21:32:45 +0200
Message-Id: <1369855975-21489-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a struct device_node pointer for a phy passed by phandle
to mv643xx_eth node.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/mv643xx_eth.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mv643xx_eth.h b/include/linux/mv643xx_eth.h
index 141d395..6e8215b 100644
--- a/include/linux/mv643xx_eth.h
+++ b/include/linux/mv643xx_eth.h
@@ -30,6 +30,7 @@ struct mv643xx_eth_shared_platform_data {
 #define MV643XX_ETH_PHY_ADDR(x)		(0x80 | (x))
 #define MV643XX_ETH_PHY_NONE		0xff
 
+struct device_node;
 struct mv643xx_eth_platform_data {
 	/*
 	 * Pointer back to our parent instance, and our port number.
@@ -41,6 +42,7 @@ struct mv643xx_eth_platform_data {
 	 * Whether a PHY is present, and if yes, at which address.
 	 */
 	int			phy_addr;
+	struct device_node	*phy_node;
 
 	/*
 	 * Use this MAC address if it is valid, overriding the
-- 
1.7.10.4

