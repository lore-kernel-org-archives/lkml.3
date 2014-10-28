Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaJ1LPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:15:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaJ1LPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:15:49 -0400
Date: Tue, 28 Oct 2014 04:15:38 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-287e013108a104e459e675432cf20087feab2b67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, luto@amacapital.net
Reply-To: luto@amacapital.net, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <179f490d659307873eefd09206bebd417e2ab5ad.1411494540.git.luto@amacapital.net>
References: <179f490d659307873eefd09206bebd417e2ab5ad.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso: Make the PER_CPU segment 32 bits
Git-Commit-ID: 287e013108a104e459e675432cf20087feab2b67
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

Commit-ID:  287e013108a104e459e675432cf20087feab2b67
Gitweb:     http://git.kernel.org/tip/287e013108a104e459e675432cf20087feab2b67
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:55 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:12 +0100

x86/vdso: Make the PER_CPU segment 32 bits

IMO users ought not to be able to use 16-bit segments without
using modify_ldt.  Fortunately, it's impossible to break
espfix64 by loading the PER_CPU segment into SS because it's
PER_CPU is marked read-only and SS cannot contain an RO segment,
but marking PER_CPU as 32-bit is less fragile.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/179f490d659307873eefd09206bebd417e2ab5ad.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 0c799746..32ca60c 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -268,6 +268,7 @@ static void vsyscall_set_cpu(int cpu)
 		.dpl = 3,		/* Visible to user code */
 		.s = 1,			/* Not a system segment */
 		.p = 1,			/* Present */
+		.d = 1,			/* 32-bit */
 	};
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
