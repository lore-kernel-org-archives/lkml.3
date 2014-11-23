Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaKWShh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:37:37 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49890 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaKWShc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:32 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [PATCH v3 2/8] KVM: arm64: Enable the KVM-VFIO device
Date: Sun, 23 Nov 2014 19:35:54 +0100
Message-Id: <1416767760-14487-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used by KVM-enabled VFIO-based device passthrough support in QEMU.

Signed-off-by: Joel Schopp <joel.schopp@amd.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

Extracted from [RFC PATCH] arm64: KVM: add irqfd support
http://www.spinics.net/lists/kvm-arm/msg10798.html
---
 arch/arm64/kvm/Kconfig  | 1 +
 arch/arm64/kvm/Makefile | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 09c25c2..2edf926 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_ARM_VGIC
 	select KVM_ARM_TIMER
+	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 2e6b827..81ed091 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-- 
1.9.1

