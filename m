Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3D1BcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:32:11 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:8847 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3D1BcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:32:09 -0400
From: Chegu Vinod <chegu_vinod@hp.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, Chegu Vinod <chegu_vinod@hp.com>
Subject: [PATCH] KVM: x86: Increase the "hard" max VCPU limit
Date: Sat, 27 Apr 2013 18:31:04 -0700
Message-Id: <1367112664-19862-1-git-send-email-chegu_vinod@hp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM guests today use 8bit APIC ids allowing for 256 ID's. Reserving one
ID for Broadcast interrupts should leave 255 ID's. In case of KVM there
is no need for reserving another ID for IO-APIC so the hard max limit for
VCPUS can be increased from 254 to 255. (This was confirmed by Gleb Natapov
http://article.gmane.org/gmane.comp.emulators.kvm.devel/99713  )

Signed-off-by: Chegu Vinod <chegu_vinod@hp.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4979778..bc57bfa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,7 +31,7 @@
 #include <asm/msr-index.h>
 #include <asm/asm.h>
 
-#define KVM_MAX_VCPUS 254
+#define KVM_MAX_VCPUS 255
 #define KVM_SOFT_MAX_VCPUS 160
 #define KVM_USER_MEM_SLOTS 125
 /* memory slots that are not exposed to userspace */
-- 
1.7.1
