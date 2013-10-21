Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3JUQGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:06:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58651 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3JUQGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:06:43 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <gleb@redhat.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>
Cc: <konrad.wilk@oracle.com>, <linux@eikelenboom.it>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH] x86 kconfig: Add recommendation to enable paravirt spinlock
Date: Mon, 21 Oct 2013 21:35:08 +0530
Message-Id: <1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <n>
References: <n>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102116-5806-0000-0000-00002327CA77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since paravirt spinlock optimization are in 3.12 kernel, we have
very good performance benefit for paravirtualized KVM / Xen kernel.
Also we no longer suffer from 5% side effect on native kernel.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Would like to thank Sander for spotting and suggesting this.
 pvspinlock benefit on KVM link: https://lkml.org/lkml/2013/8/6/178 
 
 Attilio's tests on native kernel impact:
 http://blog.xen.org/index.php/2012/05/11/benchmarking-the-new-pv-ticketlock-implementation/

 arch/x86/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..4ba9d32 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -638,10 +638,10 @@ config PARAVIRT_SPINLOCKS
 	  spinlock implementation with something virtualization-friendly
 	  (for example, block the virtual CPU rather than spinning).
 
-	  Unfortunately the downside is an up to 5% performance hit on
-	  native kernels, with various workloads.
+	  It has minimal impact on native kernels and gives nice performance
+	  benefit for paravirtualized KVM / Xen kernels.
 
-	  If you are unsure how to answer this question, answer N.
+	  If you are unsure how to answer this question, answer Y.
 
 source "arch/x86/xen/Kconfig"
 
-- 
1.7.11.7

