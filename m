Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3IWGHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:07:23 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49851 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3IWGHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:07:21 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 14:07:20 +0800
Message-ID: <CAPgLHd9SeN1OdCKqTP2w_rFi3TWD=b+7vL4iwx53KwnMF23Nxg@mail.gmail.com>
Subject: [PATCH -next] dma: mmp_pdma: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, djbw@fb.com, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/mmp_pdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index ff8d7827..558994f 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -798,8 +798,7 @@ static void dma_do_tasklet(unsigned long data)
 		 * move the descriptors to a temporary list so we can drop
 		 * the lock during the entire cleanup operation
 		 */
-		list_del(&desc->node);
-		list_add(&desc->node, &chain_cleanup);
+		list_move(&desc->node, &chain_cleanup);
 
 		/*
 		 * Look for the first list entry which has the ENDIRQEN flag

