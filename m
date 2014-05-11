Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaEKTVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:21:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaEKTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3.14 07/83] KVM: ARM: vgic: Fix sgi dispatch problem
Date: Sun, 11 May 2014 21:19:08 +0200
Message-Id: <20140511191908.037308124@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibin Wang <wanghaibin.wang@huawei.com>

commit 91021a6c8ffdc55804dab5acdfc7de4f278b9ac3 upstream.

When dispatch SGI(mode == 0), that is the vcpu of VM should send
sgi to the cpu which the target_cpus list.
So, there must add the "break" to branch of case 0.

Signed-off-by: Haibin Wang <wanghaibin.wang@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/vgic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -916,6 +916,7 @@ static void vgic_dispatch_sgi(struct kvm
 	case 0:
 		if (!target_cpus)
 			return;
+		break;
 
 	case 1:
 		target_cpus = ((1 << nrcpus) - 1) & ~(1 << vcpu_id) & 0xff;


