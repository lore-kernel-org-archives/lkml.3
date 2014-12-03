Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaLCLcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:32:22 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39263 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753095AbaLCLcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:32:15 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 00/11] usb: gadget: at91_udc: Rework for multi-platform support
Date: Wed,  3 Dec 2014 12:31:59 +0100
Message-Id: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series reworks the at91_udc driver to prepare at91 for multi-platform
support.

It also include several fixes:
 - fix clock names to be consistent with other USB drivers
 - document clocks and clock-names properties in atmel-usb DT bindings doc

and some cleanup changes:
 - remove useless usb_clk
 - allocate at91_udc instance instead of using the statically defined one
 - simplify the probe and remove functions by using devm_ helpers
 - remove !DT specific code

The series depends on this patch [1] (which adds matrix registers definition).

Regards,

Boris

[1]https://lkml.org/lkml/2014/12/3/230

Boris Brezillon (11):
  usb: gadget: at91_udc: Fix clock names
  usb: gadget: at91_udc: Drop uclk clock
  usb: gadget: at91_udc: Document DT clocks and clock-names property
  ARM: at91/dt: at91sam9261: fix clocks and clock-names in udc
    definition
  usb: gadget: at91_udc: Remove non-DT handling code
  usb: gadget: at91_udc: Simplify probe and remove functions
  usb: gadget: at91_udc: Rework for multi-platform kernel support
  usb: gadget: at91_udc: Update DT binding documentation
  usb: gadget: at91_udc: Allocate udc instance
  ARM: at91/dt: declare matrix node as a syscon device
  ARM: at91/dt: fix at91 udc compatible strings

 .../devicetree/bindings/usb/atmel-usb.txt          |  10 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |   2 +-
 arch/arm/boot/dts/at91sam9261.dtsi                 |   9 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |   2 +-
 drivers/usb/gadget/udc/Kconfig                     |   1 +
 drivers/usb/gadget/udc/at91_udc.c                  | 530 +++++++++++----------
 drivers/usb/gadget/udc/at91_udc.h                  |   9 +-
 7 files changed, 298 insertions(+), 265 deletions(-)

-- 
1.9.1

