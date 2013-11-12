Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3KLQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:56:24 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36301 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab3KLQ4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:56:22 -0500
Date: Tue, 12 Nov 2013 08:56:07 -0800
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] x86, kaslr: use char array to gain sizeof sanity
Message-ID: <20131112165607.GA5921@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build_str needs to be char [] not char * for the sizeof() to report
the string length.

Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 8746487fa916..9777ed15fbb9 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -13,7 +13,7 @@
 #include <linux/version.h>
 
 /* Simplified build-specific string for starting entropy. */
-static const char *build_str = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
 #define I8254_PORT_CONTROL	0x43
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
