Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaBAD3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:03 -0500
Received: from gnurou.org ([207.192.72.5]:51778 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaBAD2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:23 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 11/16] drm/nouveau/fifo: allocate usermem as needed
Date: Sat,  1 Feb 2014 12:16:53 +0900
Message-Id: <1391224618-3794-12-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
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
index 54c1b5b..dbc3ff6 100644
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
1.8.5.3

