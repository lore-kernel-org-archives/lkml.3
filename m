Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaDUGEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:04:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14788 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaDUGES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:04:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 Apr 2014 22:56:06 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 09/10] drm/nouveau: support GK20A in nouveau_accel_init()
Date: Mon, 21 Apr 2014 15:02:21 +0900
Message-ID: <1398060142-7937-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip the creation of a software channel for GK20A as software methods
are not yet supported.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index ddd83756b9a2..5b46148ffd32 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -208,6 +208,10 @@ nouveau_accel_init(struct nouveau_drm *drm)
 		return;
 	}
 
+	/* Need to figure out how to handle sw for gk20a */
+	if (device->chipset == 0xea)
+		goto skip_sw_init;
+
 	ret = nouveau_object_new(nv_object(drm), NVDRM_CHAN, NVDRM_NVSW,
 				 nouveau_abi16_swclass(drm), NULL, 0, &object);
 	if (ret == 0) {
@@ -234,6 +238,7 @@ nouveau_accel_init(struct nouveau_drm *drm)
 		return;
 	}
 
+skip_sw_init:
 	if (device->card_type < NV_C0) {
 		ret = nouveau_gpuobj_new(drm->device, NULL, 32, 0, 0,
 					&drm->notify);
-- 
1.9.2

