Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaF0LXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:23:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16413 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaF0LWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:22:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 04:12:48 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 2/2] drm/nouveau: use DMA TT population method on ARM
Date: Fri, 27 Jun 2014 20:22:14 +0900
Message-ID: <1403868134-31741-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
References: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cached memory accesses between the CPU and the GPU are not coherent on
ARM. Use the DMA TTM allocator on this architecture to obtain coherent
memory.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_ttm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index 70893416d4b6..d77fc8a5167d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -385,6 +385,8 @@ nouveau_ttm_init(struct nouveau_drm *drm)
 	if (swiotlb_nr_tbl())
 		drm->ttm.populate_method = DMA;
 #endif
+	if (IS_ENABLED(CONFIG_ARM))
+		drm->ttm.populate_method = DMA;
 #if defined(TTM_HAS_AGP)
 	if (drm->agp.stat == ENABLED)
 		drm->ttm.populate_method = AGP;
-- 
2.0.0

