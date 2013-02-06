Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3BFC53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:57:29 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12772 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3BFC51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:57:27 -0500
Message-ID: <1360119442.8356.8.camel@lorien2>
Subject: [PATCH linux-next] x86/kvm: Fix compile warning in
 kvm_register_steal_time()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, avi@redhat.com,
        gleb@redhat.com, mtosatti@redhat.com, mst@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, shuahkhan@gmail.com
Date: Tue, 05 Feb 2013 19:57:22 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compile warning in kvm_register_steal_time():
  CC      arch/x86/kernel/kvm.o
arch/x86/kernel/kvm.c: In function ‘kvm_register_steal_time’:
arch/x86/kernel/kvm.c:302:3: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Wformat]

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 arch/x86/kernel/kvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index fe75a28..b686a90 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -298,8 +298,8 @@ static void kvm_register_steal_time(void)
 	memset(st, 0, sizeof(*st));
 
 	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
-	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
-		cpu, slow_virt_to_phys(st));
+	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
+		cpu, (unsigned long long) slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
-- 
1.7.9.5



