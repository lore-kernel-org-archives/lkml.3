Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaGaJsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbaGaJsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:48:39 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        pbonzini@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com
Subject: [PATCH 2/2] x86: kvm: do not advertise stable clocksource if CPU has TSC drift BUG
Date: Thu, 31 Jul 2014 09:47:13 +0000
Message-Id: <1406800033-13404-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 38a0afe..f519823 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -478,8 +478,9 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_PV_EOI) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
 			     (1 << KVM_FEATURE_PV_UNHALT);
+		if (!static_cpu_has_bug(X86_BUG_AMD_TSC_DRIFT))
+			entry->eax |= (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
1.8.3.1

