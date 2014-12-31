Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaLaIp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:45:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38453 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaLaIpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:45:54 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] phy: miphy28lp: unlock on error in miphy28lp_init()
Date: Wed, 31 Dec 2014 14:15:47 +0530
Message-ID: <1420015549-20697-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420015549-20697-1-git-send-email-kishon@ti.com>
References: <1420015549-20697-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We need to unlock before returning the -EINVAL here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-miphy28lp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index e34da13..27fa62c 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -1050,7 +1050,8 @@ static int miphy28lp_init(struct phy *phy)
 		ret = miphy28lp_init_usb3(miphy_phy);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
 
 	mutex_unlock(&miphy_dev->miphy_mutex);
-- 
1.7.9.5

