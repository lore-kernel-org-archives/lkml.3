Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaFJUVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:21:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaFJTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haibin Wang <wanghaibin.wang@huawei.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 112/160] KVM: ARM: vgic: Fix sgi dispatch problem
Date: Tue, 10 Jun 2014 12:45:52 -0700
Message-Id: <1402429600-20477-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibin Wang <wanghaibin.wang@huawei.com>

commit 91021a6c8ffdc55804dab5acdfc7de4f278b9ac3 upstream.

When dispatch SGI(mode == 0), that is the vcpu of VM should send
sgi to the cpu which the target_cpus list.
So, there must add the "break" to branch of case 0.

Signed-off-by: Haibin Wang <wanghaibin.wang@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/arm/vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 685fc72..b001dbf 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -751,6 +751,7 @@ static void vgic_dispatch_sgi(struct kvm_vcpu *vcpu, u32 reg)
 	case 0:
 		if (!target_cpus)
 			return;
+		break;
 
 	case 1:
 		target_cpus = ((1 << nrcpus) - 1) & ~(1 << vcpu_id) & 0xff;
-- 
1.9.1

