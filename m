Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030386Ab3HIOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:16:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51045 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241Ab3HIOQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:16:27 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <gleb@redhat.com>, <pbonzini@redhat.com>
Cc: <gregkh@suse.de>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <agraf@suse.de>, <riel@redhat.com>, <avi.kivity@gmail.com>,
        <habanero@linux.vnet.ibm.com>, <chegu_vinod@hp.com>,
        <ouyang@cs.pitt.edu>, <drjones@redhat.com>, <attilio.rao@citrix.com>,
        linux-doc@vger.kernel.org, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <andi@firstfloor.org>, <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>,
        <stefano.stabellini@eu.citrix.com>, <mtosatti@redhat.com>,
        <srivatsa.vaddagiri@gmail.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 02/14] x86/ticketlock: Don't inline _spin_unlock when using paravirt spinlocks
Date: Fri,  9 Aug 2013 19:51:50 +0530
Message-Id: <1376058122-8248-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <y>
 <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080914-7182-0000-0000-0000080895C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code size expands somewhat, and its better to just call
a function rather than inline it.

Thanks Jeremy for original version of ARCH_NOINLINE_SPIN_UNLOCK config patch,
which is simplified.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7f3867c..724ce55 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -663,6 +663,7 @@ config PARAVIRT_DEBUG
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP
+	select UNINLINE_SPIN_UNLOCK
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly
-- 
1.7.11.7

