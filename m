Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3HEJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:09:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57085 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3HEJJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:09:25 -0400
Message-ID: <51FF6BBD.2090606@huawei.com>
Date: Mon, 5 Aug 2013 17:09:17 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] cma: use macro PFN_DOWN when converting size to pages
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
 drivers/base/dma-contiguous.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 0ca5442..b3d711d 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -206,8 +206,7 @@ static int __init cma_init_reserved_areas(void)
 
 	for (; i; --i, ++r) {
 		struct cma *cma;
-		cma = cma_create_area(PFN_DOWN(r->start),
-				      r->size >> PAGE_SHIFT);
+		cma = cma_create_area(PFN_DOWN(r->start), PFN_DOWN(r->size));
 		if (!IS_ERR(cma))
 			dev_set_cma_area(r->dev, cma);
 	}
-- 
1.7.1

