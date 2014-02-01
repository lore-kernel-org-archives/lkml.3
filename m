Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaBAD3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:01 -0500
Received: from gnurou.org ([207.192.72.5]:51774 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaBAD2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [RFC 04/16] drm/nouveau/fifo: support platform devices
Date: Sat,  1 Feb 2014 12:16:46 +0900
Message-Id: <1391224618-3794-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PCI-dependent code so the FIFO engine can also handle platform
devices.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/base.c b/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
index d3ec436d9..6f9041c 100644
--- a/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
@@ -86,7 +86,7 @@ nouveau_fifo_channel_create_(struct nouveau_object *parent,
 	}
 
 	/* map fifo control registers */
-	chan->user = ioremap(pci_resource_start(device->pdev, bar) + addr +
+	chan->user = ioremap(nv_device_resource_start(device, bar) + addr +
 			     (chan->chid * size), size);
 	if (!chan->user)
 		return -EFAULT;
-- 
1.8.5.3

