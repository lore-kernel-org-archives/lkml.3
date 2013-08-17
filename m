Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3HQTs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:48:56 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41657 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3HQTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:48:53 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, fenghua.yu@intel.com,
        bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/4] Unify CPU hotplug lock interface
Date: Sat, 17 Aug 2013 13:46:55 -0600
Message-Id: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
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

The patchset is based on Linus's tree, 3.11.0-rc5.

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
 drivers/base/cpu.c                     | 26 ++++++++++++----------
 include/linux/cpu.h                    | 13 -----------
 7 files changed, 37 insertions(+), 90 deletions(-)
