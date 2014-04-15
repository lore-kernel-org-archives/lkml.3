Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaDON7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:59:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:27346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDON7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="513522509"
From: Rui Wang <rui.y.wang@intel.com>
To: bhelgaas@google.com, tony.luck@intel.com, rafael.j.wysocki@intel.com
Cc: ruiv.wang@gmail.com, chaohong.guo@intel.com, dave.hansen@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v3 0/5] I/O Hook: Trace h/w access and emulate h/w events
Date: Tue, 15 Apr 2014 21:48:06 +0800
Message-Id: <1397569691-24691-1-git-send-email-rui.y.wang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
This is the 3rd version of I/O Hook, a patch set aimed at intercepting
h/w access by the OS. Some examples of how it can be used:
        1) To emulate h/w events (e.g. hotplug)
        2) To inject h/w errors to the kernel
        3) To trace h/w access by the OS for performance tuning or debugging.
Details of the examples can be found in Documentation/PCI/iohook.txt.

A set of user space tools using I/O Hook for various use cases will be hosted
on https://github.com/iohook. It initially contains inject-aer which takes the
trace event output of /sys/kernel/debug/tracing/events/ras/aer_event/ and
regenerate the same PCIE AER event so that PCIE AER can be easily tested.

Changes since v2:
        - Added the hook for MSRs (can specify a cpu number)
        - Can trigger IPI by a vector (so that exceptions can be emulated)
        - Defined iohook_event as the trace event to trace h/w access. A new
          attribute 'tc' can be defined for any Register Override for tracing
          purpose.

Rui Wang (5):
  I/O Hook: core functions and Register Override
  I/O Hook: Help functions to manage the hook
  I/O Hook: sysfs interface to emulate h/w events
  I/O Hook: Override MSRs while triggering MCEs
  IO Hook: Tracing hw access

 Documentation/PCI/iohook.txt      |  353 ++++++++++
 arch/Kconfig                      |   10 +
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/include/asm/io.h         |   57 ++-
 arch/x86/include/asm/msr.h        |  100 +++-
 arch/x86/lib/msr-smp.c            |   31 +
 arch/x86/vdso/Makefile            |    2 +
 drivers/misc/Makefile             |    1 +
 drivers/misc/iohook/Makefile      |    1 +
 drivers/misc/iohook/iohook.c      | 1367 +++++++++++++++++++++++++++++++++++++
 drivers/misc/iohook/iohook.h      |    6 +
 drivers/pci/access.c              |   66 ++
 include/linux/reg_ovrd.h          |   55 ++
 include/trace/events/iohook.h     |   58 ++
 14 files changed, 2101 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/PCI/iohook.txt
 create mode 100644 drivers/misc/iohook/Makefile
 create mode 100644 drivers/misc/iohook/iohook.c
 create mode 100644 drivers/misc/iohook/iohook.h
 create mode 100644 include/linux/reg_ovrd.h
 create mode 100644 include/trace/events/iohook.h

-- 
1.7.5.4

