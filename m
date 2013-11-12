Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3KLRBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:01:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3KLRBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:01:46 -0500
Date: Tue, 12 Nov 2013 09:01:23 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-327f7d72454aecdc7a4a1c847a291a3f224b730f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <20131112165607.GA5921@www.outflux.net>
References: <20131112165607.GA5921@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: Use char array to gain sizeof sanity
Git-Commit-ID: 327f7d72454aecdc7a4a1c847a291a3f224b730f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 09:01:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  327f7d72454aecdc7a4a1c847a291a3f224b730f
Gitweb:     http://git.kernel.org/tip/327f7d72454aecdc7a4a1c847a291a3f224b730f
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 12 Nov 2013 08:56:07 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 12 Nov 2013 08:58:35 -0800

x86, kaslr: Use char array to gain sizeof sanity

The build_str needs to be char [] not char * for the sizeof() to report
the string length.

Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20131112165607.GA5921@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/aslr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 38a07cc..84be175 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -13,7 +13,7 @@
 #include <linux/version.h>
 
 /* Simplified build-specific string for starting entropy. */
-static const char *build_str = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
 #define I8254_PORT_CONTROL	0x43
