Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3EJHaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:30:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64614 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3EJHaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:30:12 -0400
X-AuditID: 9c930179-b7bb6ae000001131-94-518ca20366af
From: Jongsung Kim <neidhard.kim@lge.com>
To: r58129@freescale.com, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com, peppe.cavallaro@st.com,
        chohnstaedt@innominate.com, timur@freescale.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        neidhard.kim@lge.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] net: phy: realtek: add suspend/resume handlers for the RTL8211B
Date: Fri, 10 May 2013 16:29:26 +0900
Message-Id: <1368170967-20589-3-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <201305081910.27203.neidhard.kim@lge.com>
References: <201305081910.27203.neidhard.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible but missing generic PHY suspend/resume handlers for
the RTL8211B driver.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/net/phy/realtek.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 8e95e38..6f0726a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -126,6 +126,8 @@ static struct phy_driver realtek_drv[] = {
 		.read_status	= &genphy_read_status,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211b_config_intr,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
 		.driver		= { .owner = THIS_MODULE,},
 	},
 	{	/* RTL8211E */
-- 
1.7.1

