Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3GWJwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:52:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3GWJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:52:29 -0400
From: Jason Wang <jasowang@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
Date: Tue, 23 Jul 2013 17:41:05 +0800
Message-Id: <1374572465-15278-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kvm has some basic support of hyperv, this will cause the guest to
identify itself as running on top of hyperv instead of kvm which will disable
kvm pv functionality. This is because we try to detect hyperv before kvm. Solve
this by simply checking kvm in detect_hypervisor() first.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8727921..3e149b6 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -36,10 +36,10 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 	&x86_hyper_xen_hvm,
 #endif
 	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
 #endif
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
-- 
1.7.1

