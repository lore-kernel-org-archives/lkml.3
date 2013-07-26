Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3GZG4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:56:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51852 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3GZG4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:56:15 -0400
From: Rui Wang <ruiv.wang@gmail.com>
To: bhelgaas@google.com
Cc: tony.luck@intel.com, chaohong.guo@intel.com, gong.chen@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>
Subject: [RFC 0/3] IO Hook: Method for emulating h/w events
Date: Fri, 26 Jul 2013 14:51:12 +0800
Message-Id: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

This was originally the method I used to test hotplug on Intel SDV machines
which are not capable of doing hotplug. I would like to present it here in
case it interests the community, then it can be made available to a wider
range of developers who are working on hotplug.

I used it to generate desired ACPI events, PCI interrupts, and more. So
things like CPU hotplug, IOH hotplug, memory hotplug, PCI native hotplug,
PCI AER injection can be emulated and tested easily.

The best thing is that, it doesn't require any modification to those drivers
involved. It works with whatever hardware events that the user can imagine.
Further development in user-space using scripts may help simplify the usage
model and add more software-defined logic on hardware.

Because it modifies the heart of all h/w access functions, I used Jump Label
to reduce the performance penalty to effectively zero.

I tested the performance by repeatedly running lspci, which calls into the
pci access functions. There's no added overhead observed.

Regards,
Rui Wang
Intel Open Source Technology Center

Rui Wang (3):
  IO Hook: core functions and Register Override
  IO Hook: kernel interface to manage the hook
  IO Hook: sysfs interface to emulate h/w events

 Documentation/PCI/iohook.txt      |  290 +++++++++++++++++
 arch/x86/Kconfig                  |    7 +
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/include/asm/io.h         |   58 ++++-
 arch/x86/vdso/Makefile            |    2 +
 drivers/misc/Kconfig              |    1 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/iohook/Kconfig       |    5 +
 drivers/misc/iohook/Makefile      |    1 +
 drivers/misc/iohook/iohook.c      |  503 +++++++++++++++++++++++++++++
 drivers/pci/access.c              |  630 +++++++++++++++++++++++++++++++++++++
 include/linux/reg_ovrd.h          |   55 ++++
 12 files changed, 1552 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/PCI/iohook.txt
 create mode 100644 drivers/misc/iohook/Kconfig
 create mode 100644 drivers/misc/iohook/Makefile
 create mode 100644 drivers/misc/iohook/iohook.c
 create mode 100644 include/linux/reg_ovrd.h

-- 
1.7.5.4

