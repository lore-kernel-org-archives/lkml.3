Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3JJWYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3JJWYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:24:40 -0400
Date: Thu, 10 Oct 2013 15:24:22 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-90ab9d5510932e146a9443bf5a591f95d5b5ada8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381444224-3303-1-git-send-email-kys@microsoft.com>
References: <1381444224-3303-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv:
  Correctly guard the local APIC calibration code
Git-Commit-ID: 90ab9d5510932e146a9443bf5a591f95d5b5ada8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 10 Oct 2013 15:24:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90ab9d5510932e146a9443bf5a591f95d5b5ada8
Gitweb:     http://git.kernel.org/tip/90ab9d5510932e146a9443bf5a591f95d5b5ada8
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Thu, 10 Oct 2013 15:30:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Oct 2013 15:21:38 -0700

x86, hyperv: Correctly guard the local APIC calibration code

The code that gets the local APIC timer frequency from the hypervisor
rather depends on there being a local APIC.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1381444224-3303-1-git-send-email-kys@microsoft.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 0a490ca..628ff50 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -80,6 +80,7 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
 		/*
 		 * Get the APIC frequency.
@@ -99,6 +100,7 @@ static void __init ms_hyperv_init_platform(void)
 			legacy_pic = &null_legacy_pic;
 		}
 	}
+#endif
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
