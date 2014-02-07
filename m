Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaBGLc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:32:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41128 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaBGLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mihai Caraman <mihai.caraman@freescale.com>,
        Alexander Graf <agraf@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 66/88] KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()
Date: Fri,  7 Feb 2014 11:23:03 +0000
Message-Id: <1391772205-22239-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Caraman <mihai.caraman@freescale.com>

commit 70713fe315ed14cd1bb07d1a7f33e973d136ae3d upstream.

Use gva_t instead of unsigned int for eaddr in deliver_tlb_miss().

Signed-off-by: Mihai Caraman <mihai.caraman@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
[ luis: backported to 3.5:
  - kvmppc_e500_deliver_tlb_miss() is defined in arch/powerpc/kvm/e500_tlb.c
    on the 3.5 kernel]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/e500_tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 3580a0c..5871b4e 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -358,7 +358,7 @@ static void clear_tlb_refs(struct kvmppc_vcpu_e500 *vcpu_e500)
 }
 
 static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
-		unsigned int eaddr, int as)
+		gva_t eaddr, int as)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	unsigned int victim, tsized;
-- 
1.8.3.2

