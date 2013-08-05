Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3HEN6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:58:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3HEN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:58:08 -0400
Date: Mon, 5 Aug 2013 06:57:51 -0700
From: tip-bot for Jason Wang <tipbot@zytor.com>
Message-ID: <tip-448ac44d561f0aba5baac54bac62fe40d07230b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jasowang@redhat.com, jeremy@goop.org,
        pbonzini@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jasowang@redhat.com, jeremy@goop.org,
        pbonzini@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1374742475-2485-2-git-send-email-jasowang@redhat.com>
References: <1374742475-2485-2-git-send-email-jasowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] xen: Switch to use hypervisor_cpuid_base()
Git-Commit-ID: 448ac44d561f0aba5baac54bac62fe40d07230b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 05 Aug 2013 06:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  448ac44d561f0aba5baac54bac62fe40d07230b6
Gitweb:     http://git.kernel.org/tip/448ac44d561f0aba5baac54bac62fe40d07230b6
Author:     Jason Wang <jasowang@redhat.com>
AuthorDate: Thu, 25 Jul 2013 16:54:33 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 Aug 2013 06:34:09 -0700

xen: Switch to use hypervisor_cpuid_base()

Switch to use hypervisor_cpuid_base() to detect Xen.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: http://lkml.kernel.org/r/1374742475-2485-2-git-send-email-jasowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xen/hypervisor.h | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 125f344..d866959 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -40,21 +40,7 @@ extern struct start_info *xen_start_info;
 
 static inline uint32_t xen_cpuid_base(void)
 {
-	uint32_t base, eax, ebx, ecx, edx;
-	char signature[13];
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
-		cpuid(base, &eax, &ebx, &ecx, &edx);
-		*(uint32_t *)(signature + 0) = ebx;
-		*(uint32_t *)(signature + 4) = ecx;
-		*(uint32_t *)(signature + 8) = edx;
-		signature[12] = 0;
-
-		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
-			return base;
-	}
-
-	return 0;
+	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
 }
 
 #ifdef CONFIG_XEN
