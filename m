Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3COANw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:13:52 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47297 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3COANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:13:50 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MA...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
Date: Thu, 14 Mar 2013 17:13:46 -0700
Message-Id: <1363306426-27209-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new context tracking subsystem unconditionally includes kvm_host.h
headers for the guest enter/exit macros.  This causes a compile
failure when KVM is not enabled.

Fix by adding an IS_ENABLED(CONFIG_KVM) check to kvm_host so it can
be included/compiled even when KVM is not enabled.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
Applies on v3.9-rc2

 include/linux/kvm_host.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cad77fe..a942863 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1,6 +1,8 @@
 #ifndef __KVM_HOST_H
 #define __KVM_HOST_H
 
+#if IS_ENABLED(CONFIG_KVM)
+
 /*
  * This work is licensed under the terms of the GNU GPL, version 2.  See
  * the COPYING file in the top-level directory.
@@ -1055,5 +1057,8 @@ static inline bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 }
 
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
+#else
+static inline void __guest_enter(void) { return; }
+static inline void __guest_exit(void) { return; }
+#endif /* IS_ENABLED(CONFIG_KVM) */
 #endif
-
-- 
1.8.1.2

