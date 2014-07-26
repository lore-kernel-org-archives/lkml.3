Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbaGZBNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 21:13:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40637 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaGZBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 21:13:13 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/3] x86,vdso: Make the PER_CPU segment start out accessed
Date: Fri, 25 Jul 2014 18:13:00 -0700
Message-Id: <535814741f5cbc28d772364e0b832df976692dae.1406336986.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406336986.git.luto@amacapital.net>
References: <cover.1406336986.git.luto@amacapital.net>
In-Reply-To: <cover.1406336986.git.luto@amacapital.net>
References: <cover.1406336986.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first userspace attempt to read or write the PER_CPU segment
will write the accessed bit to the GDT.  This is visible to
userspace using the LAR instruction.

Set the segment's accessed bit at boot to keep all userspace GDT
access idempotent.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 158cdff..0e2c229 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -305,7 +305,7 @@ static void vsyscall_set_cpu(int cpu)
 	memset(&d, 0, sizeof(d));
 	d.limit0 = cpu | ((node & 0xf) << 12);
 	d.limit = node >> 4;
-	d.type = 4;		/* RO data, expand down */
+	d.type = 5;		/* RO data, expand down, accessed */
 	d.dpl = 3;		/* Visible to user code */
 	d.s = 1;		/* Non a system segment */
 	d.p = 1;		/* Present */
-- 
1.9.3

