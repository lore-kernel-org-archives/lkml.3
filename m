Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3EMJeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:34:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:21520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab3EMJef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="336184368"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v2 0/3] Intel TXT driver
Date: Tue, 14 May 2013 01:24:41 +0800
Message-Id: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changeslog from v1:
  * remove tboot log code
  * add terms description in commit log and comment at the top of the driver
  * check whether a platform has TXT support before registering a device 

This module is expected to be a better tool to access below resources
  - TXT config space
  - SMX parameter

Intel TXT (Trusted Execution Technology) will provide higher assurance
of system configuration and initial state as well as data reset
protection. It also helps solve real end user concerns about having
confidence that their hardware is running the VMM or kernel that
it was configured with, especially since they may be responsible for
providing such assurances to VMs and services running on it.

See Documentation/intel_txt.txt for more information about Intel TXT.

Intel TXT configuration registers are a subset of chipset registers.
These chipset registers that interact with SMX are accessed from two
regions of memory, which represent the public and private configuration
spaces, by system software using memory read/write protocols.

Safer Mode Extensions (SMX) provide a processor's programming
interface in an Intel TXT platform for system software to establish
a measured environment within the platform to support trust decisions
by end users.

With this module, it will be easier to access TXT related information.

Qiaowei Ren (3):
  driver: add TXT driver in kernel
  driver: provide sysfs interfaces to access TXT config space
  driver: provide sysfs interfaces to access SMX parameter

 Documentation/ABI/testing/sysfs-platform-intel-txt |  382 ++++++++
 drivers/platform/x86/Kconfig                       |    2 +
 drivers/platform/x86/Makefile                      |    1 +
 drivers/platform/x86/intel_txt/Kconfig             |   27 +
 drivers/platform/x86/intel_txt/Makefile            |    5 +
 drivers/platform/x86/intel_txt/txt-config.c        | 1029 ++++++++++++++++++++
 drivers/platform/x86/intel_txt/txt-config.h        |  138 +++
 drivers/platform/x86/intel_txt/txt-parameter.c     |  254 +++++
 drivers/platform/x86/intel_txt/txt-parameter.h     |   39 +
 drivers/platform/x86/intel_txt/txt-sysfs.c         |   79 ++
 10 files changed, 1956 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-txt
 create mode 100644 drivers/platform/x86/intel_txt/Kconfig
 create mode 100644 drivers/platform/x86/intel_txt/Makefile
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.h
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.h
 create mode 100644 drivers/platform/x86/intel_txt/txt-sysfs.c

-- 
1.7.9.5

