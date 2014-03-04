Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbaCDO2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbaCDO2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:28:19 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Rui Wang <rui.y.wang@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com, ruiv.wang@gmail.com
Subject: [PATCH] x86, apic, Fix missing replacement for VECTOR_UNDEFINED
Date: Tue,  4 Mar 2014 09:27:51 -0500
Message-Id: <1393943271-17447-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux.git commit 9345005f4eed805308193658d12e4e7e9c261e74 added
a definition for VECTOR_UNDEFINED = -1.  There is a missing replacement in
the io_apic.c file.  Found during debugging of another issue.

Cc: Rui Wang <rui.y.wang@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: janet.morgan@Intel.com
Cc: tony.luck@Intel.com
Cc: ruiv.wang@gmail.com
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..bf97b64 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2240,7 +2240,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__this_cpu_write(vector_irq[vector], -1);
+		__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
-- 
1.7.9.3

