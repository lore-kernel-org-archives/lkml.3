Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaKYNQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:16:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaKYNQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:10 -0500
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
Subject: [PATCH 08/19] usb: dwc3: core: Add dwc3_drd_helper function
Date: Tue, 25 Nov 2014 18:41:44 +0530
Message-ID: <1416921115-10467-9-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper function, facilitates to re-initialize the event buffers.
It re-initilizes the event buffers while switching role from
HOST to DEVICE mode.

The DWC3 IP shares internal RAM for both HOST and Device specific registers.
So while switching roles from HOST to Device modes, it's required to
re-initialize the EVENT buffer registers for the Device mode to continue
work properly. dwc3_event_buffers_setup() is exported out from core.c via
wrapper dwc3_core_gadget_helper() which will be invoked from dwc3 otg driver.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/core.c | 5 +++++
 drivers/usb/dwc3/core.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 25ddc39..fadd767 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -254,6 +254,11 @@ static void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 	}
 }
 
+int dwc3_core_gadget_helper(struct dwc3 *dwc)
+{
+	return dwc3_event_buffers_setup(dwc);
+}
+
 static int dwc3_alloc_scratch_buffers(struct dwc3 *dwc)
 {
 	if (!dwc->has_hibernation)
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4bb9aa6..6b38223 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -981,6 +981,7 @@ struct dwc3_gadget_ep_cmd_params {
 /* prototypes */
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode);
 int dwc3_gadget_resize_tx_fifos(struct dwc3 *dwc);
+int dwc3_core_gadget_helper(struct dwc3 *dwc);
 
 #if IS_ENABLED(CONFIG_USB_DWC3_HOST) || IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
 int dwc3_host_init(struct dwc3 *dwc);
-- 
1.8.3.1

