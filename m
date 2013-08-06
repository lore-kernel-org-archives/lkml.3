Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3HFLyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:54:09 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55340 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab3HFLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:54:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [RFC 0/2] DWC3 USB support for Qualcomm platform
Date: Tue,  6 Aug 2013 14:53:09 +0300
Message-Id: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

These patches add basic support for USB3.0 controllers found on
MSM platforms. First patch add 2 USB PHY drivers and second one
add support for Qualcomm wrapper IP over DWC3 controller. Patches 
are just skeletons, no power management. 

DWC3 IP in MSM also support OTG but right now I am not sure how to
add support for it. Probably OTG have to be instantiated from core 
dwc3 driver, but usually PHY drivers are those which create OTG
instance.

Generated on top of Felipe 'testing' branch.

Regards,
Ivan

Ivan T. Ivanov (2):
  usb: phy: Add Qualcomm SS-USB and HS-USB drivers for DWC3 core
  usb: dwc3: Add Qualcomm DWC3 glue layer driver

 .../devicetree/bindings/usb/msm-ssusb.txt          |   88 +++++
 drivers/usb/dwc3/Kconfig                           |    8 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-msm.c                        |  175 +++++++++
 drivers/usb/phy/Kconfig                            |   11 +
 drivers/usb/phy/Makefile                           |    2 +
 drivers/usb/phy/phy-msm-dwc3-usb2.c                |  342 +++++++++++++++++
 drivers/usb/phy/phy-msm-dwc3-usb3.c                |  389 ++++++++++++++++++++
 8 files changed, 1016 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
 create mode 100644 drivers/usb/dwc3/dwc3-msm.c
 create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb2.c
 create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb3.c

-- 
1.7.9.5

