Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaLDJtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:49:52 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64769 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaLDJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:49:49 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: [PATCH v2 1/4] KVM: arm/arm64: vgic: vgic_init_maps returns -ENODEV when no online vcpu
Date: Thu,  4 Dec 2014 10:48:01 +0100
Message-Id: <1417686484-20828-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
References: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be more explicit upon vgic initialization failure, -ENODEV is
returned by vgic_init_maps when no online vcpus can be found at
init.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b76c38c..907ba0e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1991,7 +1991,7 @@ static int vgic_init_maps(struct kvm *kvm)
 
 	nr_cpus = dist->nr_cpus = atomic_read(&kvm->online_vcpus);
 	if (!nr_cpus)		/* No vcpus? Can't be good... */
-		return -EINVAL;
+		return -ENODEV;
 
 	/*
 	 * If nobody configured the number of interrupts, use the
-- 
1.9.1

