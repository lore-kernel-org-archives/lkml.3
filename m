Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaGKNqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:46:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:56322 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaGKNpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:22 -0400
Message-Id: <20140711133708.851363608@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org
Subject: [patch 42/55] x86: kvm: Use ktime_get_boot_ns()
References: <20140711133623.530368377@linutronix.de>
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


