Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3JGWSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:18:43 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:38904 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:18:42 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: airlied@linux.ie, bskeggs@redhat.com, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] drm: nouveau: fix nvbe leakage
Date: Mon,  7 Oct 2013 19:14:26 -0300
Message-Id: <1381184066-10684-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free memory allocated to nvbe when returning NULL.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 0843ebc..af8b66d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -105,6 +105,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
 		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
 
 	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
+	{
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
-- 
1.8.4

