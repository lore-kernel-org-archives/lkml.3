Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410AbaBDWCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:02:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbaBDVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mihai Caraman <mihai.caraman@freescale.com>,
        Alexander Graf <agraf@suse.de>
Subject: [PATCH 3.12 120/133] KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()
Date: Tue,  4 Feb 2014 13:08:41 -0800
Message-Id: <20140204210740.418818481@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Caraman <mihai.caraman@freescale.com>

commit 70713fe315ed14cd1bb07d1a7f33e973d136ae3d upstream.

Use gva_t instead of unsigned int for eaddr in deliver_tlb_miss().

Signed-off-by: Mihai Caraman <mihai.caraman@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/e500_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500_mmu.c
+++ b/arch/powerpc/kvm/e500_mmu.c
@@ -127,7 +127,7 @@ static int kvmppc_e500_tlb_index(struct
 }
 
 static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
-		unsigned int eaddr, int as)
+		gva_t eaddr, int as)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	unsigned int victim, tsized;


