Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3EJODX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7078 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3EJODT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 May 2013 07:03:16 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 06/10] usb: phy: tegra: Return correct error value provided by clk_get_sys
Date: Fri, 10 May 2013 19:24:07 +0530
Message-ID: <1368194051-4925-7-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if clk_get_sys fails, return correct error value provided by
the API.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v1 & v2: no change.

 drivers/usb/phy/phy-tegra-usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 91b6e29..16851e2 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -620,8 +620,7 @@ static int	tegra_phy_init(struct usb_phy *x)
 		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
 		if (IS_ERR(phy->clk)) {
 			pr_err("%s: can't get ulpi clock\n", __func__);
-			err = -ENXIO;
-			goto err1;
+			return PTR_ERR(phy->clk);
 		}
 		if (!gpio_is_valid(ulpi_config->reset_gpio))
 			ulpi_config->reset_gpio =
-- 
1.7.0.4

