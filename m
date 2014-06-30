Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaF3QEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:04:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51357 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaF3QEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:04:06 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, jackp@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [Patch v7 0/3] DWC3 USB support for Qualcomm platform
Date: Mon, 30 Jun 2014 11:03:50 -0500
Message-Id: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add basic support for USB3.0 controllers found
on MSM platforms. USB3.0 core is based on Synopsys DesignWare 
SuperSpeed IP. 

This work was started by Ivan Ivanov and went through a number of iterations.  I
picked these patches up and did a little rework to get them working.

Changes since v6:
* Renamed all MSM references to qcom, including file names
* Removed direct TCSR manipulation.  This done from new TCSR driver.
* Added defines for register bits
* XO clk is optional on some platforms.  Corrected logic to handle this.
* Ignore set_voltage failures.  This allows us to support dummy regulators on
  platforms where there is no voltage control.
* Reworked devicetree binding to remove TCSR reg resources

Changes since v5:
* devicetree bindings descriptions fixes 
* Fixed NULL pointer dereferences in dev_prink's
* Removed extra space in "sleep " clock name

Changes since v4:
* Substitute references to "wc3" with just "dw" in USB PHY drivers and
  file names. This is to indicate that the PHY's are DesignWare, but
  not necessarily related to DWC3 IP core. 

Changes since v3:
* Remove "_clk" suffix from clock names
* Clarify required child node for qcom,dwc3
* Fix comments in functions headers
* Use dbg instead err in drivers probe functions.

Changes since v2:
* Several improvements in devicetree bindings description
* Disable regulators in glue layer if there is error during 
  ioremap.

Changes since first version:
* Split devicetree bindings description file to separate patch
* Address comments for device bindings description
* Fix typo in 'gdsc' requlator name.

Ivan T. Ivanov (3):
  usb: dwc3: Add Qualcomm DWC3 glue layer driver
  usb: phy: Add Qualcomm DWC3 HS/SS PHY drivers
  usb: dwc3: qcom: Add device tree binding

 .../devicetree/bindings/usb/qcom,dwc3.txt          |  104 ++++++
 drivers/usb/dwc3/Kconfig                           |    9 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-qcom.c                       |  153 ++++++++
 drivers/usb/phy/Kconfig                            |   11 +
 drivers/usb/phy/Makefile                           |    2 +
 drivers/usb/phy/phy-qcom-hsusb.c                   |  348 ++++++++++++++++++
 drivers/usb/phy/phy-qcom-ssusb.c                   |  385 ++++++++++++++++++++
 8 files changed, 1013 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt
 create mode 100644 drivers/usb/dwc3/dwc3-qcom.c
 create mode 100644 drivers/usb/phy/phy-qcom-hsusb.c
 create mode 100644 drivers/usb/phy/phy-qcom-ssusb.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

