Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3LUBKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:10:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:19751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3LUBKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="428104818"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com
Subject: [PATCH v2 0/3] x86: intel-mid: handle platform code error in better way
Date: Fri, 20 Dec 2013 17:15:10 -0800
Message-Id: <1387588513-25701-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are meant to improve how Intel MID detects error in its platform
code. Currently it's ambiguous when platform code returns NULL due to error or
due to lack of platform data in valid situations. With these patches, errors
will be handled by ERR_PTR()/PTR_ERR() macros.

Br, David Cohen

---
David Cohen (3):
  x86: intel-mid: sfi_handle_*_dev() should check for pdata error code
  x86: intel-mid: platform code should return error when failing
  x86: intel-mid: return proper error code from get_gpio_by_name()

 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c   | 6 ++++--
 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_lis331.c    | 6 ++++--
 arch/x86/platform/intel-mid/device_libs/platform_max7315.c   | 6 +++---
 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c   | 4 ++--
 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c  | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c  | 6 ++++++
 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c   | 6 +++---
 arch/x86/platform/intel-mid/sfi.c                            | 8 +++++++-
 11 files changed, 33 insertions(+), 17 deletions(-)

-- 
1.8.4.2

