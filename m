Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaEZPSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:18:24 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64279 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:18:22 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v3 00/15] Thunderbolt driver for Apple MacBooks 
Date: Mon, 26 May 2014 17:17:57 +0200
Message-Id: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is version 3 of my Thunderbolt driver for Apple hardware (see [1] for v2).

Changes since v2:
 - Use pci quirks instead of changing the pcie port driver.
 - Relax the DMI checks to run on all MacBooks with a Cactus Ridge chip (MBP
   Mid 2012 - Early 2013, MBA Mid 2012 - Early 2014). I have tested the driver
on my early 2013 MBP and have gotten reports of it working on a MBA mid 2013).
 - Fix some typos.

Limitations & Notes:
 - No chaining
 - No Apple TB display (non TB displays work)
 - Requires Matthew's acpi fixes [2]
 - Hibernate only works if you resume with the same (or similar) devices as
   during the initial boot. The memory layout reported by efi depends on
whether TB devices are connected during boot and linux refuses to resumeif the
total amount of memory differs. Suspend works fine.
 - No device handoff. The driver will not properly resume a device that was
   initially coldplugged. Unplug/replug works fine though.

To ease testing a git repository based on 3.15-rc7 can be found at:

	https://github.com/anoever/thunderbolt

The repository includes Matthew's patches.


Would it be possible to get this into 3.16?

Thanks, Andreas

[1]: https://lkml.org/lkml/2014/4/10/681
[2]: https://lkml.org/lkml/2014/3/11/619

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
  thunderbolt: Add support for simple pci tunnels.
  pci: Add pci_fixup_suspend_late quirk pass.
  pci: Suspend/resume quirks for appel thunderbolt
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

