Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3C2NSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:18:31 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59008 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab3C2NSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:18:30 -0400
Message-ID: <1364563104.1345.74.camel@x61.thuisdomein>
Subject: [PATCH] ARM: Fix typo "CONFIG_LPAE" twice
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 14:18:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 13:18:25.0177 (UTC) FILETIME=[E4D22890:01CE2C7F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) This typo was first introduced in v3.4: commit
e5ab85800820edd907d3f43f285e1232f84d5a41 ("ARM: 7382/1: mm: truncate
memory banks to fit in 4GB space for classic MMU"). The second instance
was added in v3.9-rc2: commit d61947a164760ac520cb416768afdf38c33d60e7
(" ARM: 7657/1: head: fix swapper and idmap population with LPAE and
big-endian"). So testing is really needed here.

2) If this passes (review and) testing, this probably needs to go to
stable too.

 arch/arm/kernel/head.S  | 2 +-
 arch/arm/kernel/setup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index e0eb9a1..8bac553 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -267,7 +267,7 @@ __create_page_tables:
 	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]
 
-#if defined(CONFIG_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
+#if defined(CONFIG_ARM_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
 	sub	r4, r4, #4			@ Fixup page table pointer
 						@ for 64-bit descriptors
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..62ead98 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -524,7 +524,7 @@ int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 	size -= start & ~PAGE_MASK;
 	bank->start = PAGE_ALIGN(start);
 
-#ifndef CONFIG_LPAE
+#ifndef CONFIG_ARM_LPAE
 	if (bank->start + size < bank->start) {
 		printk(KERN_CRIT "Truncating memory at 0x%08llx to fit in "
 			"32-bit physical address space\n", (long long)start);
-- 
1.7.11.7

