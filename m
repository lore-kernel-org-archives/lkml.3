Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaEaO2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:28:30 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:38209 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbaEaO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:28:28 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Date: Sat, 31 May 2014 16:27:45 +0200
Message-Id: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is version 4 of my Thunderbolt driver for Apple hardware (see [1] for v3).

Changes since v3:
 - Fix typos and style problems caught by Bjorn.
 - Changed the #ifdef CONFIG_ACPI block to cover the whole pci quirk.

Andreas

[1]: https://lkml.org/lkml/2014/5/26/308


Andreas Noever (15):
  thunderbolt: Add initial cactus ridge NHI support
  thunderbolt: Add control channel interface
  thunderbolt: Setup control channel
  thunderbolt: Add tb_regs.h
  thunderbolt: Initialize root switch and ports
  thunderbolt: Add thunderbolt capability handling
  thunderbolt: Enable plug events
  thunderbolt: Scan for downstream switches
  thunderbolt: Handle hotplug events
  thunderbolt: Add path setup code.
  thunderbolt: Add support for simple pci tunnels
  PCI: Add pci_fixup_suspend_late quirk pass
  PCI: Suspend/resume quirks for Apple thunderbolt
  thunderbolt: Read switch uid from EEPROM
  thunderbolt: Add suspend/hibernate support

 drivers/Kconfig                   |   2 +
 drivers/Makefile                  |   1 +
 drivers/pci/pci-driver.c          |  18 +-
 drivers/pci/quirks.c              | 129 +++++++
 drivers/thunderbolt/Kconfig       |  12 +
 drivers/thunderbolt/Makefile      |   3 +
 drivers/thunderbolt/cap.c         | 116 ++++++
 drivers/thunderbolt/ctl.c         | 731 ++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/ctl.h         |  75 ++++
 drivers/thunderbolt/eeprom.c      | 189 ++++++++++
 drivers/thunderbolt/nhi.c         | 672 +++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/nhi.h         | 114 ++++++
 drivers/thunderbolt/nhi_regs.h    | 101 ++++++
 drivers/thunderbolt/path.c        | 215 +++++++++++
 drivers/thunderbolt/switch.c      | 492 +++++++++++++++++++++++++
 drivers/thunderbolt/tb.c          | 431 ++++++++++++++++++++++
 drivers/thunderbolt/tb.h          | 266 ++++++++++++++
 drivers/thunderbolt/tb_regs.h     | 213 +++++++++++
 drivers/thunderbolt/tunnel_pci.c  | 232 ++++++++++++
 drivers/thunderbolt/tunnel_pci.h  |  30 ++
 include/asm-generic/vmlinux.lds.h |   3 +
 include/linux/pci.h               |  12 +-
 22 files changed, 4052 insertions(+), 5 deletions(-)
 create mode 100644 drivers/thunderbolt/Kconfig
 create mode 100644 drivers/thunderbolt/Makefile
 create mode 100644 drivers/thunderbolt/cap.c
 create mode 100644 drivers/thunderbolt/ctl.c
 create mode 100644 drivers/thunderbolt/ctl.h
 create mode 100644 drivers/thunderbolt/eeprom.c
 create mode 100644 drivers/thunderbolt/nhi.c
 create mode 100644 drivers/thunderbolt/nhi.h
 create mode 100644 drivers/thunderbolt/nhi_regs.h
 create mode 100644 drivers/thunderbolt/path.c
 create mode 100644 drivers/thunderbolt/switch.c
 create mode 100644 drivers/thunderbolt/tb.c
 create mode 100644 drivers/thunderbolt/tb.h
 create mode 100644 drivers/thunderbolt/tb_regs.h
 create mode 100644 drivers/thunderbolt/tunnel_pci.c
 create mode 100644 drivers/thunderbolt/tunnel_pci.h

-- 
1.9.3

