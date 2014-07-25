Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935296AbaGYRiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:38:00 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35912 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934792AbaGYRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:37:56 -0400
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv2 2/2] gpu: drm: omapdrm: Change struct pat data_pa type to dma_addr_t
Date: Fri, 25 Jul 2014 21:37:37 +0400
Message-Id: <1406309857-11141-2-git-send-email-matwey.kornilov@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406309857-11141-1-git-send-email-matwey.kornilov@gmail.com>
References: <1406309857-11141-1-git-send-email-matwey.kornilov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

The single one use-case for data_pa member of the struct pat is to carry a value of dma_addr_t type.
This patch solves the following compilation error:

../drivers/gpu/drm/omapdrm/omap_dmm_tiler.c: In function 'dmm_txn_append':
../drivers/gpu/drm/omapdrm/omap_dmm_tiler.c:226:2: error: passing argument 3 of 'alloc_dma' from incompatible pointer type [-Werror]
  data = alloc_dma(txn, 4*i, &pat->data_pa);
  ^
../drivers/gpu/drm/omapdrm/omap_dmm_tiler.c:77:14: note: expected 'dma_addr_t *' but argument is of type 'uint32_t *'
 static void *alloc_dma(struct dmm_txn *txn, size_t sz, dma_addr_t *pa)
              ^

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/gpu/drm/omapdrm/omap_dmm_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_priv.h b/drivers/gpu/drm/omapdrm/omap_dmm_priv.h
index 58bcd6a..4142525 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_priv.h
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_priv.h
@@ -105,7 +105,7 @@ struct pat {
 	uint32_t next_pa;
 	struct pat_area area;
 	struct pat_ctrl ctrl;
-	uint32_t data_pa;
+	dma_addr_t data_pa;
 };
 
 #define DMM_FIXED_RETRY_COUNT 1000
-- 
1.8.1.4

