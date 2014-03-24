Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaCXIq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:26 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7393 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXIqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Mar 2014 01:42:21 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 09/12] drm/nouveau/graph: pad firmware code at load time
Date: Mon, 24 Mar 2014 17:42:31 +0900
Message-ID: <1395650554-31925-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pad the microcode to a multiple of 0x40, otherwise firmware will fail to
run from non-prepadded firmware files.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index f997a18f5760..367e72daf8b1 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -768,6 +768,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
 			nv_wr32(priv, fuc_base + 0x0188, i >> 6);
 		nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
 	}
+
+	/* code must be padded to 0x40 */
+	for (; i < (((code->size / 4) + 0x3f) & ~0x3f); i++)
+		nv_wr32(priv, fuc_base + 0x0184, 0);
 }
 
 static void
-- 
1.9.1

