Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaKILXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:23:04 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:34416 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbaKILXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:23:01 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 06:23:01 EST
From: =?UTF-8?q?Antti=20T=C3=B6nkyr=C3=A4?= <daedalus@pingtimeout.net>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Antti=20T=C3=B6nkyr=C3=A4?= <daedalus@pingtimeout.net>
Subject: [PATCH] x86: Fix duplicate abbreviation in irq.c
Date: Sun,  9 Nov 2014 13:16:15 +0200
Message-Id: <1415531775-3188-1-git-send-email-daedalus@pingtimeout.net>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 929320e4b4c10708d3477d7e395f0ce7b0cc8744 introduces accounting
for hypervisor callback vector. However, I think there was a small
oversight because the new vector has abbreviation THR which makes no
sense to me at all because it collides with threshold interrupt and
subsequently causes some tools behave badly because they rely on
uniqueness of the first field in /proc/interrupts.

This commit renames the duplicate THR to HCI.

Signed-off-by: Antti Tönkyrä <daedalus@pingtimeout.net>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 922d285..3579b27 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -127,7 +127,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
-	seq_printf(p, "%*s: ", prec, "THR");
+	seq_printf(p, "%*s: ", prec, "HCI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_printf(p, "  Hypervisor callback interrupts\n");
-- 
2.0.4

