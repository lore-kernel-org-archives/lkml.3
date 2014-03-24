Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaCXIqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2987 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaCXIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Mar 2014 01:42:29 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 12/12] drm/nouveau: support for probing GK20A
Date: Mon, 24 Mar 2014 17:42:34 +0900
Message-ID: <1395650554-31925-13-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the correct subdev/engine classes when GK20A (0xea) is probed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
index 987edbc30a09..8509dd57de1f 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
@@ -156,6 +156,26 @@ nve0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
 		break;
+	case 0xea:
+		device->cname = "GK20A";
+		device->oclass[NVDEV_SUBDEV_MC     ] =  nvc3_mc_oclass;
+		device->oclass[NVDEV_SUBDEV_BUS    ] =  nvc0_bus_oclass;
+		device->oclass[NVDEV_SUBDEV_TIMER  ] = &nv04_timer_oclass;
+		device->oclass[NVDEV_SUBDEV_FB     ] =  nvea_fb_oclass;
+		device->oclass[NVDEV_SUBDEV_IBUS   ] = &nvea_ibus_oclass;
+		device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
+		device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
+		device->oclass[NVDEV_SUBDEV_BAR    ] = &nvc0_bar_oclass;
+		device->oclass[NVDEV_ENGINE_DMAOBJ ] = &nvd0_dmaeng_oclass;
+		device->oclass[NVDEV_ENGINE_FIFO   ] =  nvea_fifo_oclass;
+		/* TODO will need an implementation for this at some point... */
+#if 0
+		device->oclass[NVDEV_ENGINE_SW     ] =  nvc0_software_oclass;
+#endif
+		device->oclass[NVDEV_ENGINE_GR     ] =  nvea_graph_oclass;
+		device->oclass[NVDEV_ENGINE_COPY2  ] = &nve0_copy2_oclass;
+		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
+		break;
 	case 0xf0:
 		device->cname = "GK110";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-- 
1.9.1

