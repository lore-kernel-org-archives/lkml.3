Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935374AbaICXJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:09:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716AbaICWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.16 061/125] Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"
Date: Wed,  3 Sep 2014 15:06:58 -0700
Message-Id: <20140903220625.520552441@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -95,7 +95,7 @@ static inline gfn_t gfn_to_index(gfn_t g
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 10
+#define KVM_NR_VAR_MTRR 8
 
 #define ASYNC_PF_PER_VCPU 64
 


