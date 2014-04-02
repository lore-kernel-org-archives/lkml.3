Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaDBMOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:14:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbaDBMOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:14:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>, Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] x86, fix defined for VECTOR_UNDEFINED and VECTOR_RETRIGGERED
Date: Wed,  2 Apr 2014 08:13:47 -0400
Message-Id: <1396440827-18352-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending ... want to make sure this wasn't dropped for some reason.

Sent previously here: http://marc.info/?l=linux-kernel&m=139405208523968&w=2

P.

---8<---

During another patch review, David Rientjes noted that VECTOR_UNDEFINED
and VECTOR_RETRIGGERED should be defined with ()s so that they are not
erroneously used in an arithmetic operation.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/hw_irq.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 67d69b8..9d4dabe 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -191,8 +191,8 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 #define trace_interrupt interrupt
 #endif
 
-#define VECTOR_UNDEFINED	-1
-#define VECTOR_RETRIGGERED	-2
+#define VECTOR_UNDEFINED	(-1)
+#define VECTOR_RETRIGGERED	(-2)
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-- 
1.7.9.3

