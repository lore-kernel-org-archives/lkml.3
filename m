Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3KGTbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:31:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3KGTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:30:52 -0500
Date: Thu, 7 Nov 2013 11:30:33 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-aeeca404266c8ed2997905afc342ba9561f49ca7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
In-Reply-To: <1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com>
References: <1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid:
  Do not re-introduce usage of obsolete __cpuinit
Git-Commit-ID: aeeca404266c8ed2997905afc342ba9561f49ca7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 11:30:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aeeca404266c8ed2997905afc342ba9561f49ca7
Gitweb:     http://git.kernel.org/tip/aeeca404266c8ed2997905afc342ba9561f49ca7
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Thu, 7 Nov 2013 13:34:50 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Nov 2013 10:44:03 -0800

x86, intel-mid: Do not re-introduce usage of obsolete __cpuinit

The commit 712b6aa8731a7e148298c58cea66a5209c659e3c [Nov7 linux-next
via tip/auto-latest] ("intel_mid: Renamed *mrst* to *intel_mid*")
adds a __cpuinit.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
