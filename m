Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3JHDhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:37:48 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33941 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JHDhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:37:45 -0400
From: baker.kernel@gmail.com
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "baker.zhang" <baker.kernel@gmail.com>
Subject: [PATCH net-next] fib_trie: only calc for the un-first node
Date: Tue,  8 Oct 2013 11:36:51 +0800
Message-Id: <1381203411-12047-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "baker.zhang" <baker.kernel@gmail.com>

This is a enhancement.

for the first node in fib_trie, newpos is 0, bit is 1.
Only for the leaf or node with unmatched key need calc pos.

Signed-off-by: baker.zhang <baker.kernel@gmail.com>
---
 net/ipv4/fib_trie.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 45c74ba..ec9a9ef 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1117,12 +1117,8 @@ static struct list_head *fib_insert_node(struct trie *t, u32 key, int plen)
 		 *  first tnode need some special handling
 		 */
 
-		if (tp)
-			pos = tp->pos+tp->bits;
-		else
-			pos = 0;
-
 		if (n) {
+			pos = tp ? tp->pos+tp->bits : 0;
 			newpos = tkey_mismatch(key, pos, n->key);
 			tn = tnode_new(n->key, newpos, 1);
 		} else {
-- 
1.7.9.5

