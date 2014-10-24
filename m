Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaJXPIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbaJXPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:08:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 14/14] KVM: x86: Wrong assertion on paging_tmpl.h
Date: Fri, 24 Oct 2014 17:07:25 +0200
Message-Id: <1414163245-18555-15-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

Even after the recent fix, the assertion on paging_tmpl.h is triggered.
Apparently, the assertion wants to check that the PAE is always set on
long-mode, but does it in incorrect way.  Note that the assertion is not
enabled unless the code is debugged by defining MMU_DEBUG.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 806d58e3c320..fd49c867b25a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -298,7 +298,7 @@ retry_walk:
 	}
 #endif
 	walker->max_level = walker->level;
-	ASSERT(!is_long_mode(vcpu) && is_pae(vcpu));
+	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
 	accessed_dirty = PT_GUEST_ACCESSED_MASK;
 	pt_access = pte_access = ACC_ALL;
-- 
1.8.3.1
