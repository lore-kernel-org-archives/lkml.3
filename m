Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaLORpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:45:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59669 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaLORpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:45:21 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 1/2] KVM: arm/arm64: vgic: vgic_init returns -ENODEV when no online vcpu
Date: Mon, 15 Dec 2014 18:43:32 +0100
Message-Id: <1418665413-31521-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
References: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be more explicit on vgic initialization failure, -ENODEV is
returned by vgic_init when no online vcpus can be found at init.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3: vgic_init_maps was renamed into vgic_init
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index e373b76..d61a61f 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1809,7 +1809,7 @@ static int vgic_init(struct kvm *kvm)
 
 	nr_cpus = dist->nr_cpus = atomic_read(&kvm->online_vcpus);
 	if (!nr_cpus)		/* No vcpus? Can't be good... */
-		return -EINVAL;
+		return -ENODEV;
 
 	/*
 	 * If nobody configured the number of interrupts, use the
-- 
1.9.1

