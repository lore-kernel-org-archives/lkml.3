Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3DAN7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:59:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43974 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab3DAN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:58:29 -0400
X-AuditID: cbfee68e-b7f946d000001e37-e8-51599284e7f4
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 08/11] usb: phy: samsung: Enable runtime power management on
 usb3phy
Date: Mon, 01 Apr 2013 19:24:07 +0530
Message-id: <1364824448-14732-9-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkTrdlUmSgwZuTQhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DK+Hf5E2vBV46K3xPXsTcwnmbvYuTgkBAwkbhzWauLkRPIFJO4cG89Wxcj
	F4eQwFJGiaNHj7BAJEwkdn3byASRWMQo8fTwYmYIZwqTxLHHZxlBqtgEdCWa3u5iBJkqIhAn
	sXmCMEiYWaCLSWLpUXGQsLBApETH/kqQMIuAqsTaWTPZQWxeAQ+Jpl0HmSB2KUi8uf2MGcTm
	FPCU+LB1MVhcCKim/eoJVpC1EgL32CWeLb3NBDFIQOLb5EMsEM/ISmw6wAwxR1Li4IobLBMY
	hRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECIyh0/+e9e1gvHnA+hBjMtC4icxSosn5
	wBjMK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj
	e/D8jcmn/FzXZPOt+XUy3+KnQOXCZ6WP2qT48mV1FjwqCn3y18u7y+PCmsgPzyZ+/cPIbOcp
	Nu2k+3Lz82JXrhfJHTLKblP+wjWdjWVSxOtTKpfKPyq9XdqYwW9cvLzifk2n6E9xTQ2GpEPX
	/sSkNRXvq1fQtF94/+orL7WNu9KlBfj29K9TYinOSDTUYi4qTgQATVTmdLcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG7LpMhAg9v7OC0O3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePf5U+sBV85Kn5PXMfewHiavYuR
	k0NCwERi17eNTBC2mMSFe+vZuhi5OIQEFjFKPD28mBnCmcIkcezxWUaQKjYBXYmmt7uAbA4O
	EYE4ic0ThEHCzAJdTBJLj4qDhIUFIiU69leChFkEVCXWzpoJtotXwEOiaddBqF0KEm9uP2MG
	sTkFPCU+bF0MFhcCqmm/eoJ1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBMfpM
	egfjqgaLQ4wCHIxKPLwRFyIChVgTy4orcw8xSnAwK4nwrsiMDBTiTUmsrEotyo8vKs1JLT7E
	mAx01URmKdHkfGD6yCuJNzQ2MTc1NrU0sTAxsyRNWEmc92CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGxinT+jlzy54/uHFccqr4In9PWZtOYSae4rrDveXODAynNxlyblm7+lM51w95zS2p8+/5
	+r2Y9e1Qd202x9ZjQV8qc1NCnb2PL2BSWmZzbtXPTavM9TnOGivzt77tMTecKnDSROf1lpiw
	oNd+AVeedDsK6RaI6ydsUvsqtUX2TNLyE8Gv21hYlViKMxINtZiLihMBGhgd+BUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autosuspending of Samsung usb3.0 PHY

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb3.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 54f6418..a713585 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/pm_runtime.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
@@ -287,6 +288,9 @@ static int samsung_usb3phy_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sphy);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB3);
 }
 
@@ -296,6 +300,8 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	pm_runtime_disable(&pdev->dev);
+
 	if (sphy->pmuregs)
 		iounmap(sphy->pmuregs);
 	if (sphy->sysreg)
-- 
1.7.6.5

