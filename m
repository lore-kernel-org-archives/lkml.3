Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3G3NCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:02:22 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49998 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3G3NCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:02:20 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 01/12] KVM: MMU: remove unused parameter
Date: Tue, 30 Jul 2013 21:01:59 +0800
Message-Id: <1375189330-24066-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-6102-0000-0000-000003F12F82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

＠vcpu in page_fault_can_be_fast() is not used so remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3a9493a..a731c0b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2808,7 +2808,7 @@ exit:
 	return ret;
 }
 
-static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
+static bool page_fault_can_be_fast(u32 error_code)
 {
 	/*
 	 * Do not fix the mmio spte with invalid generation number which
@@ -2861,7 +2861,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	bool ret = false;
 	u64 spte = 0ull;
 
-	if (!page_fault_can_be_fast(vcpu, error_code))
+	if (!page_fault_can_be_fast(error_code))
 		return false;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
1.8.1.4

