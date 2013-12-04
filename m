Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3LDCC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:02:58 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:41493 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab3LDCCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:02:54 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
Date: Wed,  4 Dec 2013 10:02:44 +0800
Message-Id: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: phy-tegra-usb.c: wrong pointer check for remap UTMI

A wrong pointer was used to test the result of devm_ioremap()

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 82232ac..bbe4f8e 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -876,7 +876,7 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 
 	tegra_phy->pad_regs = devm_ioremap(&pdev->dev, res->start,
 		resource_size(res));
-	if (!tegra_phy->regs) {
+	if (!tegra_phy->pad_regs) {
 		dev_err(&pdev->dev, "Failed to remap UTMI Pad regs\n");
 		return -ENOMEM;
 	}
-- 
1.7.10.4

