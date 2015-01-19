Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbbASH6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:58:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40546 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbASH6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:58:09 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH v2 0/5] Add support for Fujitsu USB host controller
Date: Mon, 19 Jan 2015 15:56:44 +0800
Message-Id: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for XHCI compliant Host controller found
on Fujitsu Socs, and are based on http://lwn.net/Articles/629162/
The first patch is to add Fujitsu glue layer of Synopsis DesignWare USB3 driver
and last four patch is about quirk implementation of errata in Synopsis
DesignWare USB3 IP.

Patch 1 introduces Fujitsu Specific Glue layer in Synopsis DesignWare USB3 IP
driver. 

Patch 2 is to add a revison number 3.00a of Synopsis DesignWare USB3 IP
core driver.

Patch 3 introduces using a quirk based on a errata of Synopsis
DesignWare USB3 IP which is versions < 3.00a and has hardware configuration
DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1, which cannot be read from software. As a
result this quirk has to be enabled via platform data or device tree.

Patch 4 is to set Synopsis quirk in xhci platform driver based on xhci platform
data.

Patch 5 introduces a quirk with device disconnection management necessary
Synopsys Designware USB3 IP with versions < 3.00a and hardware configuration
DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1. It solves a problem where without the
quirk, that host controller will die after a usb device is disconnected from
port of root hub.

Successfully tested on Fujitsu mb86s7x board.

Changes since v1 (RFC):
[https://lkml.org/lkml/2014/12/15/929]
 - based on Arnd's comment, remove entire unnecessary Fujitsu EHCI/OHCI glue,
 - based on Felipe's comment, fix mis-using of runtime-pm API and setting dma
   mask, remove unnecessary comment, and refactor suspend/resume handler in
   Fujitsu Specific Glue layer in dwc3,
 - based on Felipe's comment, add more commit log and comments in Synopsis
   quirk implementation, and separate it into four patches.

Sneeker Yeh (5):
  usb: dwc3: add Fujitsu Specific Glue layer
  usb: dwc3: add revision number DWC3_REVISION_300A
  usb: dwc3: Add quirk for Synopsis device disconnection errata
  xhci: Platform: Set Synopsis device disconnection quirk based on
    platform data
  xhci: add a quirk for device disconnection errata for Synopsis
    Designware USB3     core

 Documentation/devicetree/bindings/usb/dwc3.txt     |   17 ++
 .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   33 ++++
 drivers/usb/dwc3/Kconfig                           |   11 ++
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/core.c                            |    6 +
 drivers/usb/dwc3/core.h                            |    2 +
 drivers/usb/dwc3/dwc3-mb86s70.c                    |  206 ++++++++++++++++++++
 drivers/usb/dwc3/host.c                            |    4 +
 drivers/usb/dwc3/platform_data.h                   |    1 +
 drivers/usb/host/xhci-hub.c                        |    4 +
 drivers/usb/host/xhci-plat.c                       |    3 +
 drivers/usb/host/xhci.c                            |   29 +++
 drivers/usb/host/xhci.h                            |   24 +++
 include/linux/usb/xhci_pdriver.h                   |    4 +
 14 files changed, 345 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
 create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c

-- 
1.7.9.5

