Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbaBAD3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:17 -0500
Received: from gnurou.org ([207.192.72.5]:51797 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbaBAD2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:25 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 16/16] drm/nouveau: support for probing GK20A
Date: Sat,  1 Feb 2014 12:16:58 +0900
Message-Id: <1391224618-3794-17-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the correct subdev/engine classes when GK20A (0xea) is probed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
index 987edbc..30d652e 100644
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
+		device->oclass[NVDEV_ENGINE_GR     ] =  nve4_graph_oclass;
+		device->oclass[NVDEV_ENGINE_COPY2  ] = &nve0_copy2_oclass;
+		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
+		break;
 	case 0xf0:
 		device->cname = "GK110";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-- 
1.8.5.3

