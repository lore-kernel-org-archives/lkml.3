Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3HEIbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:31:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:15319 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3HEIbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:31:14 -0400
Message-ID: <51FF62C4.9010001@huawei.com>
Date: Mon, 5 Aug 2013 16:31:00 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cma: use macro PFN_DOWN when converting size to pages
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "PFN_DOWN(r->size)" instead of "r->size >> PAGE_SHIFT".

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/base/dma-contiguous.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 0ca5442..1bcfaed 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -201,13 +201,12 @@ static int __init cma_init_reserved_areas(void)
 {
 	struct cma_reserved *r = cma_reserved;
 	unsigned i = cma_reserved_count;
+	struct cma *cma;
 
 	pr_debug("%s()\n", __func__);
 
 	for (; i; --i, ++r) {
-		struct cma *cma;
-		cma = cma_create_area(PFN_DOWN(r->start),
-				      r->size >> PAGE_SHIFT);
+		cma = cma_create_area(PFN_DOWN(r->start), PFN_DOWN(r->size));
 		if (!IS_ERR(cma))
 			dev_set_cma_area(r->dev, cma);
 	}
-- 
1.7.1


