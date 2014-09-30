Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaI3Vgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaI3Vg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/103] Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"
Date: Tue, 30 Sep 2014 14:30:33 -0700
Message-Id: <1412112708-27356-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0d234daf7e0a3290a3a20c8087eefbd6335a5bd4 upstream.

This reverts commit 682367c494869008eb89ef733f196e99415ae862,
which causes 32-bit SMP Windows 7 guests to panic.

SeaBIOS has a limit on the number of MTRRs that it can handle,
and this patch exceeded the limit.  Better revert it.
Thanks to Nadav Amit for debugging the cause.

Reported-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c16aef8..2122ffb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -99,7 +99,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 10
+#define KVM_NR_VAR_MTRR 8
 
 #define ASYNC_PF_PER_VCPU 64
 
-- 
1.9.1

