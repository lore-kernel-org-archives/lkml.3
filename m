Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaBGMMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:12:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaBGLvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mihai Caraman <mihai.caraman@freescale.com>,
        Alexander Graf <agraf@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 180/233] KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()
Date: Fri,  7 Feb 2014 11:46:39 +0000
Message-Id: <1391773652-25214-181-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Caraman <mihai.caraman@freescale.com>

commit 70713fe315ed14cd1bb07d1a7f33e973d136ae3d upstream.

Use gva_t instead of unsigned int for eaddr in deliver_tlb_miss().

Signed-off-by: Mihai Caraman <mihai.caraman@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/e500_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/e500_mmu.c b/arch/powerpc/kvm/e500_mmu.c
index 6d6f153..c17600d 100644
--- a/arch/powerpc/kvm/e500_mmu.c
+++ b/arch/powerpc/kvm/e500_mmu.c
@@ -127,7 +127,7 @@ static int kvmppc_e500_tlb_index(struct kvmppc_vcpu_e500 *vcpu_e500,
 }
 
 static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
-		unsigned int eaddr, int as)
+		gva_t eaddr, int as)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	unsigned int victim, tsized;
-- 
1.8.3.2

