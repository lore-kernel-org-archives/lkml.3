Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbbANQWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:22:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45266 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751331AbbANQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:16 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 00/12] Atmel matrix, SMC and UDC rework
Date: Wed, 14 Jan 2015 17:21:52 +0100
Message-Id: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

The following series replace the previous series sent by Boris named:
 - [PATCH v5 00/11] memory: add Atmel EBI (External Bus Interface) driver
 - [PATCH 00/11] usb: gadget: at91_udc: Rework for multi-platform support

The patches I left out are less urgent and will be resent later, probably for
3.21.

Because of the dependancy between the syscon addition and the at91_udc series,
this can go through the AT91 tree if you giv your ack on the udc patches.

The first 4 patches introduce 2 syscon devices needed to configure the
matrix and SMC.
The following patches rework the at91_udc driver to prepare at91 for
multi-platform support.

It also include several fixes:
 - fix clock names to be consistent with other USB drivers
 - document clocks and clock-names properties in atmel-usb DT bindings doc

and some cleanup changes:
 - remove useless usb_clk
 - allocate at91_udc instance instead of using the statically defined one
 - simplify the probe and remove functions by using devm_ helpers
 - remove !DT specific code

Changes from the previous series:
 - rebased on 3.19-rc1

Boris Brezillon (12):
  mfd: syscon: Add atmel-matrix registers definition
  mfd: syscon: Add Atmel Matrix bus DT binding documentation
  mfd: syscon: Add atmel-smc registers definition
  mfd: syscon: Add Atmel SMC binding doc
  usb: gadget: at91_udc: Fix clock names
  usb: gadget: at91_udc: Drop uclk clock
  usb: gadget: at91_udc: Document DT clocks and clock-names property
  usb: gadget: at91_udc: Remove non-DT handling code
  usb: gadget: at91_udc: Simplify probe and remove functions
  usb: gadget: at91_udc: Rework for multi-platform kernel support
  usb: gadget: at91_udc: Update DT binding documentation
  usb: gadget: at91_udc: Allocate udc instance

 .../devicetree/bindings/mfd/atmel-matrix.txt       |  24 +
 .../devicetree/bindings/mfd/atmel-smc.txt          |  19 +
 .../devicetree/bindings/usb/atmel-usb.txt          |  10 +-
 drivers/usb/gadget/udc/Kconfig                     |   1 +
 drivers/usb/gadget/udc/at91_udc.c                  | 525 +++++++++++----------
 drivers/usb/gadget/udc/at91_udc.h                  |   9 +-
 include/linux/mfd/syscon/atmel-matrix.h            | 117 +++++
 include/linux/mfd/syscon/atmel-smc.h               | 173 +++++++
 8 files changed, 623 insertions(+), 255 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
 create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
 create mode 100644 include/linux/mfd/syscon/atmel-smc.h

-- 
2.1.0

