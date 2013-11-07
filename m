Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3KGSfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:35:21 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53360 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3KGSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:35:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] intel_mid: do not re-introduce usage of obsolete __cpuinit
Date: Thu, 7 Nov 2013 13:34:50 -0500
Message-ID: <1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.rc0.44.gf26f72d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 712b6aa8731a7e148298c58cea66a5209c659e3c [Nov7 linux-next
via tip/auto-latest] ("intel_mid: Renamed *mrst* to *intel_mid*")
adds a __cpuinit.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Feel free to squash this into the original, if there happens
 to be a rebase taking place anyway...]

 arch/x86/platform/intel-mid/intel-mid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 523a1c8..f90e290 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -123,7 +123,7 @@ static void __init intel_mid_time_init(void)
 	apbt_time_init();
 }
 
-static void __cpuinit intel_mid_arch_setup(void)
+static void intel_mid_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
 		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
-- 
1.8.4.1

