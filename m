Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaLPCLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:11:11 -0500
Received: from mail-pd0-f195.google.com ([209.85.192.195]:43094 "EHLO pdbft15"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbaLPCLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:11:08 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH 0/3] Add support for Fujitsu USB host controller
Date: Tue, 16 Dec 2014 10:10:25 +0800
Message-Id: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for EHCI and XHCI compliant Host controller found
on Fujitsu Socs, and are based on
http://www.spinics.net/lists/arm-kernel/msg385573.html

First patch is EHCI platform glue driver. Patch 2 introduces Fujitsu
Specific Glue layer in Synopsis DesignWare USB3 IP driver. Patch 3
introduces a quirk with device disconnection management necessary for IPs
using the Synopsys Designware dwc3 core. It solves a problem where without
the quirk, that host controller will die after a usb device is disconnected
from port of root hub, which happened in Synopsis core with Fujitsu
config-free usb phy integrated.

Successfully tested on Fujitsu mb86s7x board.

Sneeker Yeh (3):
  usb: host: f_usb20ho: add support for Fujitsu ehci/ohci USB 2.0 host
    controller
  usb: dwc3: add Fujitsu Specific Glue layer
  usb: dwc3: add a quirk for device disconnection issue in Synopsis
    dwc3 core

 .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   25 ++
 .../devicetree/bindings/usb/fujitsu-ehci.txt       |   22 ++
 drivers/usb/dwc3/Kconfig                           |   11 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-mb86s70.c                    |  194 +++++++++++++
 drivers/usb/host/Kconfig                           |   11 +
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/f_usb20ho_hcd.c                   |  306 ++++++++++++++++++++
 drivers/usb/host/f_usb20ho_hcd.h                   |   35 +++
 drivers/usb/host/xhci-hub.c                        |    4 +
 drivers/usb/host/xhci-plat.c                       |    5 +
 drivers/usb/host/xhci.c                            |   29 ++
 drivers/usb/host/xhci.h                            |    7 +
 13 files changed, 651 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
 create mode 100644 Documentation/devicetree/bindings/usb/fujitsu-ehci.txt
 create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c
 create mode 100644 drivers/usb/host/f_usb20ho_hcd.c
 create mode 100644 drivers/usb/host/f_usb20ho_hcd.h

-- 
1.7.9.5

