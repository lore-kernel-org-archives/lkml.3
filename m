Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522Ab3DIXqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:46:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:39901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab3DIXqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="283975862"
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
Subject: [PATCH v4 0/1] RAPL (Running Average Power Limit) driver
Date: Tue,  9 Apr 2013 16:46:48 -0700
Message-Id: <1365551209-14392-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since V3:
	- Removed dependency on platform_device/platform_driver.
	  I initially used platform bus for the purpose of linking
	  RAPL domain device objects to thermal sysfs. For this simplified
	  version we don't need this anymore nor do we need any
	  resources/platform data. This simplified version only needs
	  MSR access. (not to avoid .release() :). I should be freeing
	  device data after it gets called from driver core)

	- merged header file into .c file, there is no public data nor
	  APIs.

	- misc. cleanups based on reviews

Changes since V2:
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

Changes since V1:
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
 drivers/platform/x86/intel_rapl.c |  889 +++++++++++++++++++++++++++++++++++++
 3 files changed, 899 insertions(+)
 create mode 100644 drivers/platform/x86/intel_rapl.c

-- 
1.7.9.5

