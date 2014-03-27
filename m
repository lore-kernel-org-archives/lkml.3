Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaC0VmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:42:22 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41138 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbaC0VmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:42:20 -0400
From: behanw@converseincode.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] crypto: LLVMLinux: aligned-attribute.patch
Date: Thu, 27 Mar 2014 14:41:37 -0700
Message-Id: <1395956497-22774-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

__attribute__((aligned)) applies the default alignment for the largest scalar
type for the target ABI. gcc allows it to be applied inline to a defined type.
Clang only allows it to be applied to a type definition (PR11071).

Making it into 2 lines makes it more readable and works with both compilers.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 crypto/shash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 929058a..47c7139 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -67,7 +67,8 @@ EXPORT_SYMBOL_GPL(crypto_shash_setkey);
 static inline unsigned int shash_align_buffer_size(unsigned len,
 						   unsigned long mask)
 {
-	return len + (mask & ~(__alignof__(u8 __attribute__ ((aligned))) - 1));
+	typedef u8 __attribute__ ((aligned)) u8_aligned;
+	return len + (mask & ~(__alignof__(u8_aligned) - 1));
 }
 
 static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
-- 
1.8.3.2

