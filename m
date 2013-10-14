Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3JNPaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:30:18 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49717 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab3JNP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:03 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 00/13] usb: phy: msm: Fixes, cleanups and DT support
Date: Mon, 14 Oct 2013 18:24:27 +0300
Message-Id: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

This is third version of MSM OTG clean up patches.
 
v3
--
* In patch 1 - functions for reseting PHY and LINK controller just
  call platform code if available.
* New stuff is: cleaning up unneeded/unused driver state variables
* Simplified regulator names. There is no references to these names
  in tree, so there should not be a problem with this.
* Replace the USB specific clock names with the more standard 'core' 
  and 'iface' ... names.   
* Added devicetree support 

v2
--
* Fix compilation issue in patch 1
* Separate regulator changes
* Merge devm_ related changes to one commit
* Drop Lindent patch

v1
--
Following patches make initial cleanup of usb phy found in the Qualcomm
chipsets. Changes include:
* Build time error fix.
* Move driver to Managed Device Resource allocation.
* Checkpatch warnings and error fixes
* Removed usage of global regulators variables.

Ivan T. Ivanov (13):
  usb: phy: msm: Move mach depndend code to platform data
  usb: phy: msm: Move global regulators variables to driver state
  usb: phy: msm: Migrate to Managed Device Resource allocation
  usb: phy: msm: Remove unnecessarily check for valid regulators.
  usb: phy: msm: Fix WARNING: quoted string split across lines
  usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf
  usb: phy: msm: Replace custom enum usb_mode_type with enum
    usb_dr_mode
  usb: phy: msm: Drop default usb_dr_mode from platform data.
  usb: phy: msm: Remove unused pclk_src_name
  usb: phy: msm: Switch clock consumer strings
  usb: phy: msm: Remove HSUSB prefix from requlator names
  usb: phy: msm: Properly check core interrupt number
  usb: phy: msm: Add device tree support and binding information

 .../devicetree/bindings/usb/msm-hsusb.txt          |   58 +++
 arch/arm/mach-msm/board-msm7x30.c                  |   37 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   37 +-
 arch/arm/mach-msm/devices-msm7x00.c                |    4 +-
 arch/arm/mach-msm/devices-msm7x30.c                |    8 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |    6 +-
 drivers/usb/phy/phy-msm-usb.c                      |  470 +++++++++-----------
 include/linux/usb/msm_hsusb.h                      |   45 +-
 8 files changed, 362 insertions(+), 303 deletions(-)

-- 
1.7.9.5

