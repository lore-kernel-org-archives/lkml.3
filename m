Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3CDM7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:18 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36753 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3CDM7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:14 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-mm@kvack.org
Subject: [PATCH -v3 06/23] mm/: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:14 +0900
Message-Id: <1362401911-14074-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-mm@kvack.org
---

No change from v2

 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a1f7772..d417efd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2120,7 +2120,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 			p->flags |= SWP_SOLIDSTATE;
-			p->cluster_next = 1 + (random32() % p->highest_bit);
+			p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
 		}
 		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
-- 
1.8.1.2

