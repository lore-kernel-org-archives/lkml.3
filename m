Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3JXPXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:23:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:23:15 -0400
Message-Id: <20131024152313.743165517@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Oct 2013 08:19:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] kernel: provide a __smp_call_function_single stub for !CONFIG_SMP
References: <20131024151921.537751910@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-kernel-provide-a-__smp_call_function_single-stub-for.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/up.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/up.c b/kernel/up.c
index 630d72b..509403e 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -22,6 +22,17 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+void __smp_call_function_single(int cpu, struct call_single_data *csd,
+				int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	csd->func(csd->info);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(__smp_call_function_single);
+
 int on_each_cpu(smp_call_func_t func, void *info, int wait)
 {
 	unsigned long flags;
-- 
1.7.10.4


