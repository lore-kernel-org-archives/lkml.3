Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaICJ4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:30 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57364 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755904AbaICJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 46/56] Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"
Date: Wed,  3 Sep 2014 11:27:05 +0200
Message-Id: <96de8d44b459c60fc5c854bbe58794f87b245449.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0d234daf7e0a3290a3a20c8087eefbd6335a5bd4 upstream.

This reverts commit 682367c494869008eb89ef733f196e99415ae862,
which causes 32-bit SMP Windows 7 guests to panic.

SeaBIOS has a limit on the number of MTRRs that it can handle,
and this patch exceeded the limit.  Better revert it.
Thanks to Nadav Amit for debugging the cause.

Reported-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 694851592399..ec6c0395b512 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -92,7 +92,7 @@
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 10
+#define KVM_NR_VAR_MTRR 8
 
 #define ASYNC_PF_PER_VCPU 64
 
-- 
2.1.0

