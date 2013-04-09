Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936751Ab3DIMrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:47:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:22535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab3DIMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="319674554"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3 0/1] RAPL (Running Average Power Limit) driver
Date: Tue,  9 Apr 2013 05:46:17 -0700
Message-Id: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since V3:
	This is a simpler version which only exposes interface via
	the generic thermal layer. No new ABI introduced.

	RAPL driver does some automatic settings to the related power
	parameters based on user's single input from thermal cooling
	device interface.

	On the other side, more work needed to fully use RAPL
	interface. This is likely result in adding more knobs in the
	generic thermal sysfs.

	- deleted event notifications
	- deleted per domain device and RAPL class and their private
	  sysfs
	- added more logic to do some automatic settings based on
	  user input. e.g. will enable clamping by default and set
	  a reasonable time window for long term power limits.

Changes since V2:
	- use 'struct device' instead of raw kobject to represent
	  RAPL domains
	- changed eventfd control interface to use event string
	  instead of passing file descriptors that cannot be
	  authenticated in sysfs directory
	- clean ups based on v1 reviews
		- use kcalloc for arrays
		- drop dependencies on X86
		- misc cleanups


Jacob Pan (1):
  Introduce Intel RAPL cooling device driver

 drivers/platform/x86/Kconfig      |    9 +
 drivers/platform/x86/Makefile     |    1 +
 drivers/platform/x86/intel_rapl.c |  764 +++++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_rapl.h |  176 +++++++++
 4 files changed, 950 insertions(+)
 create mode 100644 drivers/platform/x86/intel_rapl.c
 create mode 100644 drivers/platform/x86/intel_rapl.h

-- 
1.7.9.5

