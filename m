Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaDBF5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:57:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44034
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbaDBF5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:57:39 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, tglx@linutronix.de,
        hpa@zytor.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] x86: irq: Handle VMBUS driver being a module
Date: Tue,  1 Apr 2014 23:51:42 -0700
Message-Id: <1396421502-23222-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V VMBUS driver can be a module; handle this case correctly. Please apply.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 42805fa..283a76a 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -125,7 +125,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
-#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
-- 
1.7.4.1

