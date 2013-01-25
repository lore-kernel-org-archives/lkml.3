Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3AYK7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:59:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55294 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3AYK7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:59:42 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <kishon@ti.com>
Subject: [PATCH v4 0/2] usb: phy: add usb3 phy driver
Date: Fri, 25 Jan 2013 16:29:32 +0530
Message-ID: <1359111574-6613-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the delay in sending this version.
 
Added a driver for usb3 phy that handles the interaction between usb phy
device and dwc3 controller.

Changes from v3:
* Changed the property name from "ctrl_module" to "ctrl-module"

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

I've kept this patch series and the patch series to follow in a single branch
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

