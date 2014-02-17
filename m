Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaBQJAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:00:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52623 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaBQI7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:38 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 6/8] phy-core: Don't propagate -ENOSUPP from phy_pm_runtime_get_sync to caller
Date: Mon, 17 Feb 2014 14:29:23 +0530
Message-ID: <1392627565-1829-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

The phy-core allows phy_init and phy_power_on to be called multiple times,
but before this patch -ENOSUPP from phy_pm_runtime_get_sync would be
propagated to the caller for the 2nd and later calls.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index b355553..6c73837 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -176,6 +176,8 @@ int phy_init(struct phy *phy)
 			dev_err(&phy->dev, "phy init failed --> %d\n", ret);
 			goto out;
 		}
+	} else {
+		ret = 0; /* Override possible ret == -ENOTSUPP */
 	}
 	++phy->init_count;
 
@@ -232,6 +234,8 @@ int phy_power_on(struct phy *phy)
 			dev_err(&phy->dev, "phy poweron failed --> %d\n", ret);
 			goto out;
 		}
+	} else {
+		ret = 0; /* Override possible ret == -ENOTSUPP */
 	}
 	++phy->power_count;
 	mutex_unlock(&phy->mutex);
-- 
1.7.10.4

