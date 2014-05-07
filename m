Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbaEGNUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:20:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbaEGNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haibin Wang <wanghaibin.wang@huawei.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 56/70] KVM: ARM: vgic: Fix sgi dispatch problem
Date: Wed,  7 May 2014 14:12:59 +0100
Message-Id: <1399468393-10140-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibin Wang <wanghaibin.wang@huawei.com>

commit 91021a6c8ffdc55804dab5acdfc7de4f278b9ac3 upstream.

When dispatch SGI(mode == 0), that is the vcpu of VM should send
sgi to the cpu which the target_cpus list.
So, there must add the "break" to branch of case 0.

Signed-off-by: Haibin Wang <wanghaibin.wang@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/arm/vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 17c5ac7..0e8b10d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -753,6 +753,7 @@ static void vgic_dispatch_sgi(struct kvm_vcpu *vcpu, u32 reg)
 	case 0:
 		if (!target_cpus)
 			return;
+		break;
 
 	case 1:
 		target_cpus = ((1 << nrcpus) - 1) & ~(1 << vcpu_id) & 0xff;
-- 
1.9.1

