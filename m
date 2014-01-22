Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAVWaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:30:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaAVWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:30:37 -0500
Date: Wed, 22 Jan 2014 14:30:26 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-47683f7fe5d2abd71bf08b42060bcf95e0ad668f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fei.yang@intel.com, david.a.cohen@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fei.yang@intel.com, david.a.cohen@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, paul.gortmaker@windriver.com
In-Reply-To: <1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86: Don'
 t add new __cpuinit users to Merrifield platform code
Git-Commit-ID: 47683f7fe5d2abd71bf08b42060bcf95e0ad668f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 14:30:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47683f7fe5d2abd71bf08b42060bcf95e0ad668f
Gitweb:     http://git.kernel.org/tip/47683f7fe5d2abd71bf08b42060bcf95e0ad668f
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Wed, 22 Jan 2014 12:35:25 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Jan 2014 14:28:57 -0800

x86: Don't add new __cpuinit users to Merrifield platform code

Commit bc20aa48bbb3068224a1c91f8332971fdb689fad ("x86, intel-mid:
Add Merrifield platform support")  added new instances of __cpuinit
usage.  We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what we want to
see at this point in time, as it will break once the stubs are gone.

This also fixes an out of sync __init vs. __cpuinit -- as the former
is real, and the latter is a no-op; hence it would have been a section
mismatch.

Cc: Fei Yang <fei.yang@intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1390412125-19439-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 2 +-
 arch/x86/platform/intel-mid/mrfl.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index 41fe17d..46aa25c 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -16,4 +16,4 @@
  */
 extern void *get_penwell_ops(void) __attribute__((weak));
 extern void *get_cloverview_ops(void) __attribute__((weak));
-extern void * __init get_tangier_ops(void) __attribute__((weak));
+extern void *get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
index 09d1015..28b636a 100644
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
