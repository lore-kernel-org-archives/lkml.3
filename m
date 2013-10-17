Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607Ab3JQU2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:28:43 -0400
Received: from dukecmmtar03.coxmail.com ([68.99.120.44]:43198 "EHLO
	dukecmmtar03.coxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3JQU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:28:41 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 0/2 v4] usb: ohci: remove ep93xx bus glue platform driver
Date: Thu, 17 Oct 2013 13:27:25 -0700
User-Agent: KMail/1.9.9
Cc: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, stern@rowland.harvard.edu,
        Lennert Buytenhek <buytenh@wantstofly.org>, gregkh@linuxfoundation.org,
        olof@lixom.net, Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201310171327.26042.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refresh the ep93xx_defconfig then remove the ep93xx OHCI bus glue
driver in favor of the Generic OHCI driver for a platform device.

v4: propagate errno from clk_enable() in ep93xx_ohci_power_on().

v3: split patch to refresh the ep93xx_defconfig before removing
    ohci-ep93xx.c in favor of the Generic OHCI driver for a
    platform device.

v2: Use the (*power_off) callback for (*power_suspend), as
    suggested by Alan Stern.
    Remove the Kconfig change to USB_OHCI_HCD_PLATFORM and
    refresh the ep93xx_defconfig to enable this option, as
    suggested by Alan Stern.


H Hartley Sweeten (2):
  ARM: ep93xx_defconfig: cleanup ep93xx_defconfig
  usb: ohci: remove ep93xx bus glue platform driver

 arch/arm/configs/ep93xx_defconfig |  17 +---
 arch/arm/mach-ep93xx/clock.c      |   2 +-
 arch/arm/mach-ep93xx/core.c       |  38 +++++++-
 drivers/usb/host/ohci-ep93xx.c    | 184 --------------------------------------
 drivers/usb/host/ohci-hcd.c       |  18 ----
 5 files changed, 38 insertions(+), 221 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-ep93xx.c

-- 
1.8.3.2

