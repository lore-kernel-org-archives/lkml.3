Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaIWRva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:51:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61375 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbaIWRvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:51:20 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 5/8] x86,vdso: Make the PER_CPU segment 32 bits
Date: Tue, 23 Sep 2014 10:50:55 -0700
Message-Id: <179f490d659307873eefd09206bebd417e2ab5ad.1411494540.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
In-Reply-To: <cover.1411494540.git.luto@amacapital.net>
References: <cover.1411494540.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO users ought not to be able to use 16-bit segments without using
modify_ldt.  Fortunately, it's impossible to break espfix64 by
loading the PER_CPU segment into SS because it's PER_CPU is marked
read-only and SS cannot contain an RO segment, but marking PER_CPU
as 32-bit is less fragile.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 0c7997467be0..32ca60c8157b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -268,6 +268,7 @@ static void vsyscall_set_cpu(int cpu)
 		.dpl = 3,		/* Visible to user code */
 		.s = 1,			/* Not a system segment */
 		.p = 1,			/* Present */
+		.d = 1,			/* 32-bit */
 	};
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
-- 
1.9.3

