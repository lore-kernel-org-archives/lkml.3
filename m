Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514Ab3FSJL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:11:29 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43397 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934300Ab3FSJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:47 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 5/7] KVM: MMU: document fast page fault in
Date: Wed, 19 Jun 2013 17:09:23 +0800
Message-Id: <1371632965-20077-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-8256-0000-0000-000007FD5102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document fast page fault to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 4fb442b..b5ce7dd 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -275,6 +275,9 @@ Handling a page fault is performed as follows:
    information is stored and cache the information to vcpu->arch.mmio_gva,
    vcpu->arch.access and vcpu->arch.mmio_gfn then call the emulator to emulate
    the instruction who will get the benefit from the cached mmio info
+ - If both P bit and R/W bit of error code are set, there has a chance to
+   fast fix the page fault, please see the description of "Fast page fault" in
+   Documentation/virtual/kvm/locking.txt
  - if needed, walk the guest page tables to determine the guest translation
    (gva->gpa or ngpa->gpa)
    - if permissions are insufficient, reflect the fault back to the guest
-- 
1.8.1.4

