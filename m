Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3CRMek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:34:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19906 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3CRMdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:33:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Mar 2013 05:26:33 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 4/7] usb: phy: tegra: Return correct error value provided by clk_get_sys
Date: Mon, 18 Mar 2013 17:59:38 +0530
Message-ID: <1363609781-4045-5-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
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
 drivers/usb/phy/tegra_usb_phy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 93abd68..b5b2037 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
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

