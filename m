Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3COP1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:27:49 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39194 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab3COP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:27:47 -0400
Message-ID: <51433DE9.3060904@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 23:27:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/5] Revert "KVM: MMU: Mark sp mmio cached when creating mmio
 spte"
References: <51433D98.4050605@linux.vnet.ibm.com>
In-Reply-To: <51433D98.4050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031515-8256-0000-0000-000006A4F4DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 95b0430d1a53541076ffbaf453f8b49a547cceba.
Will use a better way to zap all mmio shadow pages

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/mmu.c              |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b75cae..ef7f4a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -230,7 +230,6 @@ struct kvm_mmu_page {
 #endif

 	int write_flooding_count;
-	bool mmio_cached;
 };

 struct kvm_pio_request {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index de45ec1..fdacabb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -199,11 +199,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);

 static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
-
 	access &= ACC_WRITE_MASK | ACC_USER_MASK;

-	sp->mmio_cached = true;
 	trace_mark_mmio_spte(sptep, gfn, access);
 	mmu_spte_set(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
 }
-- 
1.7.7.6

