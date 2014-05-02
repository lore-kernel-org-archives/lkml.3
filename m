Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaEBQUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:20:09 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:63559 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbaEBQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:20:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwaAIPFY1NbsmU4/2dsb2JhbABagwaCQakeAwEBAQEBAQQBmgECAoEQF3SCZhwjGIECJBOIRQHKTIVWiHyEQAEDjxaKGQGSb4M2Ow
Date: Fri, 2 May 2014 18:21:45 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/blk-iopoll.c: use iop instead of iopoll
Message-Id: <20140502182145.81faf8aba278b9da524d3ec6@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All blk_iopoll functions use iop for parent iopoll structure except
blk_iopoll_complete.This also fixes one kernel-doc warning.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-iopoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index c11d24e..d828b44 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -64,12 +64,12 @@ EXPORT_SYMBOL(__blk_iopoll_complete);
  *     iopoll handler will not be invoked again before blk_iopoll_sched_prep()
  *     is called.
  **/
-void blk_iopoll_complete(struct blk_iopoll *iopoll)
+void blk_iopoll_complete(struct blk_iopoll *iop)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__blk_iopoll_complete(iopoll);
+	__blk_iopoll_complete(iop);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_iopoll_complete);
-- 
1.8.4.5

