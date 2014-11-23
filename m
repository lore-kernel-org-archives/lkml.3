Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaKWShc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:37:32 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48972 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaKWSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:29 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com,
        Kim Phillips <kim.phillips@linaro.org>
Subject: [PATCH v3 1/8] KVM: arm: Enable the KVM-VFIO device
Date: Sun, 23 Nov 2014 19:35:53 +0100
Message-Id: <1416767760-14487-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kim Phillips <kim.phillips@linaro.org>

Used by KVM-enabled VFIO-based device passthrough support in QEMU.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
 arch/arm/kvm/Kconfig  | 1 +
 arch/arm/kvm/Makefile | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index e519a40..aace254 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_MMIO
 	select KVM_ARM_HOST
 	depends on ARM_VIRT_EXT && ARM_LPAE
+	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines. You will also
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 859db09..ea1fa76 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-- 
1.9.1

