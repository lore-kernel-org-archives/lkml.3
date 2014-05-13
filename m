Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbaEMKL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933676AbaEMKLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Haibin Wang <wanghaibin.wang@huawei.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/182] KVM: ARM: vgic: Fix sgi dispatch problem
Date: Tue, 13 May 2014 11:28:01 +0200
Message-Id: <0c2a530f6a86cd40efb18a1f929d7347e3c59500.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haibin Wang <wanghaibin.wang@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 91021a6c8ffdc55804dab5acdfc7de4f278b9ac3 upstream.

When dispatch SGI(mode == 0), that is the vcpu of VM should send
sgi to the cpu which the target_cpus list.
So, there must add the "break" to branch of case 0.

Signed-off-by: Haibin Wang <wanghaibin.wang@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 virt/kvm/arm/vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 685fc72fc751..b001dbff0f38 100644
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
1.9.3

