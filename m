Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaJ0Jtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3013 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaJ0Jtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Oct 2014 02:48:56 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 1/4] drm: introduce nv_device_is_cpu_coherent()
Date: Mon, 27 Oct 2014 18:49:16 +0900
Message-ID: <1414403359-22332-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
References: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
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
 lib/core/os.h              | 2 ++
 nvkm/include/core/device.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/lib/core/os.h b/lib/core/os.h
index fba9542292ac..79462eb2cfd4 100644
--- a/lib/core/os.h
+++ b/lib/core/os.h
@@ -101,6 +101,8 @@ typedef dma_addr_t resource_size_t;
 #define __printf(a,b)
 #define __user
 
+#define IS_ENABLED(x) (0)
+
 static inline int
 order_base_2(u64 base)
 {
diff --git a/nvkm/include/core/device.h b/nvkm/include/core/device.h
index 1d9d893929bb..0d839e1ddaf4 100644
--- a/nvkm/include/core/device.h
+++ b/nvkm/include/core/device.h
@@ -158,6 +158,12 @@ nv_device_is_pci(struct nouveau_device *device)
 	return device->pdev != NULL;
 }
 
+static inline bool
+nv_device_is_cpu_coherent(struct nouveau_device *device)
+{
+	return (!IS_ENABLED(CONFIG_ARM) && nv_device_is_pci(device));
+}
+
 static inline struct device *
 nv_device_base(struct nouveau_device *device)
 {
-- 
2.1.2

