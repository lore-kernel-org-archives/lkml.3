Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3H3AYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:24:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:40465 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3H3AYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:24:00 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nfont@linux.vnet.ibm.com, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 0/4] Unify CPU hotplug lock interface
Date: Thu, 29 Aug 2013 18:22:05 -0600
Message-Id: <1377822129-4143-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_device_hotplug() was recently introduced to serialize CPU & Memory
online/offline and hotplug operations, along with sysfs online interface
restructure (commit 4f3549d7).  With this new locking scheme,
cpu_hotplug_driver_lock() is redundant and is no longer necessary.

This patchset makes sure that lock_device_hotplug() covers all CPU online/
offline interfaces, and then removes cpu_hotplug_driver_lock().

v2:
 - Rebased to the pm tree, bleeding-edge.
 - Changed patch 2/4 to use lock_device_hotplug_sysfs().

---
Toshi Kani (4):
  hotplug, x86: Fix online state in cpu0 debug interface
  hotplug, x86: Add hotplug lock to missing places
  hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
  hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()

---
 arch/powerpc/kernel/smp.c              | 12 ----------
 arch/powerpc/platforms/pseries/dlpar.c | 40 +++++++++++++---------------------
 arch/x86/Kconfig                       |  4 ----
 arch/x86/kernel/smpboot.c              | 21 ------------------
 arch/x86/kernel/topology.c             | 11 ++++++----
 drivers/base/cpu.c                     | 34 +++++++++++++++++++----------
 include/linux/cpu.h                    | 13 -----------
 7 files changed, 45 insertions(+), 90 deletions(-)
