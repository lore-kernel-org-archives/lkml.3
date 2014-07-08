Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaGHI2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:28:39 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16191 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaGHI0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jul 2014 01:15:57 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 3/6] drm/nouveau: introduce nv_device_is_cpu_coherent()
Date: Tue, 8 Jul 2014 17:25:58 +0900
Message-ID: <1404807961-30530-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function allowing us to know whether a device is CPU-coherent,
i.e. accesses performed by the CPU on GPU-mapped buffers will
be immediately visible on the GPU side and vice-versa.

For now, a device is considered to be coherent if it uses the PCI bus on
a non-ARM architecture.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/base.c  | 6 ++++++
 drivers/gpu/drm/nouveau/core/include/core/device.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
index e4e9e64988fe..23c7061aac3c 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
@@ -520,6 +520,12 @@ nv_device_get_irq(struct nouveau_device *device, bool stall)
 	}
 }
 
+bool
+nv_device_is_cpu_coherent(struct nouveau_device *device)
+{
+	return (!IS_ENABLED(CONFIG_ARM) && nv_device_is_pci(device));
+}
+
 static struct nouveau_oclass
 nouveau_device_oclass = {
 	.handle = NV_ENGINE(DEVICE, 0x00),
diff --git a/drivers/gpu/drm/nouveau/core/include/core/device.h b/drivers/gpu/drm/nouveau/core/include/core/device.h
index a8a9a9cf16cb..1f9d5d87cf06 100644
--- a/drivers/gpu/drm/nouveau/core/include/core/device.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/device.h
@@ -171,4 +171,7 @@ nv_device_unmap_page(struct nouveau_device *device, dma_addr_t addr);
 int
 nv_device_get_irq(struct nouveau_device *device, bool stall);
 
+bool
+nv_device_is_cpu_coherent(struct nouveau_device *device);
+
 #endif
-- 
2.0.0

