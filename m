Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3FZBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:53:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:27521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FZBxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="scan'208";a="359621635"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, dvhart@linux.intel.com
Subject: [PATCH 0/8] MinnowBoard support
Date: Tue, 25 Jun 2013 18:53:20 -0700
Message-Id: <cover.1372211451.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add support for the MinnowBoard:

http://www.minnowboard.org

The MinnowBoard is an E6xx Atom CPU paired with an EG20T PCH on a small
(4.25" x 4.25") board with USB, MMC, SATA, Ethernet, audio, GPIO, GPIO
buttons, GPIO LEDs, and EMGD graphics. It has an expansion connector
allowing for daughter cards (Lures) to access things like I2C, SPI, CAN,
UARTs, GPIO, LVDS, SATA and USB. The Lure specification is available
here:

http://www.elinux.org/Minnowboard:Lures_Specifications

This is a rather unique x86 board and the platform drivers are
admittedly atypical for x86. They are intended to provide board-specifc
support where no discovery is possible as well as example drivers and
convenient access to the available GPIO. Future improvements may include
ACPI versions of these drivers, which would at least make them
discoverable.

The following changes since commit 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-06-25 09:08:07 -1000)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-2.6.git minnow/platform-v1
  ssh://git.infradead.org/srv/git/users/dvhart/linux-2.6.git minnow/platform-v1
  http://git.infradead.org/users/dvhart/linux-2.6.git/shortlog/refs/heads/minnow/platform-v1

Darren Hart (8):
  pch_gbe: Use PCH_GBE_PHY_REGS_LEN instead of 32
  pch_uart: Add uart_clk selection for the MinnowBoard
  gpio-sch: Add sch_gpio_resume_set_enable()
  minnowboard: Add base platform driver for the MinnowBoard
  minnowboard-gpio: Export MinnowBoard expansion GPIO
  minnowboard-keys: Bind MinnowBoard buttons to arrow keys
  pci: Add CircuitCo VENDOR ID and MinnowBoard DEVICE ID
  pch_gbe: Add MinnowBoard support

 drivers/gpio/gpio-sch.c                            |  24 +++
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig      |   1 +
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |   2 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  34 +++-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c    |  89 ++++++++++
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.h    |   2 +
 drivers/platform/x86/Kconfig                       |  52 ++++++
 drivers/platform/x86/Makefile                      |   3 +
 drivers/platform/x86/minnowboard-gpio.c            | 115 ++++++++++++
 drivers/platform/x86/minnowboard-gpio.h            |  60 +++++++
 drivers/platform/x86/minnowboard-keys.c            | 108 ++++++++++++
 drivers/platform/x86/minnowboard.c                 | 193 +++++++++++++++++++++
 drivers/tty/serial/pch_uart.c                      |   5 +
 include/linux/gpio-sch.h                           |   6 +
 include/linux/minnowboard.h                        |  37 ++++
 include/linux/pci_ids.h                            |   3 +
 16 files changed, 733 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/x86/minnowboard-gpio.c
 create mode 100644 drivers/platform/x86/minnowboard-gpio.h
 create mode 100644 drivers/platform/x86/minnowboard-keys.c
 create mode 100644 drivers/platform/x86/minnowboard.c
 create mode 100644 include/linux/gpio-sch.h
 create mode 100644 include/linux/minnowboard.h

-- 
1.8.1.2

