Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab3GRTeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:34:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:37085 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759352Ab3GRTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,696,1367996400"; 
   d="scan'208";a="372723107"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: rjw@sisk.pl, arjan@linux.intel.com, len.brown@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v00 0/1] Power Capping framework and drivers
Date: Thu, 18 Jul 2013 12:34:14 -0700
Message-Id: <1374176055-23527-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafel, Len, Arjan, Greg KH

I am seeking opinion on power capping framework implementation for Linux.
Thanks to Greg KH for responding very patiently to my questions for presentation
on the sys-fs.

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

Here, I will present possible options to present the controls via sys-fs.

Srinivas Pandruvada (1):
  PowerCap: Documentation

 Documentation/powercap/PowerCappingFramework.txt | 1008 ++++++++++++++++++++++
 1 file changed, 1008 insertions(+)
 create mode 100644 Documentation/powercap/PowerCappingFramework.txt

-- 
1.8.3.1

