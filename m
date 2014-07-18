Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965666AbaGRNMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:31 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17635 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965634AbaGRNMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/170] KVM: x86: Increase the number of fixed MTRR regs to 10
Date: Fri, 18 Jul 2014 14:11:56 +0200
Message-Id: <8c94324979563d69cf4729e15d4730392c8f5c53.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 682367c494869008eb89ef733f196e99415ae862 upstream.

Recent Intel CPUs have 10 variable range MTRRs. Since operating systems
sometime make assumptions on CPUs while they ignore capability MSRs, it is
better for KVM to be consistent with recent CPUs. Reporting more MTRRs than
actually supported has no functional implications.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74a98f2..792206c8e555 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -92,7 +92,7 @@
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 8
+#define KVM_NR_VAR_MTRR 10
 
 #define ASYNC_PF_PER_VCPU 64
 
-- 
2.0.0

