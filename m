Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaKFPx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:53:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKFPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:53:23 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] kvm: x86: increase user memory slots to 509
Date: Thu,  6 Nov 2014 15:52:47 +0000
Message-Id: <1415289167-24661-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 3 private slots, this gives us 512 slots total.
Motivation for this is in addition to assigned devices
support more memory hotplug slots, where 1 slot is
used by a hotplugged memory stick.
It will allow to support upto 256 hotplug memory
slots and leave 253 slots for assigned devices and
other devices that use them.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
previously increased to 125 slots for assigned devices
by 0f888f5acd
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ed0c30..cfd60e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -33,7 +33,7 @@
 
 #define KVM_MAX_VCPUS 255
 #define KVM_SOFT_MAX_VCPUS 160
-#define KVM_USER_MEM_SLOTS 125
+#define KVM_USER_MEM_SLOTS 509
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
-- 
1.8.3.1

