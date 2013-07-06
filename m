Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3GFXgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 19:36:39 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:37446 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3GFXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 19:36:38 -0400
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: [PATCH] lib: One less subtraction in binary search iterations.
Date: Sat,  6 Jul 2013 16:07:42 -0700
Message-Id: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no functional change, but this change eliminates a subtraction that
the compiler doesn't optimize out (as of gcc 4.7.3).

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
---
 lib/bsearch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index e33c179..3264146 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -37,7 +37,7 @@ void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	int result;
 
 	while (start < end) {
-		size_t mid = start + (end - start) / 2;
+		size_t mid = (start + end) / 2;
 
 		result = cmp(key, base + mid * size);
 		if (result < 0)
-- 
1.7.9.5

