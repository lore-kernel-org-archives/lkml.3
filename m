Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaAVRfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:35:39 -0500
Received: from mail1.windriver.com ([147.11.146.13]:49908 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:35:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86: don't add new __cpuinit users to Merrifield platform code
Date: Wed, 22 Jan 2014 12:35:25 -0500
Message-ID: <1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bc20aa48bbb3068224a1c91f8332971fdb689fad ("x86, intel-mid:
Add Merrifield platform support")  added new instances of __cpuinit
usage.  We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what we want to
see at this point in time, as it will break once the stubs are gone.

This also fixes an out of sync __init vs. __cpuinit -- as the former
is real, and the latter is a no-op; hence it would have been a section
mismatch.

Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[patch will be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]

 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 2 +-
 arch/x86/platform/intel-mid/mrfl.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index 41fe17d0d8ff..46aa25c8ce06 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -16,4 +16,4 @@
  */
 extern void *get_penwell_ops(void) __attribute__((weak));
 extern void *get_cloverview_ops(void) __attribute__((weak));
-extern void * __init get_tangier_ops(void) __attribute__((weak));
+extern void *get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
index 09d10159e7b7..28b636a21887 100644
--- a/arch/x86/platform/intel-mid/mrfl.c
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -97,7 +97,7 @@ static struct intel_mid_ops tangier_ops = {
 	.arch_setup = tangier_arch_setup,
 };
 
-void * __cpuinit get_tangier_ops()
+void *get_tangier_ops()
 {
 	return &tangier_ops;
 }
-- 
1.8.5.2

