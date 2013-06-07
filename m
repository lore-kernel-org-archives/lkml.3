Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3FGXFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:05:55 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53790 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3FGXDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:55 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 28/31] mips/kvm: Only use KVM_COALESCED_MMIO_PAGE_OFFSET with KVM_MIPSTE
Date: Fri,  7 Jun 2013 16:03:32 -0700
Message-Id: <1370646215-6543-29-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The forthcoming MIPSVZ code doesn't currently use this, so it must
only be enabled for KVM_MIPSTE.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 505b804..9f209e1 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -25,7 +25,9 @@
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 	0
 
+#ifdef CONFIG_KVM_MIPSTE
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#endif
 
 /* Don't support huge pages */
 #define KVM_HPAGE_GFN_SHIFT(x)	0
-- 
1.7.11.7

