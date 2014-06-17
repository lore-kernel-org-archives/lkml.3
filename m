Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaFQOSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:18:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5064 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaFQOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:18:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jun 2014 07:09:11 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] USB: EHCI: tegra: Fix use-after-free in .remove()
Date: Tue, 17 Jun 2014 17:17:40 +0300
Message-ID: <1403014660-15509-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tegra_ehci_hcd structure is located in the private space allocated
by the core USB code so it must not be accessed after the HCD is
freed.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 6fdcb8a..5590567 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -479,10 +479,11 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 
 	usb_phy_shutdown(hcd->phy);
 	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
 
 	clk_disable_unprepare(tegra->clk);
 
+	usb_put_hcd(hcd);
+
 	return 0;
 }
 
-- 
1.8.1.5

