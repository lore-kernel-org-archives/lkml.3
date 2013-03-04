Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3CDM7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab3CDM7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:00 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH -v3 01/23] raid6test: use prandom_bytes()
Date: Mon,  4 Mar 2013 21:58:09 +0900
Message-Id: <1362401911-14074-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use prandom_bytes() to generate random bytes for test data.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
---

No change from v2

 crypto/async_tx/raid6test.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index aa2b027..4a92bac 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -46,15 +46,10 @@ static void callback(void *param)
 
 static void makedata(int disks)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < disks; i++) {
-		for (j = 0; j < PAGE_SIZE/sizeof(u32); j += sizeof(u32)) {
-			u32 *p = page_address(data[i]) + j;
-
-			*p = random32();
-		}
-
+		prandom_bytes(page_address(data[i]), PAGE_SIZE);
 		dataptrs[i] = data[i];
 	}
 }
-- 
1.8.1.2

