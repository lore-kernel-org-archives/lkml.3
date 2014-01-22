Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaAVRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:34:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:40262 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaAVRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:34:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <fengguang.wu@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2] x86: don't introduce more __cpuinit users in intel_mid_weak_decls.h
Date: Wed, 22 Jan 2014 12:34:15 -0500
Message-ID: <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com>
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85611e3febe78955a519f5f9eb47b941525c8c76 ("x86, intel-mid:
Add Clovertrail platform support") added new instances of __cpuinit
usage.  We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what we want to
see at this point in time, as it will break once the stubs are gone.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: actually include changes to mfld.c as well this time

 patch will be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]

 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 4 ++--
 arch/x86/platform/intel-mid/mfld.c                 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index a537ffc16299..41fe17d0d8ff 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -14,6 +14,6 @@
 /* For every CPU addition a new get_<cpuname>_ops interface needs
  * to be added.
  */
-extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
-extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
+extern void *get_penwell_ops(void) __attribute__((weak));
+extern void *get_cloverview_ops(void) __attribute__((weak));
 extern void * __init get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
index 4f7884eebc14..88b06fcf9959 100644
--- a/arch/x86/platform/intel-mid/mfld.c
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -64,12 +64,12 @@ static void __init penwell_arch_setup()
 	pm_power_off = mfld_power_off;
 }
 
-void * __cpuinit get_penwell_ops()
+void *get_penwell_ops()
 {
 	return &penwell_ops;
 }
 
-void * __cpuinit get_cloverview_ops()
+void *get_cloverview_ops()
 {
 	return &penwell_ops;
 }
-- 
1.8.5.2

