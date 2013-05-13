Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3EMKOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:14:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50577 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3EMKOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:14:36 -0400
X-AuditID: 9c93017e-b7cf8ae000004f65-66-5190b97dcf54
From: Jongsung Kim <neidhard.kim@lge.com>
To: davem@davemloft.net, peppe.cavallaro@st.com, chohnstaedt@innominate.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jongsung Kim <neidhard.kim@lge.com>
Subject: [PATCH v3 3/4] net: phy: realtek: add suspend/resume handlers for the RTL8211B
Date: Mon, 13 May 2013 18:58:39 +0900
Message-Id: <1368439120-26322-3-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <518CD784.1030709@cogentembedded.com>
References: <518CD784.1030709@cogentembedded.com>
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

