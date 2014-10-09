Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaJIVgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:36:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbaJIVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thierry Reding <treding@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 024/163] usb: phy: tegra: Avoid use of sizeof(void)
Date: Thu,  9 Oct 2014 14:00:49 -0700
Message-Id: <1412888588-26755-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

commit 9ce9ec95fb9b82e09b55a52f1bb8a362bf8f74d8 upstream.

The PHY configuration is stored in an opaque "config" field, but when
allocating the structure, its proper size needs to be known. In the case
of UTMI, the proper structure is tegra_utmip_config of which a local
variable already exists, so we can use that to obtain the size from.

Fixes the following warning from the sparse checker:

	drivers/usb/phy/phy-tegra-usb.c:882:17: warning: expression using sizeof(void)

Fixes: 81d5dfe6d8b3 (usb: phy: tegra: Read UTMIP parameters from device tree)
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/phy/phy-tegra-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index bbe4f8e..8834b70 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -881,8 +881,8 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 		return -ENOMEM;
 	}
 
-	tegra_phy->config = devm_kzalloc(&pdev->dev,
-		sizeof(*tegra_phy->config), GFP_KERNEL);
+	tegra_phy->config = devm_kzalloc(&pdev->dev, sizeof(*config),
+					 GFP_KERNEL);
 	if (!tegra_phy->config) {
 		dev_err(&pdev->dev,
 			"unable to allocate memory for USB UTMIP config\n");
-- 
1.9.1

