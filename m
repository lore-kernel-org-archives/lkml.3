Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaKYNVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:21:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44793 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbaKYNPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 06/19] usb: dwc3: host: Pass the XHCI_DRD_SUPPORT and XHCI_NEEDS_LHC_RESET quirk
Date: Tue, 25 Nov 2014 18:41:42 +0530
Message-ID: <1416921115-10467-7-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the quir flag XHCI_DRD_SUPPORT from DWC3 host to xhci platform driver.
This enables xhci driver to handle deallocation's differently while in DRD mode.
Pass the quirk flag XHCI_NEEDS_LHC_RESET from DWC3 host to xhci platform
driver. This enables to do LHRESET during xhci_reset().

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index dcb8ca0..257b5b5 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -53,6 +53,8 @@ int dwc3_host_init(struct dwc3 *dwc)
 #ifdef CONFIG_DWC3_HOST_USB3_LPM_ENABLE
 	pdata.usb3_lpm_capable = 1;
 #endif
+	pdata.usb_drd_support = 1;
+	pdata.usb_needs_lhc_reset = 1;
 
 	ret = platform_device_add_data(xhci, &pdata, sizeof(pdata));
 	if (ret) {
-- 
1.8.3.1

