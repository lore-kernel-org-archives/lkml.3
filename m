Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3ISRjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:39:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:39645 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:39:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <f.fainelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David J. Choi" <david.choi@micrel.com>
Subject: [PATCH] phy/micrel: Add suspend/resume support to Micrel PHYs
Date: Thu, 19 Sep 2013 19:39:29 +0200
Message-ID: <1379612369-20692-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Vilchez <patrice.vilchez@atmel.com>

All supported Micrel PHYs implement the standard "power down" bit 11 of BMCR,
so this patch adds support using the generic genphy_{suspend,resume} functions.

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
[b.brezillon@overkiz.com: adapt to newer kernel and generalize to other phys]
Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
[nicolas.ferre@atmel.com: commit message modification]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David J. Choi <david.choi@micrel.com>
---
 drivers/net/phy/micrel.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c31aad0..3ae28f4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -287,6 +287,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= ks8737_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8021,
@@ -300,6 +302,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8031,
@@ -313,6 +317,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8041,
@@ -326,6 +332,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8051,
@@ -339,6 +347,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8001,
@@ -351,6 +361,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8081,
@@ -363,6 +375,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8061,
@@ -375,6 +389,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
@@ -387,6 +403,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= ksz9021_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE, },
 }, {
 	.phy_id		= PHY_ID_KSZ9031,
@@ -400,6 +418,8 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= ksz9021_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE, },
 }, {
 	.phy_id		= PHY_ID_KSZ8873MLL,
@@ -410,6 +430,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
 	.read_status	= ksz8873mll_read_status,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE, },
 }, {
 	.phy_id		= PHY_ID_KSZ886X,
@@ -420,6 +442,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= kszphy_config_init,
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 	.driver		= { .owner = THIS_MODULE, },
 } };
 
-- 
1.8.2.2

