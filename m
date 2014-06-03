Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbaFCUEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:04:40 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53197 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933671AbaFCUEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:04:37 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v5 00/15] Thunderbolt driver for Apple MacBooks
Date: Tue,  3 Jun 2014 22:03:57 +0200
Message-Id: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Updated version of the driver. Includes changes by Matthew to make it work on
Falcon Ridge hardware (present in the newest Mac(Book)Pro). 

Changes since v4 (suggested by Matthew):
 - Changed the PCI quirks to check just for Apple hardware instead of checking
   against a list of machines. (The PCI id check already restricts this quirk
to the relevant Apple machines).
 - Added Falcon Ridge PCI id to the driver and to the "wait_for_thunderbolt"
   quirk (the "poweroff_thunderbolt" quirk is no longer necessary for Falcon
Ridge devices).
 - Fixed plug events for Falcon Ridge hardware.

@Matthew: I think that your patch was missing the Falcon Ridge PCI id within
the wait_for_thunderbolt quirk (I have added it). If you have time could you
verify that suspend/resume works on your MacPro?  Thanks!

As before Matthew's ACPI changes (latest version: [1]) are required for this to
work properly. Without them you need to boot with a coldplugged TB device to
prevent the firmware from disabling the controller.

Thanks,
Andreas

[1]: https://lkml.org/lkml/2014/6/1/165 


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
 drivers/pci/quirks.c              | 104 ++++++
 drivers/thunderbolt/Kconfig       |  12 +
 drivers/thunderbolt/Makefile      |   3 +
 drivers/thunderbolt/cap.c         | 116 ++++++
 drivers/thunderbolt/ctl.c         | 731 ++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/ctl.h         |  75 ++++
 drivers/thunderbolt/eeprom.c      | 189 ++++++++++
 drivers/thunderbolt/nhi.c         | 677 +++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/nhi.h         | 114 ++++++
 drivers/thunderbolt/nhi_regs.h    | 101 ++++++
 drivers/thunderbolt/path.c        | 215 +++++++++++
 drivers/thunderbolt/switch.c      | 498 ++++++++++++++++++++++++++
 drivers/thunderbolt/tb.c          | 431 ++++++++++++++++++++++
 drivers/thunderbolt/tb.h          | 266 ++++++++++++++
 drivers/thunderbolt/tb_regs.h     | 213 +++++++++++
 drivers/thunderbolt/tunnel_pci.c  | 232 ++++++++++++
 drivers/thunderbolt/tunnel_pci.h  |  30 ++
 include/asm-generic/vmlinux.lds.h |   3 +
 include/linux/pci.h               |  12 +-
 22 files changed, 4038 insertions(+), 5 deletions(-)
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
2.0.0

