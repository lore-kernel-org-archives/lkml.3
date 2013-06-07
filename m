Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3FGIxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:53:54 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55831 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3FGIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:51:56 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 6/6] KVM: MMU: init kvm generation close to mmio wrap-around value
Date: Fri,  7 Jun 2013 16:51:28 +0800
Message-Id: <1370595088-3315-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060708-5816-0000-0000-00000851DDD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then it has the chance to trigger mmio generation number wrap-around

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1fd2c05..7d50a2d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -235,7 +235,12 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 
 static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 {
-	return kvm_memslots(kvm)->generation & MMIO_GEN_MASK;
+	/*
+	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
+	 * code of handling generation number wrap-around.
+	 */
+	return (kvm_memslots(kvm)->generation +
+		      MMIO_MAX_GEN - 13) & MMIO_GEN_MASK;
 }
 
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
-- 
1.8.1.4

