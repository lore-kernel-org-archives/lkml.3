Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaAVWYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:24:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:24:49 -0500
Date: Wed, 22 Jan 2014 14:24:38 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-cbe48bc8cd279ad519624c331dad5a291891ef05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fei.yang@intel.com, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, fengguang.wu@intel.com,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fei.yang@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
In-Reply-To: <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86: Don'
 t introduce more __cpuinit users in intel_mid_weak_decls.h
Git-Commit-ID: cbe48bc8cd279ad519624c331dad5a291891ef05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 14:24:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbe48bc8cd279ad519624c331dad5a291891ef05
Gitweb:     http://git.kernel.org/tip/cbe48bc8cd279ad519624c331dad5a291891ef05
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Wed, 22 Jan 2014 12:34:15 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Jan 2014 14:21:14 -0800

x86: Don't introduce more __cpuinit users in intel_mid_weak_decls.h

Commit 85611e3febe78955a519f5f9eb47b941525c8c76 ("x86, intel-mid:
Add Clovertrail platform support") added new instances of __cpuinit
usage.  We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what we want to
see at this point in time, as it will break once the stubs are gone.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 4 ++--
 arch/x86/platform/intel-mid/mfld.c                 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index a537ffc..41fe17d 100644
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
index 4f7884e..88b06fc 100644
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
