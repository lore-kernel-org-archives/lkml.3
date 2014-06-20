Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaFTXtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:49:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45687 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaFTXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:49:18 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] lib: list_sort_test(): Add extra corruption check
Date: Sat, 21 Jun 2014 01:49:02 +0200
Message-Id: <1403308142-25897-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403308142-25897-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403308142-25897-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to make sure that the prev pointer of the list head points
to the last element on the list.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/list_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 291412a..832f525 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -272,6 +272,11 @@ static int __init list_sort_test(void)
 		}
 		count++;
 	}
+	if (head->prev != cur) {
+		printk(KERN_ERR "list_sort_test: error: list is corrupted\n");
+		goto exit;
+	}
+
 
 	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort_test: error: bad list length %d",
-- 
1.9.2

