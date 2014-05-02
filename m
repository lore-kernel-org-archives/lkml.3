Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaEBJdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:33:49 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15463 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaEBJdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 May 2014 02:24:04 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 1/9] drm/nouveau/bar: only ioremap BAR3 if it exists
Date: Fri, 2 May 2014 18:32:34 +0900
Message-ID: <1399023162-13159-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chips that use system memory exclusively (e.g. GK20A) do not
expose 2 BAR regions. For them only BAR1 exists, and it should be used
for USERD mapping. Do not map BAR3 if its resource does not exist.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
index bdf594116f3f..73b1ed20c8d5 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
@@ -118,8 +118,10 @@ nouveau_bar_create_(struct nouveau_object *parent,
 	if (ret)
 		return ret;
 
-	bar->iomem = ioremap(nv_device_resource_start(device, 3),
-			     nv_device_resource_len(device, 3));
+	if (nv_device_resource_len(device, 3) != 0)
+		bar->iomem = ioremap(nv_device_resource_start(device, 3),
+				     nv_device_resource_len(device, 3));
+
 	return 0;
 }
 
-- 
1.9.2

