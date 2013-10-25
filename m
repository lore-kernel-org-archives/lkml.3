Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3JYKgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:36:39 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53432 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3JYKgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:36:36 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] drivers: mspro: fix attributes array allocation
Date: Fri, 25 Oct 2013 11:36:28 +0100
Message-Id: <04eadffca1bf860e2edc66cc372c36cac1e8b668.1382697178.git.mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

attrs field of attribute_group structure is a pointer to a pointer
(as in an array of pointers) rather than pointer to attribute
struct (as in an array of structures), so when allocating size
of the pointer sholud be used instead of the structure it is
pointing to.

While at it, also change the call to use kcalloc rather than
kzalloc.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/memstick/core/mspro_block.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index f4176ca..fc145d2 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1023,8 +1023,8 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 	} else
 		attr_count = attr->count;
 
-	msb->attr_group.attrs = kzalloc((attr_count + 1)
-					* sizeof(struct attribute),
+	msb->attr_group.attrs = kcalloc(attr_count + 1,
+					sizeof(*msb->attr_group.attrs),
 					GFP_KERNEL);
 	if (!msb->attr_group.attrs) {
 		rc = -ENOMEM;
-- 
1.8.4

