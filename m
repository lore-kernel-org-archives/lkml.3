Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaA0XFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:05:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37069 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbaA0XFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:05:50 -0500
Date: Mon, 27 Jan 2014 15:03:26 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>, Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH] vsprintf: BUG on %n
Message-ID: <20140127230326.GA877@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there has been a full release of the kernel, and all users
of %n have been dropped, switch to %n use triggering a BUG. Ignoring
arguments could be used to assist in information leaks if an arbitrary
format string was under the control of an attacker.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/vsprintf.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 185b6d300ebc..a27fd7f61325 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1735,15 +1735,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		case FORMAT_TYPE_NRCHARS: {
 			/*
 			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
+			 * utility, it should not be implemented. Instead,
+			 * BUG when encountering %n, since there are no
+			 * legitimate users and skipping arguments could
+			 * assist information leak attacks.
 			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
-
-			skip_arg = va_arg(args, void *);
-			break;
+			BUG();
 		}
 
 		default:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
