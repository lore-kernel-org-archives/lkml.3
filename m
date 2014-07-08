Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaGHWYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:24:45 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34081 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaGHWYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:24:44 -0400
Date: Wed, 9 Jul 2014 03:54:37 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] kfifo: use BUG_ON
Message-ID: <20140708222437.GA11916@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:

// <smpl>
@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
To send to: linux-kernel@vger.kernel.org
 lib/kfifo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/kfifo.c b/lib/kfifo.c
index d79b9d2..90ba1eb 100644
--- a/lib/kfifo.c
+++ b/lib/kfifo.c
@@ -561,8 +561,7 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
 unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 
@@ -585,8 +584,7 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
 unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
 	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
 {
-	if (!nents)
-		BUG();
+	BUG_ON(!nents);
 
 	len = __kfifo_max_r(len, recsize);
 
-- 
1.9.1

