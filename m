Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaDOIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:25:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDOIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:25:23 -0400
Date: Tue, 15 Apr 2014 01:24:56 -0700
From: tip-bot for Prarit Bhargava <tipbot@zytor.com>
Message-ID: <tip-79a51b25badae79d2da6f7b54530adf56697f669@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, yang.z.zhang@Intel.com, tglx@linutronix.de,
        prarit@redhat.com, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, yang.z.zhang@Intel.com, tglx@linutronix.de,
        prarit@redhat.com, rientjes@google.com
In-Reply-To: <1396440827-18352-1-git-send-email-prarit@redhat.com>
References: <1396440827-18352-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/irq:
  Clean up VECTOR_UNDEFINED and VECTOR_RETRIGGERED definition
Git-Commit-ID: 79a51b25badae79d2da6f7b54530adf56697f669
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79a51b25badae79d2da6f7b54530adf56697f669
Gitweb:     http://git.kernel.org/tip/79a51b25badae79d2da6f7b54530adf56697f669
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Wed, 2 Apr 2014 08:13:47 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Apr 2014 13:42:05 +0200

x86/irq: Clean up VECTOR_UNDEFINED and VECTOR_RETRIGGERED definition

During another patch review, David Rientjes noted that
VECTOR_UNDEFINED and VECTOR_RETRIGGERED should be defined with ()s
so that they are not erroneously used in an arithmetic operation.

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Link: http://lkml.kernel.org/r/1396440827-18352-1-git-send-email-prarit@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/hw_irq.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a307b75..4615906 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -190,8 +190,8 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 #define trace_interrupt interrupt
 #endif
 
-#define VECTOR_UNDEFINED	-1
-#define VECTOR_RETRIGGERED	-2
+#define VECTOR_UNDEFINED	(-1)
+#define VECTOR_RETRIGGERED	(-2)
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
