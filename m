Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3IXOKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab3IXOKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:10:35 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: catalin.marinas@arm.com, christoffer.dall@linaro.org, gleb@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: [PATCH v2] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
Date: Tue, 24 Sep 2013 16:09:28 +0200
Message-Id: <1380031768-21354-1-git-send-email-drjones@redhat.com>
In-Reply-To: <1379160656-28050-3-git-send-email-drjones@redhat.com>
References: <1379160656-28050-3-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the _ARM_ part of the name. We can then introduce a config option
like this to aarch64 and other arches using the same name - allowing
grep to show them all. Also update the help text to describe the option
more completely.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v2: reword help text some more
---
 arch/arm/include/asm/kvm_host.h | 4 ++--
 arch/arm/kvm/Kconfig            | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7d22517d80711..c614d3eb176c6 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -25,8 +25,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
-#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
-#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
+#if defined(CONFIG_KVM_MAX_VCPUS)
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
 #else
 #define KVM_MAX_VCPUS 0
 #endif
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index ebf5015508b52..8e56ccf45edce 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -40,16 +40,17 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
-config KVM_ARM_MAX_VCPUS
+config KVM_MAX_VCPUS
 	int "Number maximum supported virtual CPUs per VM"
 	depends on KVM_ARM_HOST
 	default 4
 	help
 	  Static number of max supported virtual CPUs per VM.
 
-	  If you choose a high number, the vcpu structures will be quite
-	  large, so only choose a reasonable number that you expect to
-	  actually use.
+	  The default is set to the highest number of vcpus that
+	  current hardware supports. Choosing a lower number decreases
+	  the size of the VM data structure. This number may also be
+	  increased.
 
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
-- 
1.8.1.4

