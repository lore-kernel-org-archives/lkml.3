Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3CDNF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:05:29 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50915 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3CDM7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:03 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3 02/23] uuid: use prandom_bytes()
Date: Mon,  4 Mar 2013 21:58:10 +0900
Message-Id: <1362401911-14074-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use prandom_bytes() to generate 16 bytes of pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Huang Ying <ying.huang@intel.com>
---

No change from v2

 lib/uuid.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/lib/uuid.c b/lib/uuid.c
index 52a6fe6..398821e 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -25,13 +25,7 @@
 
 static void __uuid_gen_common(__u8 b[16])
 {
-	int i;
-	u32 r;
-
-	for (i = 0; i < 4; i++) {
-		r = random32();
-		memcpy(b + i * 4, &r, 4);
-	}
+	prandom_bytes(b, 16);
 	/* reversion 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
-- 
1.8.1.2

