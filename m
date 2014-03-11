Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaCKUYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:24:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53961 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaCKUYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:24:50 -0400
Date: Tue, 11 Mar 2014 13:24:46 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] sparc: use %s for unaligned panic
Message-ID: <20140311202446.GA24531@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since unaligned_panic() takes a literal string, make sure it can never
accidentally be used as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/sparc/kernel/unaligned_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index c0ec89786193..892e399414e0 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -162,7 +162,7 @@ unsigned long safe_compute_effective_address(struct pt_regs *regs,
 /* This is just to make gcc think panic does return... */
 static void unaligned_panic(char *str)
 {
-	panic(str);
+	panic("%s", str);
 }
 
 /* una_asm.S */
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
