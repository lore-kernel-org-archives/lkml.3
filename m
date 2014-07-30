Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaG3WIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:08:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34086 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaG3WHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:07:17 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/3] x86,vdso: Make the PER_CPU segment start out accessed
Date: Wed, 30 Jul 2014 15:07:04 -0700
Message-Id: <0228977844f2a725b39c88b2eec2feb7fa10e849.1406757779.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406757779.git.luto@amacapital.net>
References: <cover.1406757779.git.luto@amacapital.net>
In-Reply-To: <cover.1406757779.git.luto@amacapital.net>
References: <cover.1406757779.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first userspace attempt to read or write the PER_CPU segment
will write the accessed bit to the GDT.  This is visible to
userspace using the LAR instruction.

Set the segment's accessed bit at boot to prevent userspace
access to segments from having side effects.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 28d0ad6..ae80ef6 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -305,7 +305,7 @@ static void vsyscall_set_cpu(int cpu)
 	memset(&d, 0, sizeof(d));
 	d.limit0 = cpu | ((node & 0xf) << 12);
 	d.limit = node >> 4;
-	d.type = 4;		/* RO data, expand down */
+	d.type = 5;		/* RO data, expand down, accessed */
 	d.dpl = 3;		/* Visible to user code */
 	d.s = 1;		/* Not a system segment */
 	d.p = 1;		/* Present */
-- 
1.9.3

