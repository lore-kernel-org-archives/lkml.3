Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaA2GCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:02:02 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60506 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaA2GAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:00:47 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 1/4] phy: provide accessors for 'advertising' and 'supported' fields
Date: Wed, 29 Jan 2014 10:00:15 +0400
Message-Id: <1390975218-13863-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com>
References: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many network drivers directly modify phy_device::advertising and
phy_device::supported. Provide accessors to these fields to better
isolate phylib from its users.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes v1->v2:
- new patch

 include/linux/phy.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 48a4dc3..2ae58f8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -559,6 +559,18 @@ static inline int phy_read_status(struct phy_device *phydev) {
 	return phydev->drv->read_status(phydev);
 }
 
+static inline void phy_update_advert(struct phy_device *phydev, u32 clear,
+				     u32 set)
+{
+	phydev->advertising = (phydev->advertising & ~clear) | set;
+}
+
+static inline void phy_update_supported(struct phy_device *phydev, u32 clear,
+					u32 set)
+{
+	phydev->supported = (phydev->supported & ~clear) | set;
+}
+
 int genphy_setup_forced(struct phy_device *phydev);
 int genphy_restart_aneg(struct phy_device *phydev);
 int genphy_config_aneg(struct phy_device *phydev);
-- 
1.8.1.4

