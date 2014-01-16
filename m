Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaAPXCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:02:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:12166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaAPXCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:02:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="467941348"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: david.a.cohen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Intel MID platform code cleanups
Date: Thu, 16 Jan 2014 15:07:01 -0800
Message-Id: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are first cleanups on improving how Intel MID detects error in
its platform code.
But due to current state of platform code is pretty bad, this first set does
only cleanups (no functional changes). Functional fixes are coming in near
future.

Change from v2 to v3:
 - Since these patches are relevant for drivers being upstreamed (but not yet),
   I have no actual error to explain using only in-tree code. In order to
   address Ingo's comment about being more clear on changelogs, I stripped out
   functional changes from v2 and explicitly said I am sending cleanups for now.

Br, David Cohen

---
David Cohen (3):
  x86: intel-mid: sfi_handle_*_dev() should check for pdata error code
  x86: intel-mid: check get_gpio_by_name() error code on platform code
  x86: intel-mid: return proper error code from get_gpio_by_name()

 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c   | 4 +++-
 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_lis331.c    | 4 +++-
 arch/x86/platform/intel-mid/device_libs/platform_max7315.c   | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c   | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c   | 4 ++--
 arch/x86/platform/intel-mid/sfi.c                            | 8 +++++++-
 8 files changed, 19 insertions(+), 9 deletions(-)

-- 
1.8.4.2

