Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbaJDAla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:41:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbaJCVml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 120/357] usb: phy: tegra: Avoid use of sizeof(void)
Date: Fri,  3 Oct 2014 14:28:26 -0700
Message-Id: <20141003212937.084181089@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/phy/phy-tegra-usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -881,8 +881,8 @@ static int utmi_phy_probe(struct tegra_u
 		return -ENOMEM;
 	}
 
-	tegra_phy->config = devm_kzalloc(&pdev->dev,
-		sizeof(*tegra_phy->config), GFP_KERNEL);
+	tegra_phy->config = devm_kzalloc(&pdev->dev, sizeof(*config),
+					 GFP_KERNEL);
 	if (!tegra_phy->config) {
 		dev_err(&pdev->dev,
 			"unable to allocate memory for USB UTMIP config\n");


