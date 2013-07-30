Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3G3Fek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:34:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21376 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3G3Fej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:34:39 -0400
Message-ID: <51F75040.1010300@oracle.com>
Date: Tue, 30 Jul 2013 13:33:52 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>
Subject: [PATCH] Return a proper bool value to hypervisor_x2apic_available
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bootup on a bare metal env, hypervisor_x2apic_available should return
ture so that "max_physical_apicid > 255" check in enable_IR_x2apic is useful.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 arch/x86/include/asm/hypervisor.h |    2 +-
 arch/x86/kernel/cpu/hypervisor.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 2d4b5e6..d4c09b3 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -59,6 +59,6 @@ extern bool hypervisor_x2apic_available(void);
 #else
 static inline void init_hypervisor(struct cpuinfo_x86 *c) { }
 static inline void init_hypervisor_platform(void) { }
-static inline bool hypervisor_x2apic_available(void) { return false; }
+static inline bool hypervisor_x2apic_available(void) { return true; }
 #endif /* CONFIG_HYPERVISOR_GUEST */
 #endif /* _ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8727921..ee303cd 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -82,7 +82,7 @@ void __init init_hypervisor_platform(void)
 
 bool __init hypervisor_x2apic_available(void)
 {
-	return x86_hyper                   &&
+	return !x86_hyper                  ||
 	       x86_hyper->x2apic_available &&
 	       x86_hyper->x2apic_available();
 }
-- 
1.7.3

