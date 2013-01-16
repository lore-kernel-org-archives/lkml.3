Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3APRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:16:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3APP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 001/222] KVM: PPC: e500: fix allocation size error on g2h_tlb1_map
Date: Wed, 16 Jan 2013 13:53:21 -0200
Message-Id: <1358351822-7675-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit e400e72f250d2567e89c9bafb47ab91e8d9a15a2 upstream.

We were only allocating half the bytes we need, which was made more
obvious by a recent fix to the memset in  clear_tlb1_bitmap().

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/powerpc/kvm/e500_tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index c510fc9..3580a0c 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -1330,7 +1330,7 @@ int kvmppc_e500_tlb_init(struct kvmppc_vcpu_e500 *vcpu_e500)
 	if (!vcpu_e500->gtlb_priv[1])
 		goto err;
 
-	vcpu_e500->g2h_tlb1_map = kzalloc(sizeof(unsigned int) *
+	vcpu_e500->g2h_tlb1_map = kzalloc(sizeof(u64) *
 					  vcpu_e500->gtlb_params[1].entries,
 					  GFP_KERNEL);
 	if (!vcpu_e500->g2h_tlb1_map)
-- 
1.7.9.5

