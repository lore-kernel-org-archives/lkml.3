Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaLCQI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:59 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49998 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaLCQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:57 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 1/5] KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
Date: Wed,  3 Dec 2014 17:07:08 +0100
Message-Id: <1417622832-5460-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HAVE_KVM_IRQCHIP is needed to support IRQ routing (along
with irq_comm.c and irqchip.c usage). This is not the case for
arm/arm64 currently.

This patch unsets the flag for both arm and arm64.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kvm/Kconfig   | 2 --
 arch/arm64/kvm/Kconfig | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 466bd29..9f581b1 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -55,7 +55,6 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
 	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
 	default y
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
@@ -63,7 +62,6 @@ config KVM_ARM_VGIC
 config KVM_ARM_TIMER
 	bool "KVM support for Architected Timers"
 	depends on KVM_ARM_VGIC && ARM_ARCH_TIMER
-	select HAVE_KVM_IRQCHIP
 	default y
 	---help---
 	  Adds support for the Architected Timers in virtual machines
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8ba85e9..279e1a0 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -50,7 +50,6 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool
 	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
 
-- 
1.9.1

