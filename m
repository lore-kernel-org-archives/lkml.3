Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab3FSJJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:09:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35559 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab3FSJJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:41 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 1/7] KVM: MMU: update the documentation for reverse mapping of parent_pte
Date: Wed, 19 Jun 2013 17:09:19 +0800
Message-Id: <1371632965-20077-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061920-3568-0000-0000-000003CCE8E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the document to match the current reverse mapping of
parent_pte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 43fcb76..869abcc 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -191,12 +191,12 @@ Shadow pages contain the following information:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
     page cannot be destroyed.  See role.invalid.
-  multimapped:
-    Whether there exist multiple sptes pointing at this page.
-  parent_pte/parent_ptes:
-    If multimapped is zero, parent_pte points at the single spte that points at
-    this page's spt.  Otherwise, parent_ptes points at a data structure
-    with a list of parent_ptes.
+  parent_ptes:
+    The reverse mapping for the pte/ptes pointing at this page's spt. If
+    parent_ptes bit 0 is zero, only one spte points at this pages and
+    parent_ptes points at this single spte, otherwise, there exists multiple
+    sptes pointing at this page and (parent_ptes & ~0x1) points at a data
+    structure with a list of parent_ptes.
   unsync:
     If true, then the translations in this page may not match the guest's
     translation.  This is equivalent to the state of the tlb when a pte is
-- 
1.8.1.4

