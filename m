Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaDBHzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:55:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaDBHzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:55:46 -0400
Date: Wed, 2 Apr 2014 00:55:25 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-f704a7d7f1d815621cb4c47f7a94787e1bd7c27c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de
In-Reply-To: <1396421502-23222-1-git-send-email-kys@microsoft.com>
References: <1396421502-23222-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/platform/hyperv:
  Handle VMBUS driver being a module
Git-Commit-ID: f704a7d7f1d815621cb4c47f7a94787e1bd7c27c
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

Commit-ID:  f704a7d7f1d815621cb4c47f7a94787e1bd7c27c
Gitweb:     http://git.kernel.org/tip/f704a7d7f1d815621cb4c47f7a94787e1bd7c27c
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Tue, 1 Apr 2014 23:51:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 2 Apr 2014 09:49:47 +0200

x86/platform/hyperv: Handle VMBUS driver being a module

Hyper-V VMBUS driver can be a module; handle this case
correctly. Please apply.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: olaf@aepfle.de
Cc: apw@canonical.com
Cc: jasowang@redhat.com
Link: http://lkml.kernel.org/r/1396421502-23222-1-git-send-email-kys@microsoft.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
