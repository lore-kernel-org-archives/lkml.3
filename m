Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3JVQNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:61399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab3JVQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="415251785"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        gleb@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 01/11] asmlinkage, kvm: Make kvm_rebooting visible
Date: Tue, 22 Oct 2013 09:12:16 -0700
Message-Id: <1382458346-24811-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
index a9dd682..6ca3564 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -95,7 +95,7 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-bool kvm_rebooting;
+__visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static bool largepages_enabled = true;
-- 
1.8.3.1

