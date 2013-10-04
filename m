Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3JDQhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:37:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:58293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3JDQhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:37:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1034,1371106800"; 
   d="scan'208";a="387960648"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, len.brown@intel.com,
        rjw@sisk.pl, arjan@linux.intel.com, jacob.jun.pan@linux.intel.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH v2 0/6] Power Capping Framework and RAPL Driver
Date: Fri,  4 Oct 2013 09:36:50 -0700
Message-Id: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overview
With the evolution of technologies, which enables power monitoring and limiting,
more and more devices are able to constrain their power consumption under certain
limits. There are several use cases for such technologies:
- Power monitoring: Each device can report its power consumption.
- Power Limiting: Setting power limits on the devices allows users to guard against
platform reaching max system power level.
- Maximize performance: While staying below a power limit, it allows devices to
automatically adjust performance to meet demands
- Dynamic control and re-budgeting: If each device can be constrained to some power,
extra power can redistributed to other devices, which needs additional performance.

One such example of technologies is RAPL (Running Average Power Limit) mechanism
available in the latest Intel processors. Intel is slowly adding many devices under
RAPL control. Also there are other technologies available, for power capping various
devices. Soon it is very likely that other vendors are also adding or considering
such implementation.

Power Capping framework is an effort to have a uniform interface available to Linux
drivers, which will enable
- A uniform sysfs interface for all devices which can offer power capping
- A common API for drivers, which will avoid code duplication and easy
implementation of client drivers.

Also submitting Intel RAPL driver using power capping framework.

History:
v2
As suggested, added BIT_ULL_MASK and BIT_ULL_WORD

v1
Incorporated changes suggested during RFC stage

Jacob Pan (2):
  x86/msr: add 64bit _on_cpu access functions
  Introduce Intel RAPL power capping driver

Srinivas Pandruvada (4):
  PowerCap: Documentation
  PowerCap: Add class driver
  PowerCap: Added to drivers build
  bitops: Introduce BIT_ULL

 Documentation/ABI/testing/sysfs-class-powercap |  152 +++
 Documentation/power/powercap/powercap.txt      |  236 ++++
 arch/x86/include/asm/msr.h                     |   22 +
 arch/x86/lib/msr-smp.c                         |   62 ++
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    1 +
 drivers/powercap/Kconfig                       |   31 +
 drivers/powercap/Makefile                      |    2 +
 drivers/powercap/intel_rapl.c                  | 1395 ++++++++++++++++++++++++
 drivers/powercap/powercap_sys.c                |  699 ++++++++++++
 include/linux/bitops.h                         |    3 +
 include/linux/powercap.h                       |  325 ++++++
 12 files changed, 2930 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-powercap
 create mode 100644 Documentation/power/powercap/powercap.txt
 create mode 100644 drivers/powercap/Kconfig
 create mode 100644 drivers/powercap/Makefile
 create mode 100644 drivers/powercap/intel_rapl.c
 create mode 100644 drivers/powercap/powercap_sys.c
 create mode 100644 include/linux/powercap.h

-- 
1.8.3.1

