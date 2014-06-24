Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaFXKIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:08:12 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55540 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaFXKHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:07:00 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 1/4] lib: list_sort_test(): Return -ENOMEM when allocation fails
Date: Tue, 24 Jun 2014 12:06:28 +0200
Message-Id: <1403604392-23259-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/list_sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 1183fa7..291412a 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -207,7 +207,7 @@ static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
 
 static int __init list_sort_test(void)
 {
-	int i, count = 1, err = -EINVAL;
+	int i, count = 1, err = -ENOMEM;
 	struct debug_el *el;
 	struct list_head *cur, *tmp;
 	LIST_HEAD(head);
@@ -239,6 +239,7 @@ static int __init list_sort_test(void)
 
 	list_sort(NULL, &head, cmp);
 
+	err = -EINVAL;
 	for (cur = head.next; cur->next != &head; cur = cur->next) {
 		struct debug_el *el1;
 		int cmp_result;
-- 
1.9.2

