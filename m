Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBHH5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:57:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaBHHwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="477987515"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, gleb@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: [PATCH 01/14] asmlinkage, kvm: Make kvm_rebooting visible
Date: Sat,  8 Feb 2014 08:51:57 +0100
Message-Id: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_rebooting is referenced from assembler code, thus
needs to be visible.

Cc: gleb@redhat.com
Cc: pbonzini@redhat.com
Cc: kvm@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03a0381..b5ec7fb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,7 +102,7 @@ static void kvm_release_pfn_dirty(pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot, gfn_t gfn);
 
-bool kvm_rebooting;
+__visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static bool largepages_enabled = true;
-- 
1.8.5.2

