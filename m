Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaF3UiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:38:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42821 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaF3UiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:38:15 -0400
Date: Mon, 30 Jun 2014 13:37:59 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Sam Ravnborg <sam@ravnborg.org>,
        sparclinux@vger.kernel.org
Subject: [RESEND][PATCH] sparc: use %s for unaligned panic
Message-ID: <20140630203759.GA4764@www.outflux.net>
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
index c5c61b3c6b56..32b61d1b6379 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -166,7 +166,7 @@ unsigned long safe_compute_effective_address(struct pt_regs *regs,
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
