Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3EGHFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:05:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:5460 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3EGHFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="298699177"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 0/4] Intel TXT driver 
Date: Tue,  7 May 2013 22:55:15 +0800
Message-Id: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module is expected to be a better tool to access below resources
  - TXT config space
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

With this module, it will be easier to access TXT/tboot related
information/logs.

Qiaowei Ren (4):
  driver: add TXT driver in kernel
  driver: provide sysfs interfaces to access TXT config space
  driver: provide sysfs interfaces to access TXT log
  driver: provide sysfs interfaces to access SMX parameter

 Documentation/ABI/testing/sysfs-platform-intel-txt |  402 ++++++++
 drivers/platform/x86/Kconfig                       |    2 +
 drivers/platform/x86/Makefile                      |    1 +
 drivers/platform/x86/intel_txt/Kconfig             |   17 +
 drivers/platform/x86/intel_txt/Makefile            |    5 +
 drivers/platform/x86/intel_txt/txt-config.c        | 1032 ++++++++++++++++++++
 drivers/platform/x86/intel_txt/txt-config.h        |  138 +++
 drivers/platform/x86/intel_txt/txt-log.c           |  131 +++
 drivers/platform/x86/intel_txt/txt-log.h           |   27 +
 drivers/platform/x86/intel_txt/txt-parameter.c     |  253 +++++
 drivers/platform/x86/intel_txt/txt-parameter.h     |   40 +
 drivers/platform/x86/intel_txt/txt-sysfs.c         |   60 ++
 12 files changed, 2108 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-txt
 create mode 100644 drivers/platform/x86/intel_txt/Kconfig
 create mode 100644 drivers/platform/x86/intel_txt/Makefile
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.h
 create mode 100644 drivers/platform/x86/intel_txt/txt-log.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-log.h
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.h
 create mode 100644 drivers/platform/x86/intel_txt/txt-sysfs.c

-- 
1.7.9.5

