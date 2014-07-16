Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGPVFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:59834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaGPVE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:59 -0400
Message-Id: <20140716205055.838565297@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org
Subject: [patch V2 43/64] x86: kvm: Use ktime_get_boot_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-kvm-use-ktime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new nanoseconds based interface and get rid of the timespec
conversion dance.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/x86.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: tip/arch/x86/kvm/x86.c
===================================================================
--- tip.orig/arch/x86/kvm/x86.c
+++ tip/arch/x86/kvm/x86.c
@@ -1109,11 +1109,7 @@ static void kvm_get_time_scale(uint32_t
 
 static inline u64 get_kernel_ns(void)
 {
-	struct timespec ts;
-
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
-	return timespec_to_ns(&ts);
+	return ktime_get_boot_ns();
 }
 
 #ifdef CONFIG_X86_64


