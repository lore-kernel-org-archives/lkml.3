Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaEBJeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:34:21 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15473 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaEBJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:34:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 May 2014 02:24:23 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 9/9] drm/nouveau: support for probing GK20A
Date: Fri, 2 May 2014 18:32:42 +0900
Message-ID: <1399023162-13159-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the correct subdev/engine classes when GK20A (0xea) is probed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
index 9784cbf8a9d2..964c183322a2 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
@@ -156,6 +156,23 @@ nve0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
 		break;
+	case 0xea:
+		device->cname = "GK20A";
+		device->oclass[NVDEV_SUBDEV_MC     ] =  nvc3_mc_oclass;
+		device->oclass[NVDEV_SUBDEV_BUS    ] =  nvc0_bus_oclass;
+		device->oclass[NVDEV_SUBDEV_TIMER  ] = &gk20a_timer_oclass;
+		device->oclass[NVDEV_SUBDEV_FB     ] =  gk20a_fb_oclass;
+		device->oclass[NVDEV_SUBDEV_IBUS   ] = &gk20a_ibus_oclass;
+		device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
+		device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
+		device->oclass[NVDEV_SUBDEV_BAR    ] = &nvc0_bar_oclass;
+		device->oclass[NVDEV_ENGINE_DMAOBJ ] = &nvd0_dmaeng_oclass;
+		device->oclass[NVDEV_ENGINE_FIFO   ] =  gk20a_fifo_oclass;
+		device->oclass[NVDEV_ENGINE_SW     ] =  nvc0_software_oclass;
+		device->oclass[NVDEV_ENGINE_GR     ] =  gk20a_graph_oclass;
+		device->oclass[NVDEV_ENGINE_COPY2  ] = &nve0_copy2_oclass;
+		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
+		break;
 	case 0xf0:
 		device->cname = "GK110";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-- 
1.9.2

