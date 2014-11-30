Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaK3ELb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:11:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38089 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaK3ELa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:11:30 -0500
Message-ID: <547A9A7C.1080508@gmail.com>
Date: Sun, 30 Nov 2014 12:18:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: arm: vgic: Let one looping code instead of two looping
 code
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one looping instead of two, so can let code more simpler and get a
little better performance.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 virt/kvm/arm/vgic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index cf23c13..eb1a51b 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1959,9 +1959,6 @@ int kvm_vgic_create(struct kvm *kvm)
 		if (!mutex_trylock(&vcpu->mutex))
 			goto out_unlock;
 		vcpu_lock_idx = i;
-	}
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu->arch.has_run_once)
 			goto out_unlock;
 	}
-- 
1.9.3
