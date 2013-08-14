Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3HNNBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:01:18 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:41230 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab3HNNBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:01:15 -0400
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
Subject: [PATCH v3 0/3] DWC3 USB support for Qualcomm platform
Date: Wed, 14 Aug 2013 15:59:40 +0300
Message-Id: <1376485183-2664-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi,

These patches add basic support for USB3.0 controllers found
on MSM platforms. USB3.0 core is based on Synopsys DesignWare 
SuperSpeed IP. 

Changes since v2:
* Several improvements in devicetree bindings description
* Disable regulators in glue layer if there is error during 
  ioremap.

Changes since first version:
* Split devicetree bindings description file to separate patch
* Address comments for device bindings description
* Fix typo in 'gdsc' requlator name.

Generated on top of Felipe 'testing' branch.

Regards,
Ivan

Ivan T. Ivanov (3):
  usb: dwc3: msm: Add device tree binding information
  usb: phy: Add Qualcomm SS-USB and HS-USB drivers for DWC3 core
  usb: dwc3: Add Qualcomm DWC3 glue layer driver

 .../devicetree/bindings/usb/msm-ssusb.txt          |  108 ++++++
 drivers/usb/dwc3/Kconfig                           |    8 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-msm.c                        |  169 +++++++++
 drivers/usb/phy/Kconfig                            |   11 +
 drivers/usb/phy/Makefile                           |    2 +
 drivers/usb/phy/phy-msm-dwc3-hs.c                  |  336 +++++++++++++++++
 drivers/usb/phy/phy-msm-dwc3-ss.c                  |  383 ++++++++++++++++++++
 8 files changed, 1018 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
 create mode 100644 drivers/usb/dwc3/dwc3-msm.c
 create mode 100644 drivers/usb/phy/phy-msm-dwc3-hs.c
 create mode 100644 drivers/usb/phy/phy-msm-dwc3-ss.c

-- 
1.7.9.5

