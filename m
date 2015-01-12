Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbbALXEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:04:22 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:48508 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbbALXEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:04:20 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v2 1/3] x86: Fix off-by-one in the instruction decoder length checks
Date: Mon, 12 Jan 2015 15:04:09 -0800
Message-Id: <602a94627fedaab4e339088d633b72174caf14c9.1421103159.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421103159.git.luto@amacapital.net>
References: <cover.1421103159.git.luto@amacapital.net>
In-Reply-To: <cover.1421103159.git.luto@amacapital.net>
References: <cover.1421103159.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If next_byte + sizeof(t) == end_kaddr, then we are trying to read
exactly to the end; this should be allowed.

Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/lib/insn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978b31cc..1313ae6b478b 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
+	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
-- 
2.1.0

