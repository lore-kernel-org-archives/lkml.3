Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaKYNVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:21:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54405 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaKYNPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:15:55 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 05/19] usb: host: xhci-plat: Add support to pass XHCI_NEEDS_LHC_RESET quirk
Date: Tue, 25 Nov 2014 18:41:41 +0530
Message-ID: <1416921115-10467-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the platform data to pass XHCI_NEEDS_LHC_RESET quirk to
the xhci driver.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci-plat.c     | 3 +++
 include/linux/usb/xhci_pdriver.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 2c42273..d8d024d 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -31,6 +31,9 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 
 	if (pdata->usb_drd_support)
 		xhci->quirks |= XHCI_DRD_SUPPORT;
+
+	if (pdata->usb_needs_lhc_reset)
+		xhci->quirks |= XHCI_NEEDS_LHC_RESET;
 	/*
 	 * As of now platform drivers don't provide MSI support so we ensure
 	 * here that the generic code does not try to make a pci_dev from our
diff --git a/include/linux/usb/xhci_pdriver.h b/include/linux/usb/xhci_pdriver.h
index 539c2d8..8ef7321 100644
--- a/include/linux/usb/xhci_pdriver.h
+++ b/include/linux/usb/xhci_pdriver.h
@@ -23,6 +23,7 @@
 struct usb_xhci_pdata {
 	unsigned	usb3_lpm_capable:1;
 	unsigned	usb_drd_support:1;
+	unsigned	usb_needs_lhc_reset:1;
 };
 
 #endif /* __USB_CORE_XHCI_PDRIVER_H */
-- 
1.8.3.1

