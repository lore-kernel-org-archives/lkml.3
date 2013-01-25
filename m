Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AYCwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:52:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39543 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AYCwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:52:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 0/2] usb: phy: add usb3 phy driver
Date: Fri, 25 Jan 2013 08:21:47 +0530
Message-ID: <1359082309-7158-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the delay in sending this version.
 
Added a driver for usb3 phy that handles the interaction between usb phy
device and dwc3 controller.

Changes from v2:
* used control module driver APIs to write to control module register.
* Added pm_runtime_put and pm_runtime_disable in the usb3 phy driver.
* Added checks for enabling and disabling "usb_otg_ss_refclk960m" so that
  it doesn't break omap4.

Changes from v1:
* Added missing clk_put()
* Remove the patches usb: dwc3: Fix gadget pullup in SS mode and
usb: phy: omap-usb3: Decrease the number of transitions to recovery. Those
are actually WA for hw issues which will be fixed in ES2.
* Removed the *has960mhzclk* property

This patch series is developed on
git://github.com/rrnayak/linux.git omap5-3.8-rc4-base-palmas

I've kept this patch series and all the patch series to follow in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Did enumeration testing on omap4 panda and omap5 evm.

Kishon Vijay Abraham I (2):
  usb: phy: add a new driver for usb3 phy
  usb: phy: omap-usb2: enable 960Mhz clock for omap5

 Documentation/devicetree/bindings/usb/usb-phy.txt |   23 ++
 drivers/usb/phy/Kconfig                           |   10 +
 drivers/usb/phy/Makefile                          |    1 +
 drivers/usb/phy/omap-usb2.c                       |   28 +-
 drivers/usb/phy/omap-usb3.c                       |  355 +++++++++++++++++++++
 include/linux/usb/omap_usb.h                      |   23 ++
 6 files changed, 439 insertions(+), 1 deletion(-)
 create mode 100644 drivers/usb/phy/omap-usb3.c

-- 
1.7.9.5

