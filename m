Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaAMP6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:58:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaAMP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:34 -0500
Date: Mon, 13 Jan 2014 07:57:25 -0800
From: tip-bot for Prarit Bhargava <tipbot@zytor.com>
Message-ID: <tip-c7a730fa4624092e2d1c0cb7b750816e87c32364@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, joro@8bytes.org, tglx@linutronix.de,
        sebastian@breakpoint.cc, prarit@redhat.com, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, joro@8bytes.org, tglx@linutronix.de,
        sebastian@breakpoint.cc, fengguang.wu@intel.com, prarit@redhat.com
In-Reply-To: <1389620420-7110-1-git-send-email-prarit@redhat.com>
References: <1389620420-7110-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86/irq:
  Fix kbuild warning in smp_irq_move_cleanup_interrupt()
Git-Commit-ID: c7a730fa4624092e2d1c0cb7b750816e87c32364
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:57:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7a730fa4624092e2d1c0cb7b750816e87c32364
Gitweb:     http://git.kernel.org/tip/c7a730fa4624092e2d1c0cb7b750816e87c32364
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Mon, 13 Jan 2014 08:40:20 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:08:37 +0100

x86/irq: Fix kbuild warning in smp_irq_move_cleanup_interrupt()

Fengguang Wu's 0day kernel build service reported the following build warning:

  arch/x86/kernel/apic/io_apic.c:2211
  smp_irq_move_cleanup_interrupt() warn: always true condition '(irq <= -1) => (0-u32max <= (-1))'

because irq is defined as an unsigned int instead of an int.
Fix this trivial error by redefining irq as a signed int.  The
remaining consumers of the int are okay.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/1389620420-7110-1-git-send-email-prarit@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6df0b66..a43f068 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2202,7 +2202,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
+		int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
