Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaBJF5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:57:16 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17374 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaBJF5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:57:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 09 Feb 2014 21:54:54 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/nouveau/fifo: allocate usermem as needed
Date: Mon, 10 Feb 2014 14:57:01 +0900
Message-ID: <1392011821-2406-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory was always allocated for 4096 channels. Change this to allocate
what we actually need according to the number of channels we use.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
index 9a850fe19515..99c9deea248f 100644
--- a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
@@ -852,8 +852,8 @@ nve0_fifo_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 			return ret;
 	}
 
-	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 4096 * 0x200, 0x1000,
-				 NVOBJ_FLAG_ZERO_ALLOC, &priv->user.mem);
+	ret = nouveau_gpuobj_new(nv_object(priv), NULL, impl->channels * 0x200,
+				0x1000, NVOBJ_FLAG_ZERO_ALLOC, &priv->user.mem);
 	if (ret)
 		return ret;
 
-- 
1.8.5.4

