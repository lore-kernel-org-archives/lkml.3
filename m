Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaFES2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:28:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57456 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaFES2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:28:10 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: f.fainelli@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH] net: phy: fix sparse warning in fixed.c
Date: Thu,  5 Jun 2014 20:27:42 +0200
Message-Id: <1401992862-8427-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warning:

drivers/net/phy/fixed.c:207
    - warning: symbol 'fixed_phy_del' was not declared.
      Should it be static?

by adding symbol definition to the phy_fixed.h API file. It is ok to do
because the function in question is an exported symbol.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 include/linux/phy_fixed.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 4f2478b..ae612ac 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -17,6 +17,7 @@ extern int fixed_phy_add(unsigned int irq, int phy_id,
 extern int fixed_phy_register(unsigned int irq,
 			      struct fixed_phy_status *status,
 			      struct device_node *np);
+extern void fixed_phy_del(int phy_addr);
 #else
 static inline int fixed_phy_add(unsigned int irq, int phy_id,
 				struct fixed_phy_status *status)
@@ -29,6 +30,10 @@ static inline int fixed_phy_register(unsigned int irq,
 {
 	return -ENODEV;
 }
+static inline int fixed_phy_del(int phy_addr)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_FIXED_PHY */
 
 /*
-- 
1.8.1.2

