Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaEOJvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:51:15 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:49052 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaEOJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:51:14 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] kvm: increase max vcpu count
Date: Thu, 15 May 2014 17:50:17 +0800
Message-Id: <1400147417-22269-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is trying to increase the maximum supported vcpu number.

There has been big system supporting more than 256 logical CPUs, and vmware
can also support guest system with more than logical 256 CPUs. So kvm should 
also increase the maximum supported cpu number.

This patch only includes kernel kvm's part. The qemu support will be another 
thread.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7de069af..92cc83c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,8 +31,8 @@
 #include <asm/msr-index.h>
 #include <asm/asm.h>
 
-#define KVM_MAX_VCPUS 255
-#define KVM_SOFT_MAX_VCPUS 160
+#define KVM_MAX_VCPUS 4096
+#define KVM_SOFT_MAX_VCPUS 4096
 #define KVM_USER_MEM_SLOTS 125
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
-- 
2.0.0-rc0

