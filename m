Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbbAHMO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:14:57 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:56386 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbbAHMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:14:56 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] lib/vsprintf.c: Improve sanity check in vsnprintf()
Date: Thu,  8 Jan 2015 13:14:45 +0100
Message-Id: <1420719287-10222-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit, size may very well be huge even if bit 31 happens to be
0. Somehow it doesn't feel right that one can pass a 5 GiB buffer but
not a 3 GiB one. So cap at INT_MAX as was probably the intention all
along. This is also the made-up value passed by sprintf and vsprintf.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 98ad170b10e0..cf12ba86205c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1727,7 +1727,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE(size > INT_MAX))
 		return 0;
 
 	str = buf;
-- 
2.1.3

