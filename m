Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3FATSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:18:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45990 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3FATR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:17:59 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stephan.diestelhorst@amd.com>,
        <riel@redhat.com>, <drjones@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Sun, 02 Jun 2013 00:52:09 +0530
Message-Id: <20130601192209.5966.46834.sendpatchset@codeblue>
In-Reply-To: <20130601192125.5966.35563.sendpatchset@codeblue>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
Subject: [PATCH RFC V9 2/19]  x86/ticketlock: Don't inline _spin_unlock when using paravirt spinlocks
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060119-0260-0000-0000-000003163FB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/ticketlock: Don't inline _spin_unlock when using paravirt spinlocks

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

The code size expands somewhat, and its better to just call
a function rather than inline it.

Thanks Jeremy for original version of ARCH_NOINLINE_SPIN_UNLOCK config patch,
which is simplified.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..80fcc4b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -621,6 +621,7 @@ config PARAVIRT_DEBUG
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP
+	select UNINLINE_SPIN_UNLOCK
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly

