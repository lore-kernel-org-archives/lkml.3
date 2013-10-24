Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3JXPXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:23:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3JXPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:23:15 -0400
Message-Id: <20131024152313.871381469@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Oct 2013 08:19:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] kernel: fix generic_exec_single indication
References: <20131024151921.537751910@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-kernel-fix-generic_exec_single-indication.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 2b83645..53644e6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -139,8 +139,7 @@ static void csd_unlock(struct call_single_data *csd)
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static
-void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
+static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	unsigned long flags;
-- 
1.7.10.4


