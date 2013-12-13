Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3LMJWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:22:04 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45469 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3LMJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:20:41 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] net: phy: resume/suspend PHYs on attach/detach
Date: Fri, 13 Dec 2013 10:20:28 +0100
Message-Id: <1386926429-28818-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures PHYs are resumed on attach and suspended on detach.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy_device.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6f0e9e4..3903f44 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -570,6 +570,8 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (err)
 		phy_detach(phydev);
 
+	phy_resume(phydev);
+
 	return err;
 }
 
@@ -615,6 +617,7 @@ void phy_detach(struct phy_device *phydev)
 {
 	phydev->attached_dev->phydev = NULL;
 	phydev->attached_dev = NULL;
+	phy_suspend(phydev);
 
 	/* If the device had no specific driver before (i.e. - it
 	 * was using the generic driver), we unbind the device
-- 
1.7.2.5

