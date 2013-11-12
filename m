Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3KLO7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:59:50 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51798 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab3KLOyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:19 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v4 00/15]  usb: phy: msm: Fixes, cleanups and DT support
Date: Tue, 12 Nov 2013 16:51:35 +0200
Message-Id: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

Patches have been tested on top of Stephen's clock controller
patches[1] and recent fixes for chipidea msm glue layer driver
posted here[2]. Hardware platform AP8074 DragonBoard. Only gadget
mode utilized for now. 

CV Test Suite engine "Chapter 9 tests" are passing except
"Halt Endpoint Test".

usbtest driver report following failure:
test 13 --> 32 (Broken pipe) 		ep 81 couldn't set halt, -32

This will be investigated further. 
Patches could be applied cleanly on top of the usb-3.13-rc1.

Regards,
Ivan

[1] http://comments.gmane.org/gmane.linux.ports.arm.msm/5375
[2] https://lkml.org/lkml/2013/11/11/310

v4
-- 
* Squashed checkpatch.pl warning fixes patches
* Squashed dr_mode refactoring with default mode removal
* Dropped patch 10 - usb: phy: msm: Switch clock consumer strings
* Fixed comments from review.
* Utilize reset-framework for LINK and PHY resets if DT is used.
* Added support from second PHY device control.
* Ported reset procedure from codeaurora tree for new chipsets
 
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

Ivan T. Ivanov (15):
  usb: phy: msm: Move mach dependent code to platform data
  usb: phy: msm: Move global regulators variables to driver state
  usb: phy: msm: Migrate to Managed Device Resource allocation
  usb: phy: msm: Remove unnecessarily check for valid regulators.
  usb: phy: msm: Fix checkpatch.pl warnings
  usb: phy: msm: Replace custom enum usb_mode_type with enum
    usb_dr_mode
  usb: phy: msm: Remove unused pclk_src_name
  usb: phy: msm: Remove HSUSB prefix from regulator names
  usb: phy: msm: Properly check result from platform_get_irq()
  usb: phy: msm: Add device tree support and binding information
  usb: phy: msm: Use reset framework for LINK and PHY resets
  usb: phy: msm: Add support for secondary PHY control
  usb: phy: msm: Correct USB PHY Reset sequence for newer platform
  usb: phy: msm: Handle disconnect events
  usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX

 .../devicetree/bindings/usb/msm-hsusb.txt          |   78 ++-
 arch/arm/mach-msm/board-msm7x30.c                  |   37 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   37 +-
 drivers/usb/phy/phy-msm-usb.c                      |  664 +++++++++++---------
 include/linux/usb/msm_hsusb.h                      |   36 +-
 include/linux/usb/msm_hsusb_hw.h                   |    6 +
 6 files changed, 529 insertions(+), 329 deletions(-)

-- 
1.7.9.5

