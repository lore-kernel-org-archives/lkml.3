Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaG3WH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:07:26 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62410 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaG3WHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:07:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/3] x86,vdso: Make the PER_CPU segment 32 bits
Date: Wed, 30 Jul 2014 15:07:05 -0700
Message-Id: <43d8d7cb108afa99d34f2b16d965e8304ff951e1.1406757779.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406757779.git.luto@amacapital.net>
References: <cover.1406757779.git.luto@amacapital.net>
In-Reply-To: <cover.1406757779.git.luto@amacapital.net>
References: <cover.1406757779.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO users ought not to be able to use 16-bit segments without using
modify_ldt.  Fortunately, it's impossible to break espfix64 by
loading the PER_CPU segment into SS because it's a read-only
segment, but marking it 32-bit seems less fragile.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ae80ef6..0d71181 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -309,6 +309,7 @@ static void vsyscall_set_cpu(int cpu)
 	d.dpl = 3;		/* Visible to user code */
 	d.s = 1;		/* Not a system segment */
 	d.p = 1;		/* Present */
+	d.d = 1;		/* 32-bit */
 
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
-- 
1.9.3

