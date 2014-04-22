Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaDVJVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:21:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53448 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaDVJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:38 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 01/19] usb: phy: msm: Make driver selectable on ARCH_QCOM
Date: Tue, 22 Apr 2014 12:20:20 +0300
Message-Id: <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Controller could be found on APQ and MSM platforms,
make configuration description more generic.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 416e0c8..0c668a3 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -171,11 +171,11 @@ config USB_ISP1301
 	  module will be called phy-isp1301.

 config USB_MSM_OTG
-	tristate "OTG support for Qualcomm on-chip USB controller"
-	depends on (USB || USB_GADGET) && ARCH_MSM
+	tristate "Qualcomm on-chip USB OTG controller support"
+	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
 	select USB_PHY
 	help
-	  Enable this to support the USB OTG transceiver on MSM chips. It
+	  Enable this to support the USB OTG transceiver on Qualcomm chips. It
 	  handles PHY initialization, clock management, and workarounds
 	  required after resetting the hardware and power management.
 	  This driver is required even for peripheral only or host only
--
1.8.3.2

