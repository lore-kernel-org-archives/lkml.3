Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3CKTkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:40:55 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33910 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3CKTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:40:53 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: gpu: drm: Replaced ERR_PTR & PTR_ERR with ERR_CAST
Date: Mon, 11 Mar 2013 21:40:13 +0200
Message-Id: <1363030813-22354-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced ERR_PTR and PTR_ERR calls with ERR_CAST.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/gpu/drm/drm_prime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 366910d..4c8adda 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -275,7 +275,7 @@ struct drm_gem_object *drm_gem_prime_import(struct drm_device *dev,
 
 	attach = dma_buf_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
-		return ERR_PTR(PTR_ERR(attach));
+		return ERR_CAST(attach);
 
 	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR_OR_NULL(sgt)) {
-- 
1.7.9.5

