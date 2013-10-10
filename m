Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3JJVrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:47:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33187
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3JJVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:47:13 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, olaf@aepfle.de, x86@kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] X86: hypev: Correctly guard the local APIC calibration code.
Date: Thu, 10 Oct 2013 15:30:24 -0700
Message-Id: <1381444224-3303-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly guard the code that gets the local APIC timer frequency from the
hypervisor.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
-- 
1.7.4.1

