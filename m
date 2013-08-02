Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3HBSI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:15984 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3HBSIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380916735"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v01 0/3] Power Capping Framework
Date: Fri,  2 Aug 2013 11:08:49 -0700
Message-Id: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highlights
As suggested
- Didn't use any raw kobject calls, only using device_xx calls.
- No device_create_file/device_remove_file for attributes, so that
user space can see all attributes when notification is received for
device creation.

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

One such example of technology is RAPL (Running Average Power Limit) mechanism
available in the latest Intel Processors. Intel is slowly adding many devices under
RAPL control. Also there are other technologies available, for power capping various
devices. Soon it is very likely that other vendors are also adding or considering
such implementation.

Power Capping framework is an effort to have a uniform interface available to Linux
drivers, which will enable
- A uniform sys-fs interface for all devices which can offer power capping
- A common API for drivers, which will avoid code duplication and easy
implementation of client drivers.

Once this framework is approved, we will submit a RAPL client driver using this
framework.

Revisions:

v01:
Use device model only to register zones and controllers.

v00:
Presented options


Srinivas Pandruvada (3):
  PowerCap: Documentation
  PowerCap: Add class driver
  PowerCap: Added to drivers build

 Documentation/powercap/PowerCappingFramework.txt | 677 ++++++++++++++++
 drivers/Kconfig                                  |   2 +
 drivers/Makefile                                 |   1 +
 drivers/powercap/Kconfig                         |  16 +
 drivers/powercap/Makefile                        |   5 +
 drivers/powercap/powercap_sys.c                  | 985 +++++++++++++++++++++++
 include/linux/powercap.h                         | 300 +++++++
 7 files changed, 1986 insertions(+)
 create mode 100644 Documentation/powercap/PowerCappingFramework.txt
 create mode 100644 drivers/powercap/Kconfig
 create mode 100644 drivers/powercap/Makefile
 create mode 100644 drivers/powercap/powercap_sys.c
 create mode 100644 include/linux/powercap.h

-- 
1.8.3.1

