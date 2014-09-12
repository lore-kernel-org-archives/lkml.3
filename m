Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaILR37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:29:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55627 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaILR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:29:56 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH v8 0/3] DWC3 USB support for Qualcomm platform
Date: Fri, 12 Sep 2014 12:29:43 -0500
Message-Id: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add basic support for USB3.0 controllers found
on MSM platforms. USB3.0 core is based on Synopsys DesignWare
SuperSpeed IP.

This work was started by Ivan Ivanov and went through a number of iterations.  I
picked these patches up and did a little rework to get them working.

Changes since v7:
* Reworked phy driver to conform to the generic phy framework.
* Collapsed HS and SS phy drivers into same source file.
* Dropped regulators from the drivers.  The only platform where we can utilize
  this driver has regulators on all the time.  Will add regulators back in when
  they are required.
* Added timeouts to the phy register accesses
* Put in definitions for the phy specific registers and bitfields
* Removed unnecessary workarounds.

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

Andy Gross (1):
  phy: Add Qualcomm DWC3 HS/SS PHY driver

Ivan T. Ivanov (2):
  usb: dwc3: qcom: Add device tree binding
  usb: dwc3: Add Qualcomm DWC3 glue layer driver

 .../devicetree/bindings/phy/qcom-dwc3-usb-phy.txt  |   39 ++
 .../devicetree/bindings/usb/qcom,dwc3.txt          |   66 +++
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-qcom-dwc3.c                        |  500 ++++++++++++++++++++
 drivers/usb/dwc3/Kconfig                           |    9 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-qcom.c                       |  133 ++++++
 8 files changed, 760 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-dwc3-usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt
 create mode 100644 drivers/phy/phy-qcom-dwc3.c
 create mode 100644 drivers/usb/dwc3/dwc3-qcom.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

