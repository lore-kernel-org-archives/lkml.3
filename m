Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3INMML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab3INMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:11:51 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: catalin.marinas@arm.com, christoffer.dall@linaro.org, gleb@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: [PATCH 3/3] aarch64: kvm: introduce CONFIG_KVM_MAX_VCPUS
Date: Sat, 14 Sep 2013 14:10:56 +0200
Message-Id: <1379160656-28050-4-git-send-email-drjones@redhat.com>
In-Reply-To: <1379160656-28050-1-git-send-email-drjones@redhat.com>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take CONFIG_KVM_MAX_VCPUS from arm32, but set the default to 8.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 ++++++-
 arch/arm64/kvm/Kconfig            | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0859a4ddd1e7d..d1af8c49a5ca4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,7 +26,12 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 
-#define KVM_MAX_VCPUS 4
+#if defined(CONFIG_KVM_MAX_VCPUS)
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
+#else
+#define KVM_MAX_VCPUS 0
+#endif
+
 #define KVM_USER_MEM_SLOTS 32
 #define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 21e90820bd23c..c9924b02e84f7 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -35,6 +35,17 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
+config KVM_MAX_VCPUS
+	int "Number maximum supported virtual CPUs per VM"
+	depends on KVM_ARM_HOST
+	default 8
+	help
+	  Static number of max supported virtual CPUs per VM.
+
+	  The default is set to the highest number of vcpus that
+	  current hardware supports. Set to a lower number to save
+	  some resources. Set to a higher number to test scalability.
+
 config KVM_ARM_VGIC
 	bool
 	depends on KVM_ARM_HOST && OF
-- 
1.8.1.4

