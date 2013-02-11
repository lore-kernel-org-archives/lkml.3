Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3BKMgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:36:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3BKMgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:36:18 -0500
Date: Mon, 11 Feb 2013 04:36:02 -0800
From: tip-bot for Shuah Khan <shuah.khan@hp.com>
Message-ID: <tip-136867f517cbc3f8a91f035677911a6b503c3323@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, gleb@redhat.com, riel@redhat.com,
        shuah.khan@hp.com, mtosatti@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, gleb@redhat.com, riel@redhat.com,
        shuah.khan@hp.com, mtosatti@redhat.com, tglx@linutronix.de
In-Reply-To: <1360119442.8356.8.camel@lorien2>
References: <1360119442.8356.8.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/kvm:
  Fix compile warning in kvm_register_steal_time()
Git-Commit-ID: 136867f517cbc3f8a91f035677911a6b503c3323
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:36:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  136867f517cbc3f8a91f035677911a6b503c3323
Gitweb:     http://git.kernel.org/tip/136867f517cbc3f8a91f035677911a6b503c3323
Author:     Shuah Khan <shuah.khan@hp.com>
AuthorDate: Tue, 5 Feb 2013 19:57:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 11:04:31 +0100

x86/kvm: Fix compile warning in kvm_register_steal_time()

Fix the following compile warning in kvm_register_steal_time():

  CC      arch/x86/kernel/kvm.o
  arch/x86/kernel/kvm.c: In function ‘kvm_register_steal_time’: arch/x86/kernel/kvm.c:302:3:
  warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Wformat]

Introduced via:

  5dfd486c4750 x86, kvm: Fix kvm's use of __pa() on percpu areas
  d76565344512 x86, mm: Create slow_virt_to_phys()
  f3c4fbb68e93 x86, mm: Use new pagetable helpers in try_preserve_large_page()
  4cbeb51b860c x86, mm: Pagetable level size/shift/mask helpers
  a25b9316841c x86, mm: Make DEBUG_VIRTUAL work earlier in boot

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: shuahkhan@gmail.com
Cc: avi@redhat.com
Cc: gleb@redhat.com
Cc: mst@redhat.com
Link: http://lkml.kernel.org/r/1360119442.8356.8.camel@lorien2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index aa7e58b..9cec202 100644
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
