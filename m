Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3APQiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:38:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3APQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:38:19 -0500
Subject: [PATCH 00/10] goldfish: still swimming
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Wed, 16 Jan 2013 16:58:25 +0000
Message-ID: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the newer macros and platform_driver stuff. The device registration is
cleaned up as suggested by Arnd and it does indeed look better that way.

Alan

---

Arve Hjønnevåg (4):
      goldfish: tty driver
      goldfish: framebuffer
      goldfish: real time clock
      goldfish: NAND flash driver

Brian Swetland (1):
      goldfish: virtual input event driver

David 'Digit' Turner (1):
      goldfish: add QEMU pipe driver

Jun Nakajima (2):
      goldfish: definitions for Goldfish on x86 platforms
      goldfish: add the goldfish virtual bus

Mike Lockwood (2):
      goldfish: emulated MMC device
      goldfish: power device


 arch/x86/Kconfig                          |   12 +
 arch/x86/platform/Makefile                |    1 
 arch/x86/platform/goldfish/Makefile       |    1 
 arch/x86/platform/goldfish/goldfish.c     |   51 ++
 drivers/input/keyboard/Kconfig            |   11 +
 drivers/input/keyboard/Makefile           |    1 
 drivers/input/keyboard/goldfish_events.c  |  187 +++++++++
 drivers/mmc/host/Kconfig                  |    7 
 drivers/mmc/host/Makefile                 |    1 
 drivers/mmc/host/goldfish.c               |  566 +++++++++++++++++++++++++++
 drivers/mtd/devices/Kconfig               |    7 
 drivers/mtd/devices/Makefile              |    3 
 drivers/mtd/devices/goldfish_nand.c       |  464 ++++++++++++++++++++++
 drivers/mtd/devices/goldfish_nand_reg.h   |   72 +++
 drivers/platform/Kconfig                  |    4 
 drivers/platform/Makefile                 |    1 
 drivers/platform/goldfish/Kconfig         |    5 
 drivers/platform/goldfish/Makefile        |    5 
 drivers/platform/goldfish/goldfish_pipe.c |  618 +++++++++++++++++++++++++++++
 drivers/platform/goldfish/pdev_bus.c      |  237 +++++++++++
 drivers/power/Kconfig                     |    8 
 drivers/power/Makefile                    |    1 
 drivers/power/goldfish_battery.c          |  251 ++++++++++++
 drivers/rtc/Kconfig                       |    9 
 drivers/rtc/Makefile                      |    1 
 drivers/rtc/rtc-goldfish.c                |  140 +++++++
 drivers/tty/Kconfig                       |    6 
 drivers/tty/Makefile                      |    1 
 drivers/tty/goldfish.c                    |  332 ++++++++++++++++
 drivers/video/Kconfig                     |    9 
 drivers/video/Makefile                    |    1 
 drivers/video/goldfishfb.c                |  316 +++++++++++++++
 32 files changed, 3327 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/platform/goldfish/Makefile
 create mode 100644 arch/x86/platform/goldfish/goldfish.c
 create mode 100644 drivers/input/keyboard/goldfish_events.c
 create mode 100644 drivers/mmc/host/goldfish.c
 create mode 100644 drivers/mtd/devices/goldfish_nand.c
 create mode 100644 drivers/mtd/devices/goldfish_nand_reg.h
 create mode 100644 drivers/platform/goldfish/Kconfig
 create mode 100644 drivers/platform/goldfish/Makefile
 create mode 100644 drivers/platform/goldfish/goldfish_pipe.c
 create mode 100644 drivers/platform/goldfish/pdev_bus.c
 create mode 100644 drivers/power/goldfish_battery.c
 create mode 100644 drivers/rtc/rtc-goldfish.c
 create mode 100644 drivers/tty/goldfish.c
 create mode 100644 drivers/video/goldfishfb.c

-- 
What lives under the sea and carries a lot of people?
An Octobus

