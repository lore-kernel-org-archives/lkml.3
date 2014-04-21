Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaDUGEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:04:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3882 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaDUGEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:04:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 20 Apr 2014 22:58:42 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 07/10] drm/nouveau/graph: pad firmware code at load time
Date: Mon, 21 Apr 2014 15:02:19 +0900
Message-ID: <1398060142-7937-8-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pad the microcode to a multiple of 0x40 bytes, otherwise firmware will
fail to run from non-prepadded firmware files.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index e5b75f189988..013475c62986 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -894,6 +894,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
 			nv_wr32(priv, fuc_base + 0x0188, i >> 6);
 		nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
 	}
+
+	/* code must be padded to 0x40 bytes */
+	for (; i & 0x3f; i++)
+		nv_wr32(priv, fuc_base + 0x0184, 0);
 }
 
 static void
-- 
1.9.2

