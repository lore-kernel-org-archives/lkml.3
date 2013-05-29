Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916Ab3E2LoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:44:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43347 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965848Ab3E2Lnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:43:52 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <kishon@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH 3/5] USB: ehci-msm: USB_EHCI_MSM need not depend on USB_PHY
Date: Wed, 29 May 2013 14:43:29 +0300
Message-ID: <1369827811-534-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369827811-534-1-git-send-email-rogerq@ti.com>
References: <1369827811-534-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the USB PHY drivers no longer depend on USB_PHY but
select it if needed, the controller drivers need not
depend on USB_PHY. They can safely select the necessary
PHY driver i.e. USB_MSM_OTG in this case.

Signed-off-by: Roger Quadros <rogerq@ti.com>
CC: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/host/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 5561b47..48e1b70 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -186,7 +186,6 @@ config USB_EHCI_HCD_AT91
 config USB_EHCI_MSM
 	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
 	depends on ARCH_MSM
-	depends on USB_PHY
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
 	---help---
-- 
1.7.4.1

