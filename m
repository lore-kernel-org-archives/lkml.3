Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaAPW5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:57:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaAPW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:57:44 -0500
Date: Thu, 16 Jan 2014 14:57:32 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-ca1e631c3acf80bc5f5934ce9054a9b4880c96e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bin.gao@intel.com, tglx@linutronix.de, fengguang.wu@intel.com,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bin.gao@intel.com, hpa@linux.intel.com,
        fengguang.wu@intel.com
In-Reply-To: <tip-rgm7xmg7k6qnjlw3ynkcjsmh@git.kernel.org>
References: <tip-rgm7xmg7k6qnjlw3ynkcjsmh@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, tsc, apic: Unbreak static (MSR)
  calibration when CONFIG_X86_LOCAL_APIC=n
Git-Commit-ID: ca1e631c3acf80bc5f5934ce9054a9b4880c96e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 14:57:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca1e631c3acf80bc5f5934ce9054a9b4880c96e1
Gitweb:     http://git.kernel.org/tip/ca1e631c3acf80bc5f5934ce9054a9b4880c96e1
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 16 Jan 2014 13:00:21 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 16 Jan 2014 13:00:21 -0800

x86, tsc, apic: Unbreak static (MSR) calibration when CONFIG_X86_LOCAL_APIC=n

If we aren't going to use the local APIC anyway, we obviously don't
care about its timer frequency.

Link: http://lkml.kernel.org/r/tip-rgm7xmg7k6qnjlw3ynkcjsmh@git.kernel.org
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bin Gao <bin.gao@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/tsc_msr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index c502772..8b5434f 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -118,8 +118,10 @@ int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
 	*fast_calibrate = freq * ratio;
 	pr_info("TSC runs at %lu KHz\n", *fast_calibrate);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	lapic_timer_frequency = (freq * 1000) / HZ;
 	pr_info("lapic_timer_frequency = %d\n", lapic_timer_frequency);
+#endif
 
 	return 1;
 }
