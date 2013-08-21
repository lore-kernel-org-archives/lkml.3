Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3HUNbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:31:06 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49251 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3HUNbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:31:01 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v5 0/3] DWC3 USB support for Qualcomm platform
Date: Wed, 21 Aug 2013 16:29:43 +0300
Message-Id: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi,

Here is fifth version of MSM USB3 drivers patches.

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

These patches add basic support for USB3.0 controllers found
on MSM platforms. USB3.0 core is based on Synopsys DesignWare 
SuperSpeed IP. 

Generated on top of Felipe 'testing' branch.

Ivan T. Ivanov (3):
  usb: dwc3: msm: Add device tree binding information
  usb: phy: Add Qualcomm SS-USB and HS-USB drivers for DW PHY's
  usb: dwc3: Add Qualcomm DWC3 glue layer driver

 .../devicetree/bindings/usb/msm-ssusb.txt          |  104 ++++++
 drivers/usb/dwc3/Kconfig                           |    8 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-msm.c                        |  167 +++++++++
 drivers/usb/phy/Kconfig                            |   11 +
 drivers/usb/phy/Makefile                           |    2 +
 drivers/usb/phy/phy-msm-dw-hs.c                    |  327 +++++++++++++++++
 drivers/usb/phy/phy-msm-dw-ss.c                    |  374 ++++++++++++++++++++
 8 files changed, 994 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
 create mode 100644 drivers/usb/dwc3/dwc3-msm.c
 create mode 100644 drivers/usb/phy/phy-msm-dw-hs.c
 create mode 100644 drivers/usb/phy/phy-msm-dw-ss.c

-- 
1.7.9.5

