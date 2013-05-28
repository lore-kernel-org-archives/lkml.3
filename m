Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab3E1JH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:07:56 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:64651 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab3E1JHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:07:55 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 17:07:54 +0800
Message-ID: <CAPgLHd9kMzZ_ZY6zm0MZ+P6dHq73i_GdCsxhpUOt-V9nf08tWA@mail.gmail.com>
Subject: [PATCH -next] dmaengine: ste_dma40: add missing iounmap() on error in d40_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org, djbw@fb.com,
        vinod.koul@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing iounmap() before return from d40_probe()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/ste_dma40.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 71bf4ec..018c2f7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3612,6 +3612,8 @@ failure:
 			kmem_cache_destroy(base->desc_slab);
 		if (base->virtbase)
 			iounmap(base->virtbase);
+		if (base->lcpa_base)
+			iounmap(base->lcpa_base);
 
 		if (base->lcla_pool.base && base->plat_data->use_esram_lcla) {
 			iounmap(base->lcla_pool.base);

