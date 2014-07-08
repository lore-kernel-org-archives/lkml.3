Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaGHAKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:10:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaGHADW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.4 22/44] KVM: x86: Increase the number of fixed MTRR regs to 10
Date: Mon,  7 Jul 2014 17:07:12 -0700
Message-Id: <20140707235859.315158598@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 682367c494869008eb89ef733f196e99415ae862 upstream.

Recent Intel CPUs have 10 variable range MTRRs. Since operating systems
sometime make assumptions on CPUs while they ignore capability MSRs, it is
better for KVM to be consistent with recent CPUs. Reporting more MTRRs than
actually supported has no functional implications.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -102,7 +102,7 @@
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 8
+#define KVM_NR_VAR_MTRR 10
 
 #define ASYNC_PF_PER_VCPU 64
 


