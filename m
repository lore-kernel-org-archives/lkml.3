Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab3INMSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab3INMSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:18:54 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org
Cc: gleb@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: introduce CONFIG_KVM_MAX_VCPUS
Date: Sat, 14 Sep 2013 14:18:49 +0200
Message-Id: <1379161129-28393-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take CONFIG_KVM_MAX_VCPUS from arm32, but set the default to 255.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/Kconfig            | 10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74a98f2e..e7e9b523a8f7e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,8 +31,9 @@
 #include <asm/msr-index.h>
 #include <asm/asm.h>
 
-#define KVM_MAX_VCPUS 255
-#define KVM_SOFT_MAX_VCPUS 160
+#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
+#define KVM_SOFT_MAX_VCPUS min(160, KVM_MAX_VCPUS)
+
 #define KVM_USER_MEM_SLOTS 125
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a47a3e54b964b..e9532c33527ee 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -52,6 +52,16 @@ config KVM
 
 	  If unsure, say N.
 
+config KVM_MAX_VCPUS
+	int "Number maximum supported virtual CPUs per VM"
+	depends on KVM
+	default 255
+	help
+	  Static number of max supported virtual CPUs per VM.
+
+	  Set to a lower number to save some resources. Set to a higher
+	  number to test scalability.
+
 config KVM_INTEL
 	tristate "KVM for Intel processors support"
 	depends on KVM
-- 
1.8.1.4

