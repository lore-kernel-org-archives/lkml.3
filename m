Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaFJRyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:54:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42522 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaFJRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:54:40 -0400
Date: Tue, 10 Jun 2014 10:54:06 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/xmon: avoid format string leaking to printk
Message-ID: <20140610175406.GA30672@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure format strings cannot leak into printk (the string has
already been correctly processed for format arguments).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/xmon/nonstdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/xmon/nonstdio.c b/arch/powerpc/xmon/nonstdio.c
index bce3dcfe5058..c98748617896 100644
--- a/arch/powerpc/xmon/nonstdio.c
+++ b/arch/powerpc/xmon/nonstdio.c
@@ -122,7 +122,7 @@ void xmon_printf(const char *format, ...)
 
 	if (n && rc == 0) {
 		/* No udbg hooks, fallback to printk() - dangerous */
-		printk(xmon_outbuf);
+		printk("%s", xmon_outbuf);
 	}
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
