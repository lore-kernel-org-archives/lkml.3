Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3HAKgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:36:48 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55270 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3HAKgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:36:44 -0400
From: Rui Wang <ruiv.wang@gmail.com>
To: bhelgaas@google.com
Cc: tony.luck@intel.com, chaohong.guo@intel.com, gong.chen@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Rui Wang <rui.y.wang@intel.com>
Subject: [RFC v2 0/3] I/O Hook: Method for emulating h/w events
Date: Thu,  1 Aug 2013 18:31:30 +0800
Message-Id: <1375353093-3206-1-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

In this v2, I made the following changes according to your suggestion:

	1) The iohook driver is now built-in so we have alot fewer exported
	   symbols. But we still need to export two functions because the
	   loadable modules need to call into the I/O Hook.
	2) Non-PCI part moved from drivers/pci into drivers/misc/iohook
	3) It's now platform neutral. The PCI part should now work on all
	   platforms. The memory mapped I/O part can be easily extened later
	   to non-x86 platforms by modifying their part under arch/

I tested this new version on Westmere-EX. It worked as expected.

Regards,
Rui Wang
Intel Open Source Technology Center

Rui Wang (3):
  I/O Hook: core functions and Register Override
  I/O Hook: kernel interface to manage the hook
  I/O Hook: sysfs interface to emulate h/w events

 Documentation/PCI/iohook.txt      |  282 ++++++++++
 arch/Kconfig                      |   10 +
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/include/asm/io.h         |   57 ++-
 arch/x86/vdso/Makefile            |    2 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/iohook/Makefile      |    1 +
 drivers/misc/iohook/iohook.c      | 1025 +++++++++++++++++++++++++++++++++++++
 drivers/misc/iohook/iohook.h      |    6 +
 drivers/pci/access.c              |   66 +++
 include/linux/reg_ovrd.h          |   51 ++
 11 files changed, 1500 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/PCI/iohook.txt
 create mode 100644 drivers/misc/iohook/Makefile
 create mode 100644 drivers/misc/iohook/iohook.c
 create mode 100644 drivers/misc/iohook/iohook.h
 create mode 100644 include/linux/reg_ovrd.h

-- 
1.7.5.4

