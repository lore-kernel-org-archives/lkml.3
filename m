Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3KLWJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:09:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:4632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3KLWJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:09:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434167693"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 0/3] Bring SFI support to out-of-tree driver modules on Intel Mid
Date: Tue, 12 Nov 2013 14:13:37 -0800
Message-Id: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset extends sfi_device() macro support to driver modules.
The main use case is to allow external driver modules to be enumerated by SFI
on Intel Mid platforms.

Br, David Cohen

---
David Cohen (3):
  sfi: add private data to sfi_parse_table()
  x86: intel-mid: struct devs_id.name should have 'SFI_NAME_LEN' length
  x86: intel-mid: allow sfi_device() to be used by modules

 arch/x86/include/asm/intel-mid.h             | 19 ++++++--
 arch/x86/platform/intel-mid/intel-mid.c      |  2 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |  2 +-
 arch/x86/platform/intel-mid/sfi.c            | 70 +++++++++++++++++++++-------
 arch/x86/platform/sfi/sfi.c                  |  8 ++--
 drivers/sfi/sfi_acpi.c                       |  5 +-
 drivers/sfi/sfi_core.c                       |  4 +-
 include/linux/sfi.h                          |  8 ++--
 8 files changed, 84 insertions(+), 34 deletions(-)

-- 
1.8.4.2

