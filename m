Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3INMMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab3INMLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:11:47 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: catalin.marinas@arm.com, christoffer.dall@linaro.org, gleb@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: [PATCH 2/3] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
Date: Sat, 14 Sep 2013 14:10:55 +0200
Message-Id: <1379160656-28050-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1379160656-28050-1-git-send-email-drjones@redhat.com>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the _ARM_ part of the name. We can then introduce a config option
like this to aarch64 and other arches using the same name - allowing
grep to show them all. Also update the help text to describe the option
more completely.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_host.h | 4 ++--
 arch/arm/kvm/Kconfig            | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

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
index ebf5015508b52..de63bfccb3eb5 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -40,16 +40,16 @@ config KVM_ARM_HOST
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
+	  current hardware supports. Set to a lower number to save
+	  some resources. Set to a higher number to test scalability.
 
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
-- 
1.8.1.4

