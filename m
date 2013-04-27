Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3D0HFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:05:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:4157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab3D0HFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="303853841"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 0/5] TXT driver
Date: Sat, 27 Apr 2013 22:56:15 +0800
Message-Id: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module is expected to be a better tool to access below resources
  - TXT config space
  - TXT heap
  - Tboot log mem
  - SMX parameter

Intel TXT (Trusted Execution Technology) will provide higher assurance
of system configuration and initial state as well as data reset
protection. It also helps solve real end user concerns about having
confidence that their hardware is running the VMM or kernel that
it was configured with, especially since they may be responsible for
providing such assurances to VMs and services running on it.

See <http://www.intel.com/technology/security/> for more information
about Intel(R) TXT.

Intel TXT configuration registers are a subset of chipset registers.
These chipset registers that interact with SMX are accessed from two
regions of memory, which represent the public and private configuration
spaces, by system software using memory read/write protocols.

Intel TXT Heap memory is a region of physically contiguous memory
which is set aside by BIOS for the use of Intel TXT hardware and
software.

With this module, it will be easier to access TXT/tboot related
information/logs.

Qiaowei Ren (5):
  driver: add TXT driver in kernel
  driver: provide sysfs interfaces to access TXT config space
  driver: provide sysfs interfaces to access TXT log
  driver: provide sysfs interfaces to access SMX parameter
  driver: provide sysfs interfaces to access TXT heap

 drivers/char/Kconfig             |    2 +
 drivers/char/Makefile            |    1 +
 drivers/char/txt/Kconfig         |   18 +
 drivers/char/txt/Makefile        |    5 +
 drivers/char/txt/txt-config.c    | 1041 ++++++++++++++++++++++++
 drivers/char/txt/txt-config.h    |  138 ++++
 drivers/char/txt/txt-heap.c      | 1616 ++++++++++++++++++++++++++++++++++++++
 drivers/char/txt/txt-heap.h      |  338 ++++++++
 drivers/char/txt/txt-log.c       |  140 ++++
 drivers/char/txt/txt-log.h       |   27 +
 drivers/char/txt/txt-parameter.c |  261 ++++++
 drivers/char/txt/txt-parameter.h |   40 +
 drivers/char/txt/txt-sysfs.c     |   68 ++
 13 files changed, 3695 insertions(+)
 create mode 100644 drivers/char/txt/Kconfig
 create mode 100644 drivers/char/txt/Makefile
 create mode 100644 drivers/char/txt/txt-config.c
 create mode 100644 drivers/char/txt/txt-config.h
 create mode 100644 drivers/char/txt/txt-heap.c
 create mode 100644 drivers/char/txt/txt-heap.h
 create mode 100644 drivers/char/txt/txt-log.c
 create mode 100644 drivers/char/txt/txt-log.h
 create mode 100644 drivers/char/txt/txt-parameter.c
 create mode 100644 drivers/char/txt/txt-parameter.h
 create mode 100644 drivers/char/txt/txt-sysfs.c

-- 
1.7.9.5

