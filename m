Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbaLOMVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:21:48 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:37168 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLOMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:21:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rds: Fix min() warning in rds_message_inc_copy_to_user()
Date: Mon, 15 Dec 2014 13:21:42 +0100
Message-Id: <1418646102-32415-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/rds/message.c: In function ‘rds_message_inc_copy_to_user’:
net/rds/message.c:328: warning: comparison of distinct pointer types lacks a cast

Use min_t(unsigned long, ...) like is done in
rds_message_copy_from_user().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/rds/message.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index ff22022181875303..5a21e6f5986f1b82 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -325,7 +325,8 @@ int rds_message_inc_copy_to_user(struct rds_incoming *inc, struct iov_iter *to)
 	copied = 0;
 
 	while (iov_iter_count(to) && copied < len) {
-		to_copy = min(iov_iter_count(to), sg->length - vec_off);
+		to_copy = min_t(unsigned long, iov_iter_count(to),
+				sg->length - vec_off);
 		to_copy = min_t(unsigned long, to_copy, len - copied);
 
 		rds_stats_add(s_copy_to_user, to_copy);
-- 
1.9.1

