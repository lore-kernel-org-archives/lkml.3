Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaLBEsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:48:46 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15240 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaLBEso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:48:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Dec 2014 20:46:57 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <tbergstrom@nvidia.com>
CC: <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 3/4] platform: add GPU speedo information to nouveau platform
Date: Tue, 2 Dec 2014 12:50:34 +0800
Message-ID: <1417495835-5556-3-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
References: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For GK20A we need the GPU speedo value to calculate voltage levels.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/nouveau_platform.c | 2 ++
 drm/nouveau_platform.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
index 9945c2ec2ca3..8871a21ad8fc 100644
--- a/drm/nouveau_platform.c
+++ b/drm/nouveau_platform.c
@@ -28,6 +28,7 @@
 #include <linux/of_device.h>
 #include <linux/reset.h>
 #include <linux/regulator/consumer.h>
+#include <soc/tegra/fuse.h>
 #include <soc/tegra/pmc.h>
 
 #include "nouveau_drm.h"
@@ -179,6 +180,7 @@ static int nouveau_platform_probe(struct platform_device *pdev)
 	}
 
 	device->gpu = gpu;
+	device->gpu_speedo = tegra_sku_info.gpu_speedo_value;
 
 	err = drm_dev_register(drm, 0);
 	if (err < 0)
diff --git a/drm/nouveau_platform.h b/drm/nouveau_platform.h
index 7fe17d1df931..9753a2ea342a 100644
--- a/drm/nouveau_platform.h
+++ b/drm/nouveau_platform.h
@@ -43,6 +43,8 @@ struct nouveau_platform_device {
 	struct nouveau_device device;
 
 	struct nouveau_platform_gpu *gpu;
+
+	int gpu_speedo;
 };
 
 #define nv_device_to_platform(d)                                               \
-- 
1.9.1

