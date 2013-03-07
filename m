Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3CGNWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:22:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53825 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758727Ab3CGNWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:22:12 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <s-guiriec@ti.com>, <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ruchika@ti.com>
Subject: [PATCH v2 0/4] usb: added palmas-usb driver and a few misc fixes
Date: Thu, 7 Mar 2013 18:51:42 +0530
Message-ID: <1362662506-14823-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added palmas-usb driver which is mainly used as comparator driver to
detect vbus/id events when a USB cable is connected and passes on the
event information to omap glue (dwc3-omap.c)

The other fixes include setting dma_mask for dwc3 device since device
tree doesn't fill dma_mask, returning EPROBE_DEFER if probe has not yet
called and replace *_* with *-* in property names in musb glue since
that is the usual convention followed.

Developed this patches on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git testing

Changes from v1:
* set the dma_mask for dwc3_omap (instead of setting dma_mask for dwc3
core from dwc3-omap.c)
* return '0' from dwc3_omap_mailbox on success (instead of hacky IRQ_HANDLED)
It is now handled using mailboxstat member in palmas_usb.
* Made compatible in palmas-usb to include *ti,twl6035-usb*

Graeme Gregory (1):
  USB: Palmas OTG Transceiver Driver

Kishon Vijay Abraham I (3):
  usb: dwc3: set dma_mask for dwc3_omap device
  usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe has not yet
    executed
  usb: musb: omap2430: replace *_* with *-* in property names

 Documentation/devicetree/bindings/usb/omap-usb.txt |   12 +-
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   15 +
 drivers/usb/dwc3/core.c                            |    4 +
 drivers/usb/dwc3/dwc3-omap.c                       |   10 +-
 drivers/usb/musb/omap2430.c                        |    6 +-
 drivers/usb/otg/Kconfig                            |    6 +
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/palmas-usb.c                       |  396 ++++++++++++++++++++
 include/linux/mfd/palmas.h                         |    7 +-
 include/linux/usb/dwc3-omap.h                      |    6 +-
 10 files changed, 448 insertions(+), 15 deletions(-)
 create mode 100644 drivers/usb/otg/palmas-usb.c

-- 
1.7.10.4

