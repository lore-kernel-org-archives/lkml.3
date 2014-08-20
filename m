Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaHTSrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:47:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHTSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:47:41 -0400
Date: Wed, 20 Aug 2014 11:46:50 -0700
From: tip-bot for Andreas Ruprecht <tipbot@zytor.com>
Message-ID: <tip-8091c1f8ea2374695c105591179b1269fb5f2fbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, torvalds@linux-foundation.org, rupran@einserver.de,
        hedi@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rupran@einserver.de, torvalds@linux-foundation.org, travis@sgi.com,
        hedi@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1408522561-23389-1-git-send-email-rupran@einserver.de>
References: <1408522561-23389-1-git-send-email-rupran@einserver.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/apic/uv: Remove unnecessary #ifdef
Git-Commit-ID: 8091c1f8ea2374695c105591179b1269fb5f2fbb
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

Commit-ID:  8091c1f8ea2374695c105591179b1269fb5f2fbb
Gitweb:     http://git.kernel.org/tip/8091c1f8ea2374695c105591179b1269fb5f2fbb
Author:     Andreas Ruprecht <rupran@einserver.de>
AuthorDate: Wed, 20 Aug 2014 10:16:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 15:05:30 +0200

x86/apic/uv: Remove unnecessary #ifdef

In the file x2apic_uv_x.c, some code is compiled conditionally
depending on CONFIG_SMP. However, the file is only built, if
CONFIG_X86_UV is enabled.

CONFIG_X86_UV depends on CONFIG_NUMA, which itself depends on
CONFIG_SMP, so the #ifdef will always evaluate to true, if the
file is compiled. Thus, it is unnecessary and can be removed.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/1408522561-23389-1-git-send-email-rupran@einserver.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 293b41d..2f1b5e0 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -204,7 +204,6 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
-#ifdef CONFIG_SMP
 	unsigned long val;
 	int pnode;
 
@@ -223,7 +222,6 @@ static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 
 	atomic_set(&init_deasserted, 1);
-#endif
 	return 0;
 }
 
